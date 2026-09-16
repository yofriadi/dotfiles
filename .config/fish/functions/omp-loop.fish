# Implement: review -> fix -> re-review loop driven by `omp`.
#
# Workflow:
#   1. Implement with $impl_model at $impl_thinking
#   2. Review with $rev_model at $rev_thinking_first (medium by default)
#   3. If findings: implement fixes
#   4. Review again with $rev_model at $rev_thinking_rest (low by default)
#   5. Repeat $max_iters until reviewer says NO_FINDINGS or $max_iters reached
#
# Recommended model:
#  ┌─────────────────────────────────────────┬────────────┬───────────────────────────────────────────┐
#  │ model                                   │ thinking   │ role                                      │
#  ├─────────────────────────────────────────┼────────────┼───────────────────────────────────────────┤
#  │ opencode-go/minimax-m3                  │ minimal,   │ implementer (high),                       │
#  │                                         │ low,       │ reviewer (1st turn high)                  │
#  │                                         │ medium,    │                                           │
#  │                                         │ high,      │                                           │
#  │                                         │ xhigh      │                                           │
#  ├─────────────────────────────────────────┼────────────┼───────────────────────────────────────────┤
#  │ google-antigravity/gemini-pro-agent     │ minimal,   │ implementer (high),                       │
#  │                                         │ low,       │ reviewer (high)                           │
#  │                                         │ medium,    │                                           │
#  │                                         │ high       │                                           │
#  ├─────────────────────────────────────────┼────────────┼───────────────────────────────────────────┤
#  │ google-antigravity/gemini-3-flash-agent │ minimal,   │ implementer (high),                       │
#  │                                         │ low,       │ reviewer (high)                           │
#  │                                         │ medium,    │                                           │
#  │                                         │ high       │                                           │
#  ├─────────────────────────────────────────┼────────────┼───────────────────────────────────────────┤
#  │ openai-codex/gpt-5.4                    │ minimal,   │ reviewer (high)                           │
#  │                                         │ low,       │                                           │
#  │                                         │ medium,    │                                           │
#  │                                         │ high,      │                                           │
#  │                                         │ extra-high │                                           │
#  └─────────────────────────────────────────┴────────────┴───────────────────────────────────────────┘
#
# Reviewer contract: reply with EXACTLY "NO_FINDINGS" or "FINDINGS: <list>".
function omp-loop
    set -l impl_model opencode-go/minimax-m3
    set -l rev_model gpt-5.4
    set -l impl_thinking high
    set -l rev_thinking_first low
    set -l rev_thinking_rest low
    set -l max_iters 5

    argparse i/impl= r/reviewer= n/max= h/help -- $argv
    or return 2

    if set -q OMP_LOOP_IMPL; set impl_model $OMP_LOOP_IMPL; end
    if set -q OMP_LOOP_REV; set rev_model $OMP_LOOP_REV; end
    if set -q OMP_LOOP_IMPL_THINKING; set impl_thinking $OMP_LOOP_IMPL_THINKING; end
    if set -q OMP_LOOP_REV_THINKING_FIRST; set rev_thinking_first $OMP_LOOP_REV_THINKING_FIRST; end
    if set -q OMP_LOOP_REV_THINKING_REST; set rev_thinking_rest $OMP_LOOP_REV_THINKING_REST; end
    if set -q OMP_LOOP_MAX; set max_iters $OMP_LOOP_MAX; end

    if set -q _flag_impl; set impl_model $_flag_impl; end
    if set -q _flag_reviewer; set rev_model $_flag_reviewer; end
    if set -q _flag_max; set max_iters $_flag_max; end

    # Cost-saving: gpt-5.4 charges a lot for `high` thinking; default to `low`
    # unless the user explicitly set OMP_LOOP_IMPL_THINKING.
    if string match -qi '*gpt-5.4*' $impl_model; and not set -q OMP_LOOP_IMPL_THINKING
        set impl_thinking low
    end

    if set -q _flag_help
        printf 'Usage: omp-loop [options] "task"\n\n'
        printf 'Options:\n'
        printf '  -i, --impl MODEL        Implementer model (default: %s)\n' $impl_model
        printf '  -r, --reviewer MODEL    Reviewer model (default: %s)\n' $rev_model
        printf '  -n, --max N             Max iterations (default: %s)\n' $max_iters
        printf '  -h, --help              Show this help\n'
        printf '\nEnv overrides: OMP_LOOP_IMPL, OMP_LOOP_REV, OMP_LOOP_IMPL_THINKING,\n'
        printf '                OMP_LOOP_REV_THINKING_FIRST, OMP_LOOP_REV_THINKING_REST, OMP_LOOP_MAX\n'
        printf '\nReviewer contract: reply EXACTLY "NO_FINDINGS" or "FINDINGS: <list>".\n'
        return 0
    end



    if test (count $argv) -eq 0
        echo "Error: no task provided" >&2
        echo "Run 'omp-loop --help' for usage" >&2
        return 1
    end

    set -l prompt "$argv"
    set -l iter 0
    set -l review_thinking $rev_thinking_first
    set -l review_prompt "Review the code in the current working directory.
    If clean, reply with EXACTLY: NO_FINDINGS
    If issues exist, reply with EXACTLY: FINDINGS: followed by a concise list of issues to fix."

    while test $iter -lt $max_iters
        set iter (math $iter + 1)
        echo
        set_color cyan; echo "─── iteration $iter of $max_iters ───"; set_color normal

        set_color yellow; echo "→ implement (model=$impl_model, thinking=$impl_thinking)"; set_color normal
        set -l impl_tmpout (mktemp)
        command omp --model $impl_model --thinking $impl_thinking -p "$prompt" >$impl_tmpout
        or begin
            set -l rc $status
            set_color red
            echo "✗ implementer exited with status $rc"
            set_color normal
            command rm -f $impl_tmpout
            return $rc
        end
        # Trim the implementer's full output and keep it as the report to
        # hand to the reviewer as additional context.
        #   * Strip ANSI escapes (some providers leak them through omp).
        #   * Strip <think>-style and redacted-reasoning/reflection
        #     blocks defensively — omp usually strips them server-side,
        #     but a future model may leak them and we don't want the
        #     reviewer eating chain-of-thought for no gain.
        #   * Strip markdown code blocks — the reviewer reads files
        #     directly, so pasted code in the prompt is just noise.
        #     Inline `code` is kept (usually identifiers/paths).
        #   * Cap at 100K chars (head 80K + tail 20K) so a 512K-output
        #     model (minimax-m3) doesn't blow up the reviewer's context.
        # NB: fish's parser treats literal '<' / '>' as redirect operators
        # even inside multi-line single-quoted strings (when loaded via
        # `-c`), so use \x3c / \x3e hex escapes for those characters.
        set -l impl_report (perl -0777 -pe '
            s/^\s+//; s/\s+$//;
            s/\e\[[0-9;]*[a-zA-Z]//g;
            s{\x3c(?:think|thinking)\b[^\x3e]*\x3e.*?\x3c/(?:think|thinking)\x3e}{}gis;
            s{\x3credacted[_-]reasoning\b[^\x3e]*\x3e.*?\x3c/redacted[_-]reasoning\x3e}{}gis;
            s{\x3creflection\b[^\x3e]*\x3e.*?\x3c/reflection\x3e}{}gis;
            s{\x60\x60\x60.*?\x60\x60\x60}{}gs;
            s/\n{3,}/\n\n/g;
            if (length($_) > 100000) {
                my $head = substr($_, 0, 80000);
                my $tail = substr($_, -20000);
                my $orig = length($_);
                $_ = $head . "\n\n... [middle truncated; original was $orig chars] ...\n\n" . $tail;
            }
        ' $impl_tmpout)
        # Show the implementer output under its own header for transparency.
        set_color yellow; echo; echo "─── implementer report ───"; set_color normal
        command cat $impl_tmpout
        set_color yellow; echo "─────────────────────────"; set_color normal
        command rm -f $impl_tmpout
        set_color yellow; echo; echo "→ review (model=$rev_model, thinking=$review_thinking)"; set_color normal
        set -l tmpout (mktemp)
        # Pass the implementer's report as context so the reviewer knows
        # what was just changed this iteration (and can focus on the diff
        # instead of having to re-derive the changes from the whole tree).
        set -l iter_review_prompt "$review_prompt

Implementer's most recent report (what they just did this iteration):

$impl_report"
        command omp --model $rev_model --thinking $review_thinking -p "$iter_review_prompt" >$tmpout
        or begin
            set -l rc $status
            set_color red
            echo "✗ reviewer exited with status $rc"
            set_color normal
            command rm -f $tmpout
            return $rc
        end
        # Read reviewer output, trim leading/trailing whitespace (including
        # newlines) from the whole blob, and keep as a single string.
        perl -0777 -pe 's/^\s+//; s/\s+$//' $tmpout | read -z findings
        command rm -f $tmpout

        set_color magenta; echo; echo "─── review output ───"; set_color normal
        echo $findings
        set_color magenta; echo "─────────────────────"; set_color normal

        if string match -rq -- '^\s*NO_FINDINGS\s*$' $findings
            echo
            set_color green; echo "✓ done after $iter iteration(s)"; set_color normal
            return 0
        end

        set review_thinking $rev_thinking_rest
        set prompt "Fix these review findings:

$findings"
    end

    echo
    set_color red; echo "✗ hit max iterations ($max_iters) without NO_FINDINGS"; set_color normal
    return 1
end
