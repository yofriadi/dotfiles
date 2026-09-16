package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"
)

type SessionHeader struct {
	Type          string `json:"type"`
	Version       int    `json:"version"`
	ID            string `json:"id"`
	Timestamp     string `json:"timestamp"`
	Cwd           string `json:"cwd"`
	ParentSession string `json:"parentSession"`
}

type CustomMarkerData struct {
	Kind           string `json:"kind"`
	Title          string `json:"title"`
	ChildSessionID string `json:"childSessionId"`
	SourceFile     string `json:"sourceFile"`
	Cwd            string `json:"cwd"`
	SubagentType   string `json:"subagentType,omitempty"`
	Description    string `json:"description,omitempty"`
	MergedAt       string `json:"mergedAt"`
}

type CustomMarker struct {
	Type       string           `json:"type"`
	CustomType string           `json:"customType"`
	Data       CustomMarkerData `json:"data"`
	Timestamp  string           `json:"timestamp"`
}

type ToolCallInfo struct {
	Timestamp    string
	SubagentType string
	Description  string
	Matched      bool
}

// RawToolCall represents a tool call from any nesting level.
// Supports `arguments` (object or serialized string) and `args` (alias).
type RawToolCall struct {
	Name      string          `json:"name"`
	Arguments json.RawMessage `json:"arguments"`
	Args      json.RawMessage `json:"args"`
}

// SubagentArgs is the parsed arguments of a subagent tool call.
type SubagentArgs struct {
	SubagentType      string `json:"subagent_type"`
	SubagentTypeCamel string `json:"subagentType"`
	Description       string `json:"description"`
}

type LogStream interface {
	Next() bool
	Value() (string, string)
	Err() error
	Close() error
}

type FileStream struct {
	file    *os.File
	scanner *bufio.Scanner
	current string
	currTS  string
	err     error
}


func NewFileStream(path string) (*FileStream, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	scanner := bufio.NewScanner(f)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 10*1024*1024)
	return &FileStream{file: f, scanner: scanner}, nil
}

func (s *FileStream) Next() bool {
	if s.err != nil {
		return false
	}
	for s.scanner.Scan() {
		line := strings.TrimSpace(s.scanner.Text())
		if line == "" {
			continue
		}
		s.current = line
		// Extract timestamp
		var meta struct {
			Timestamp string `json:"timestamp"`
		}
		if err := json.Unmarshal([]byte(line), &meta); err != nil {
			s.err = fmt.Errorf("failed to parse entry: %w", err)
			return false
		}
		s.currTS = meta.Timestamp
		return true
	}
	s.err = s.scanner.Err()
	return false
}

func (s *FileStream) Value() (string, string) {
	return s.current, s.currTS
}

func (s *FileStream) Err() error {
	return s.err
}

func (s *FileStream) Close() error {
	if s.file == nil {
		return nil
	}
	err := s.file.Close()
	s.file = nil
	return err
}

type ParentStream struct {
	fs *FileStream
}

func NewParentStream(path string) (*ParentStream, error) {
	fs, err := NewFileStream(path)
	if err != nil {
		return nil, err
	}
	// Skip the first line (header)
	fs.Next()
	return &ParentStream{fs: fs}, nil
}

func (ps *ParentStream) Next() bool {
	return ps.fs.Next()
}

func (ps *ParentStream) Value() (string, string) {
	return ps.fs.Value()
}

func (ps *ParentStream) Err() error {
	return ps.fs.Err()
}

func (ps *ParentStream) Close() error {
	return ps.fs.Close()
}

type ChildStream struct {
	fs            *FileStream
	markerPending bool
	markerRaw     string
	markerTS      string
	current       string
	currTS        string
	err           error
	header        SessionHeader
}

