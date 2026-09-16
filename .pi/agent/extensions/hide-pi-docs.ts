import { join } from "node:path";
import { readFileSync, existsSync } from "node:fs";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function hidePiDocs(pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event, ctx) => {
    // 1. Check environment variable HIDE_PI_DOCS
    // If set to "false" or "0", do not hide
    if (process.env.HIDE_PI_DOCS === "false" || process.env.HIDE_PI_DOCS === "0") {
      return;
    }

    // 2. Check settings.json for a "hidePiDocs" property
    const agentDir = process.env.PI_AGENT_DIR || join(process.env.HOME || "", ".pi", "agent");
    const settingsPath = join(agentDir, "settings.json");
    if (existsSync(settingsPath)) {
      try {
        const settings = JSON.parse(readFileSync(settingsPath, "utf-8"));
        if (settings.hidePiDocs === false) {
          return;
        }
      } catch (e) {
        // Ignore settings parsing errors
      }
    }

    const { systemPrompt } = event;

    // Matches the Pi documentation section from the start header to the end of instructions
    const regex = /Pi documentation \(read only[\s\S]*?tui\.md for TUI API details\)/i;
    
    if (regex.test(systemPrompt)) {
      const updatedPrompt = systemPrompt.replace(regex, "");
      return {
        systemPrompt: updatedPrompt.trim(),
      };
    }
  });
}
