#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.gemini/skills" "$HOME/.gemini/commands" "$HOME/.gemini/goal"

ln -sfn "$ROOT/goal" "$HOME/.gemini/skills/goal"
chmod +x "$ROOT/goal/scripts/gemini_goal.py"

# Older installs created a legacy ~/.claude/commands/goal.md shim. Gemini CLI
# now exposes the skill itself as /goal, so keeping both produces duplicate
# entries in /help.
if [ -L "$HOME/.claude/commands/goal.md" ] && [ "$(readlink "$HOME/.claude/commands/goal.md")" = "$ROOT/goal.md" ]; then
  rm "$HOME/.claude/commands/goal.md"
fi

# Also check for .gemini/commands/goal.md just in case
if [ -L "$HOME/.gemini/commands/goal.md" ]; then
  rm "$HOME/.gemini/commands/goal.md"
fi

python3 - "$HOME/.gemini/settings.json" "$ROOT/goal/scripts/gemini_goal.py" <<'PY'
import json
import sys
from pathlib import Path

settings_path = Path(sys.argv[1])
script_path = Path(sys.argv[2])
settings_path.parent.mkdir(parents=True, exist_ok=True)
if settings_path.exists():
    data = json.loads(settings_path.read_text())
else:
    data = {}

hooks = data.setdefault("hooks", {})
stop_hooks = hooks.setdefault("Stop", [])
entry = {
    "matcher": "",
    "hooks": [
        {
            "type": "command",
            "command": f"python3 {script_path} stop-hook",
        }
    ],
}

command = entry["hooks"][0]["command"]
for item in stop_hooks:
    item_hooks = item.get("hooks", [])
    if any(hook.get("command") == command for hook in item_hooks):
        break
else:
    stop_hooks.append(entry)

settings_path.write_text(json.dumps(data, indent=2) + "\n")
PY

echo "Installed /goal for Gemini CLI."
echo "Skill: $HOME/.gemini/skills/goal"
echo "Stop hook: python3 $ROOT/goal/scripts/gemini_goal.py stop-hook"
echo "State DB: $HOME/.gemini/goal/goals.sqlite"