func NewChildStream(path string, parentID string, title string, subagentType string, description string) (*ChildStream, error) {
	fs, err := NewFileStream(path)
	if err != nil {
		return nil, err
	}
	// Read the first line (header)
	if !fs.Next() {
		fs.Close()
		if fs.Err() != nil {
			return nil, fs.Err()
		}
		return nil, fmt.Errorf("empty child file %s", filepath.Base(path))
	}
	headerLine, _ := fs.Value()
	var header SessionHeader
	if err := json.Unmarshal([]byte(headerLine), &header); err != nil {
		fs.Close()
		return nil, fmt.Errorf("failed to parse child header in %s: %w", filepath.Base(path), err)
	}
	if header.Type != "session" {
		fs.Close()
		return nil, fmt.Errorf("child %s header type is not 'session'", filepath.Base(path))
	}
	if header.ParentSession == "" {
		fs.Close()
		return nil, fmt.Errorf("child %s is missing parentSession id", filepath.Base(path))
	}
	if header.ParentSession != parentID {
		fs.Close()
		return nil, fmt.Errorf("child %s parentSession %s does not match parent id %s", filepath.Base(path), header.ParentSession, parentID)
	}
	if header.ID == "" {
		fs.Close()
		return nil, fmt.Errorf("child %s is missing session id", filepath.Base(path))
	}

	// Synthesize custom marker
	marker := CustomMarker{
		Type:       "custom",
		CustomType: fmt.Sprintf("subagent: %s", title),
		Data: CustomMarkerData{
			Kind:           "merged-subagent-session",
			Title:          title,
			ChildSessionID: header.ID,
			SourceFile:     filepath.Base(path),
			Cwd:            header.Cwd,
			SubagentType:   subagentType,
			Description:    description,
			MergedAt:       time.Now().UTC().Format(time.RFC3339Nano),
		},
		Timestamp: header.Timestamp,
	}
	markerBytes, err := json.Marshal(marker)
	if err != nil {
		fs.Close()
		return nil, fmt.Errorf("failed to marshal custom marker: %w", err)
	}

	return &ChildStream{
		fs:            fs,
		markerPending: true,
		markerRaw:     string(markerBytes),
		markerTS:      header.Timestamp,
		header:        header,
	}, nil
}

func (cs *ChildStream) Next() bool {
	if cs.err != nil {
		return false
	}
	if cs.markerPending {
		cs.current = cs.markerRaw
		cs.currTS = cs.markerTS
		cs.markerPending = false
		return true
	}
	if cs.fs.Next() {
		cs.current, cs.currTS = cs.fs.Value()
		return true
	}
	cs.err = cs.fs.Err()
	return false
}

func (cs *ChildStream) Value() (string, string) {
	return cs.current, cs.currTS
}

func (cs *ChildStream) Err() error {
	return cs.err
}

func (cs *ChildStream) Close() error {
	return cs.fs.Close()
}

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: go run merge_subsessions.go <parent_session.jsonl> <tasks_directory>")
		os.Exit(1)
	}

	parentPath := os.Args[1]
	tasksDir := os.Args[2]

	if err := mergeSessions(parentPath, tasksDir); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(1)
	}
}

func readParentHeader(path string) (SessionHeader, string, error) {
	file, err := os.Open(path)
	if err != nil {
		return SessionHeader{}, "", err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 10*1024*1024)
	if !scanner.Scan() {
		if err := scanner.Err(); err != nil {
			return SessionHeader{}, "", err
		}
		return SessionHeader{}, "", fmt.Errorf("parent file is empty")
	}

	line := strings.TrimSpace(scanner.Text())
	var header SessionHeader
	if err := json.Unmarshal([]byte(line), &header); err != nil {
		return SessionHeader{}, "", fmt.Errorf("failed to parse parent header: %w", err)
	}
	if header.Type != "session" {
		return SessionHeader{}, "", fmt.Errorf("parent header type is not 'session'")
	}
	if header.ID == "" {
		return SessionHeader{}, "", fmt.Errorf("parent header is missing 'id'")
	}

	return header, line, nil
}

func parseSubagentArgs(raw json.RawMessage) (SubagentArgs, bool) {
	if len(raw) == 0 {
		return SubagentArgs{}, false
	}

	var args SubagentArgs
	if err := json.Unmarshal(raw, &args); err == nil {
		if args.SubagentType == "" {
			args.SubagentType = args.SubagentTypeCamel
		}
		if args.SubagentType != "" || args.Description != "" {
			return args, true
		}
	}

	var strVal string
	if err := json.Unmarshal(raw, &strVal); err == nil {
		if err := json.Unmarshal([]byte(strVal), &args); err == nil {
			if args.SubagentType == "" {
				args.SubagentType = args.SubagentTypeCamel
			}
			return args, true
		}
	}

	return SubagentArgs{}, false
}

// piMessage models the inner `message` field of a Pi `type: "message"` entry.
// Content may be either an array of content blocks (e.g. text, toolCall)
// or a plain string in some setups.
type piMessage struct {
	Role    string          `json:"role"`
	Content json.RawMessage `json:"content"`
}

// scanParentToolCalls walks the parent JSONL and collects all `subagent`
// tool calls. It understands the Pi `type: "message"` shape where the
// `message.content` field is an array of content blocks including
// `{"type": "toolCall", "name": "...", "arguments": {...}}`.
func scanParentToolCalls(parentPath string) ([]ToolCallInfo, error) {
	file, err := os.Open(parentPath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var toolCalls []ToolCallInfo
	scanner := bufio.NewScanner(file)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 10*1024*1024)

	// Skip header
	if !scanner.Scan() {
		return nil, scanner.Err()
	}

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		// Pull top-level timestamp first
		var top struct {
			Type      string    `json:"type"`
			Timestamp string    `json:"timestamp"`
			Message   piMessage `json:"message"`
		}
		if err := json.Unmarshal([]byte(line), &top); err != nil {
			continue
		}

		if top.Type != "message" {
			continue
		}

		// content can be a string or an array of blocks
		if len(top.Message.Content) == 0 {
			continue
		}

		// First, try parsing content as a string.
		var asString string
		if err := json.Unmarshal(top.Message.Content, &asString); err == nil {
			// No tool calls possible in a string content body.
			continue
		}

		// Otherwise, content is an array of blocks.
		var blocks []json.RawMessage
		if err := json.Unmarshal(top.Message.Content, &blocks); err != nil {
			continue
		}

		for _, rawBlock := range blocks {
			// Try the common Pi shape: {"type":"toolCall","name":"subagent","arguments":{...},...}
			var tc struct {
				Type      string          `json:"type"`
				Name      string          `json:"name"`
				Arguments json.RawMessage `json:"arguments"`
				Args      json.RawMessage `json:"args"`
			}
			if err := json.Unmarshal(rawBlock, &tc); err == nil && tc.Name == "subagent" {
				var args SubagentArgs
				var ok bool
				if len(tc.Arguments) > 0 {
					args, ok = parseSubagentArgs(tc.Arguments)
				}
				if !ok && len(tc.Args) > 0 {
					args, ok = parseSubagentArgs(tc.Args)
				}
				if ok {
					toolCalls = append(toolCalls, ToolCallInfo{
						Timestamp:    top.Timestamp,
						SubagentType: args.SubagentType,
						Description:  args.Description,
					})
				}
				continue
			}

			// Also support {"type":"function_call", ...} or a flat top-level
			// tool call representation embedded in a block.
			var flat RawToolCall
			if err := json.Unmarshal(rawBlock, &flat); err == nil && flat.Name == "subagent" {
				var args SubagentArgs
				var ok bool
				if len(flat.Arguments) > 0 {
					args, ok = parseSubagentArgs(flat.Arguments)
				}
				if !ok && len(flat.Args) > 0 {
					args, ok = parseSubagentArgs(flat.Args)
				}
				if ok {
					toolCalls = append(toolCalls, ToolCallInfo{
						Timestamp:    top.Timestamp,
						SubagentType: args.SubagentType,
						Description:  args.Description,
					})
				}
			}
		}
	}
	return toolCalls, scanner.Err()
}

func matchToolCall(childTS string, toolCalls []ToolCallInfo) (SubagentArgs, bool, int) {
	bestIdx := -1
	for i, tc := range toolCalls {
		if tc.Matched {
			continue
		}
		if tc.Timestamp <= childTS {
			if bestIdx == -1 || tc.Timestamp > toolCalls[bestIdx].Timestamp {
				bestIdx = i
			}
		}
	}
	if bestIdx != -1 {
		return SubagentArgs{
			SubagentType: toolCalls[bestIdx].SubagentType,
			Description:  toolCalls[bestIdx].Description,
		}, true, bestIdx
	}
	return SubagentArgs{}, false, -1
}

// findFirstUserMessage walks the child JSONL and returns the joined text
// content of the first user-role message.
//
// Pi stores message content as a JSON array of blocks like
//   [{"type": "text", "text": "..."}, {"type": "text", "text": "..."}]
// Some legacy shapes store content as a plain string. We support both.
func findFirstUserMessage(childPath string) (string, error) {
	file, err := os.Open(childPath)
	if err != nil {
		return "", err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 10*1024*1024)

	// Skip header
	if !scanner.Scan() {
		return "", scanner.Err()
	}

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		var top struct {
			Type    string    `json:"type"`
			Message piMessage `json:"message"`
		}
		if err := json.Unmarshal([]byte(line), &top); err != nil {
			continue
		}

		if top.Type != "message" || top.Message.Role != "user" {
			continue
		}

		if len(top.Message.Content) == 0 {
			continue
		}

		// Try plain string content first.
		var asString string
		if err := json.Unmarshal(top.Message.Content, &asString); err == nil {
			return asString, nil
		}

		// Otherwise content is an array of blocks; join all `text` blocks.
		var blocks []json.RawMessage
		if err := json.Unmarshal(top.Message.Content, &blocks); err != nil {
			continue
		}
		var sb strings.Builder
		any := false
		for _, rawBlock := range blocks {
			var blk struct {
				Type string `json:"type"`
				Text string `json:"text"`
			}
			if err := json.Unmarshal(rawBlock, &blk); err == nil && blk.Text != "" {
				if any {
					sb.WriteString("\n")
				}
				sb.WriteString(blk.Text)
				any = true
			}
		}
		if any {
			return sb.String(), nil
		}
	}
	return "", scanner.Err()
}

func extractTaskAfterMarker(content string) string {
	marker := "# Your Task (below)"
	idx := strings.Index(content, marker)
	if idx != -1 {
		task := strings.TrimSpace(content[idx+len(marker):])
		if task != "" {
			lines := strings.Split(task, "\n")
			for _, line := range lines {
				trimmed := strings.TrimSpace(line)
				if trimmed != "" {
					return trimmed
				}
			}
		}
	}
	return ""
}

func getFirstMeaningfulSentence(content string) string {
	content = strings.TrimSpace(content)
	if content == "" {
		return ""
	}
	lines := strings.Split(content, "\n")
	var firstLine string
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed != "" && !strings.HasPrefix(trimmed, "#") && !strings.HasPrefix(trimmed, "---") {
			firstLine = trimmed
			break
		}
	}
	if firstLine == "" {
		return ""
	}

	terminators := []string{". ", "! ", "? ", ".\n", "!\n", "?\n"}
	minIdx := len(firstLine)
	for _, term := range terminators {
		if idx := strings.Index(firstLine, term); idx != -1 {
			if idx < minIdx {
				minIdx = idx + 1
			}
		}
	}
	sentence := strings.TrimSpace(firstLine[:minIdx])
	sentence = strings.TrimPrefix(sentence, "* ")
	sentence = strings.TrimPrefix(sentence, "- ")
	for i := 1; i <= 9; i++ {
		prefix := fmt.Sprintf("%d. ", i)
		sentence = strings.TrimPrefix(sentence, prefix)
	}
	return strings.TrimSpace(sentence)
}

func lastResortTitle(path string) string {
	return filepath.Base(path)
}

func genericAgentLabel(subagentType string) string {
	switch strings.ToLower(strings.TrimSpace(subagentType)) {
	case "explore", "github-research", "general-purpose":
		return "Explorer"
	case "planner-review":
		return "Reviewer"
	default:
		return strings.TrimSpace(subagentType)
	}
}

func buildDisplayTitle(subagentType string, description string) string {
	label := genericAgentLabel(subagentType)
	desc := strings.TrimSpace(description)
	switch {
	case label != "" && desc != "":
		return fmt.Sprintf("%s — %s", label, desc)
	case label != "":
		return label
	default:
		return desc
	}
}

func deriveTitle(childPath string, childTS string, toolCalls []ToolCallInfo) (title string, subagentType string, description string, matchedIdx int) {
	matchedIdx = -1

	// 1. Try matching to spawning tool call
	if args, ok, idx := matchToolCall(childTS, toolCalls); ok {
		subagentType = args.SubagentType
		description = args.Description
		matchedIdx = idx

		title = buildDisplayTitle(subagentType, description)
		if title != "" {
			return title, subagentType, description, matchedIdx
		}
	}

	// 2. Try first user message task
	userMsg, err := findFirstUserMessage(childPath)
	if err == nil && userMsg != "" {
		task := extractTaskAfterMarker(userMsg)
		if task != "" {
			return task, "", "", matchedIdx
		}

		// 3. Try first meaningful sentence
		sentence := getFirstMeaningfulSentence(userMsg)
		if sentence != "" {
			return sentence, "", "", matchedIdx
		}
	}

	// 4. Last resort: child filename
	return lastResortTitle(childPath), "", "", matchedIdx
}

func readChildHeader(path string) (SessionHeader, error) {
	file, err := os.Open(path)
	if err != nil {
		return SessionHeader{}, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 10*1024*1024)
	if !scanner.Scan() {
		if err := scanner.Err(); err != nil {
			return SessionHeader{}, err
		}
		return SessionHeader{}, fmt.Errorf("child file is empty")
	}

	line := strings.TrimSpace(scanner.Text())
	var header SessionHeader
	if err := json.Unmarshal([]byte(line), &header); err != nil {
		return SessionHeader{}, fmt.Errorf("failed to parse child header: %w", err)
	}
	return header, nil
}

func performMerge(parentPath string, childFiles []string, parentID string, toolCalls []ToolCallInfo, writer io.Writer) ([]string, error) {
	var activeStreams []LogStream

	// Add parent stream
	parentStream, err := NewParentStream(parentPath)
	if err != nil {
		return nil, err
	}
	defer parentStream.Close()
	activeStreams = append(activeStreams, parentStream)

	// Add child streams
	var childSessionIDs []string
	for _, childPath := range childFiles {
		childHeader, err := readChildHeader(childPath)
		if err != nil {
			for _, s := range activeStreams {
				s.Close()
			}
			return nil, err
		}

		title, subagentType, description, matchedIdx := deriveTitle(childPath, childHeader.Timestamp, toolCalls)
		if title == "" {
			for _, s := range activeStreams {
				s.Close()
			}
			return nil, fmt.Errorf("refusing to merge: could not derive title for child session %s", filepath.Base(childPath))
		}
		if matchedIdx != -1 {
			toolCalls[matchedIdx].Matched = true
		}

		cs, err := NewChildStream(childPath, parentID, title, subagentType, description)
		if err != nil {
			for _, s := range activeStreams {
				s.Close()
			}
			return nil, err
		}
		defer cs.Close()
		activeStreams = append(activeStreams, cs)
		childSessionIDs = append(childSessionIDs, cs.header.ID)
	}

	// Initialize all streams by calling Next() once
	var initializedStreams []LogStream
	for _, s := range activeStreams {
		if s.Next() {
			initializedStreams = append(initializedStreams, s)
		} else if s.Err() != nil {
			for _, other := range activeStreams {
				other.Close()
			}
			return nil, s.Err()
		} else {
			// Stream was empty
			s.Close()
		}
	}
	activeStreams = initializedStreams

	for len(activeStreams) > 0 {
		minIdx := 0
		_, minTS := activeStreams[minIdx].Value()
		for i := 1; i < len(activeStreams); i++ {
			_, ts := activeStreams[i].Value()
			if ts < minTS {
				minIdx = i
				minTS = ts
			}
		}

		line, _ := activeStreams[minIdx].Value()
		if _, err := io.WriteString(writer, line+"\n"); err != nil {
			return nil, fmt.Errorf("failed to write entry: %w", err)
		}

		if activeStreams[minIdx].Next() {
			// Keep going
		} else {
			if err := activeStreams[minIdx].Err(); err != nil {
				return nil, err
			}
			activeStreams[minIdx].Close()
			activeStreams = append(activeStreams[:minIdx], activeStreams[minIdx+1:]...)
		}
	}

	return childSessionIDs, nil
}

func verifyMergedFile(path string, parentHeader SessionHeader, expectedChildIDs []string) error {
	file, err := os.Open(path)
	if err != nil {
		return fmt.Errorf("failed to open merged file: %w", err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 10*1024*1024)

	var lineCount int
	var vHeader SessionHeader
	markerChildIDs := make(map[string]bool)

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		lineCount++

		// Every non-empty line in the merged file MUST be valid JSON.
		var raw map[string]interface{}
		if err := json.Unmarshal([]byte(line), &raw); err != nil {
			return fmt.Errorf("line %d is not valid JSON: %w", lineCount, err)
		}

		if lineCount == 1 {
			if err := json.Unmarshal([]byte(line), &vHeader); err != nil {
				return fmt.Errorf("failed to parse header: %w", err)
			}
			if vHeader.Type != "session" {
				return fmt.Errorf("first line type is not 'session'")
			}
			if vHeader.ID != parentHeader.ID {
				return fmt.Errorf("first line ID %s does not match original parent ID %s", vHeader.ID, parentHeader.ID)
			}
			continue
		}

		var entry struct {
			Type       string `json:"type"`
			CustomType string `json:"customType"`
			Data       struct {
				Kind           string `json:"kind"`
				Title          string `json:"title"`
				ChildSessionID string `json:"childSessionId"`
			} `json:"data"`
		}
		if err := json.Unmarshal([]byte(line), &entry); err == nil {
			if entry.Type == "custom" && strings.HasPrefix(entry.CustomType, "subagent: ") {
				if entry.Data.Kind == "merged-subagent-session" {
					if entry.Data.Title == "" {
						return fmt.Errorf("line %d: custom marker data.title is empty", lineCount)
					}
					if entry.Data.ChildSessionID != "" {
						markerChildIDs[entry.Data.ChildSessionID] = true
					}
				}
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return fmt.Errorf("failed to read merged file: %w", err)
	}

	if lineCount == 0 {
		return fmt.Errorf("merged file is empty")
	}

	for _, cid := range expectedChildIDs {
		if !markerChildIDs[cid] {
			return fmt.Errorf("missing custom marker for child session ID %s", cid)
		}
	}

	return nil
}

func mergeSessions(parentPath, tasksDir string) error {
	fmt.Printf("Parent path resolved: %s\n", parentPath)
	fmt.Printf("Tasks directory resolved: %s\n", tasksDir)

	// Validate parent file exists
	if _, err := os.Stat(parentPath); os.IsNotExist(err) {
		return fmt.Errorf("parent file is missing at %s", parentPath)
	}

	// Validate tasks directory exists
	tasksInfo, err := os.Stat(tasksDir)
	if os.IsNotExist(err) {
		return fmt.Errorf("tasks directory is missing at %s", tasksDir)
	}
	if !tasksInfo.IsDir() {
		return fmt.Errorf("tasks path is not a directory: %s", tasksDir)
	}

	// Find child files
	files, err := os.ReadDir(tasksDir)
	if err != nil {
		return fmt.Errorf("failed to read tasks directory: %w", err)
	}

	var childFiles []string
	for _, f := range files {
		if !f.IsDir() && strings.HasSuffix(f.Name(), ".jsonl") {
			childFiles = append(childFiles, filepath.Join(tasksDir, f.Name()))
		}
	}
	sort.Strings(childFiles)

	if len(childFiles) == 0 {
		return fmt.Errorf("tasks directory is empty (no *.jsonl files) at %s", tasksDir)
	}

	// Read and validate parent header
	parentHeader, parentHeaderLine, err := readParentHeader(parentPath)
	if err != nil {
		return fmt.Errorf("failed to read parent header: %w", err)
	}
	fmt.Printf("Parent session ID: %s\n", parentHeader.ID)

	// Scan parent for tool calls for title derivation
	toolCalls, err := scanParentToolCalls(parentPath)
	if err != nil {
		return fmt.Errorf("failed to scan parent tool calls: %w", err)
	}

	// Setup backups
	parentBackupPath := parentPath + ".before-merge.bak"
	tasksBackupPath := filepath.Join(filepath.Dir(tasksDir), filepath.Base(tasksDir)+".before-merge.bak")

	fmt.Printf("Creating parent backup at %s\n", parentBackupPath)
	if err := copyFile(parentPath, parentBackupPath); err != nil {
		return fmt.Errorf("failed to create parent backup: %w", err)
	}

	fmt.Printf("Creating tasks backup at %s\n", tasksBackupPath)
	if err := os.RemoveAll(tasksBackupPath); err != nil {
		return fmt.Errorf("failed to remove existing tasks backup: %w", err)
	}
	if err := copyDir(tasksDir, tasksBackupPath); err != nil {
		return fmt.Errorf("failed to create tasks backup: %w", err)
	}

	// Write merged temp file
	tempMergedPath := parentPath + ".tmp"
	fmt.Printf("Writing merged session data to %s\n", tempMergedPath)

	tmpFile, err := os.Create(tempMergedPath)
	if err != nil {
		return fmt.Errorf("failed to create temp merged file: %w", err)
	}

	success := false
	defer func() {
		if !success {
			tmpFile.Close()
			os.Remove(tempMergedPath)
		}
	}()

	writer := bufio.NewWriter(tmpFile)
	if _, err := writer.WriteString(parentHeaderLine + "\n"); err != nil {
		return fmt.Errorf("failed to write parent header to temp file: %w", err)
	}

	childSessionIDs, err := performMerge(parentPath, childFiles, parentHeader.ID, toolCalls, writer)
	if err != nil {
		return err
	}

	if err := writer.Flush(); err != nil {
		return fmt.Errorf("failed to flush temp file: %w", err)
	}
	if err := tmpFile.Sync(); err != nil {
		return fmt.Errorf("failed to sync temp file: %w", err)
	}
	tmpFile.Close()

	// Verify merged file
	fmt.Println("Verifying the merged file...")
	if err := verifyMergedFile(tempMergedPath, parentHeader, childSessionIDs); err != nil {
		return fmt.Errorf("verification failed: %w", err)
	}
	fmt.Println("Verification successful!")

	// Atomically replace parent file
	fmt.Printf("Replacing original parent session file: %s\n", parentPath)
	if err := os.Rename(tempMergedPath, parentPath); err != nil {
		return fmt.Errorf("failed to replace parent file: %w", err)
	}
	success = true

	// Delete tasks/ only after success
	fmt.Printf("Deleting original tasks directory: %s\n", tasksDir)
	if err := os.RemoveAll(tasksDir); err != nil {
		return fmt.Errorf("failed to delete tasks directory: %w", err)
	}

	fmt.Println("SUCCESS: Session merge completed successfully!")
	return nil
}

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	srcInfo, err := in.Stat()
	if err != nil {
		return err
	}

	out, err := os.OpenFile(dst, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, srcInfo.Mode())
	if err != nil {
		return err
	}
	defer out.Close()

	if _, err := io.Copy(out, in); err != nil {
		return err
	}
	return out.Sync()
}

func copyDir(src, dst string) error {
	srcInfo, err := os.Stat(src)
	if err != nil {
		return err
	}

	if err := os.MkdirAll(dst, srcInfo.Mode()); err != nil {
		return err
	}

	entries, err := os.ReadDir(src)
	if err != nil {
		return err
	}

	for _, entry := range entries {
		srcPath := filepath.Join(src, entry.Name())
		dstPath := filepath.Join(dst, entry.Name())

		if entry.IsDir() {
			if err := copyDir(srcPath, dstPath); err != nil {
				return err
			}
		} else {
			if err := copyFile(srcPath, dstPath); err != nil {
				return err
			}
		}
	}
	return nil
}
