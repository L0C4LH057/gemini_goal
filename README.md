# Gemini Goal 🚀

**Gemini Goal** is a Codex-inspired `/goal` command for the Gemini CLI. It provides a persistent local goal state, continuation instructions, and safety guardrails to help the agent stay focused on long-running objectives.

Inspired by the [OpenAI Codex](https://openai.com/blog/openai-codex) `/goal` behavior, this tool ensures that your Gemini sessions are productive, tracked, and verified.

## ✨ Features

- 💾 **Persistent State:** Goals are stored locally in a SQLite database (`~/.gemini/goal/goals.sqlite`), allowing them to survive terminal restarts or shell drift.
- 🔄 **Automatic Continuation:** Includes a Gemini CLI `Stop` hook that prevents the agent from stopping prematurely while a goal is active.
- 🚦 **Session Isolation:** Goals are isolated by terminal session and working directory, preventing "goal leakage" between separate tabs.
- ⏱️ **Time & Budget Tracking:** Tracks elapsed time and supports soft token budgets to manage resource usage.
- 🛡️ **Completion Audits:** Enforces a rigorous completion audit before a goal can be marked as finished, ensuring all requirements are met with real evidence.
- 🎮 **Intuitive CLI:** Simple slash-command interface: `/goal status`, `/goal pause`, `/goal resume`, `/goal clear`.

## 🚀 Installation

Ensure you have [Gemini CLI](https://github.com/google/gemini-cli) installed and configured.

```bash
# Clone the repository
git clone https://github.com/your-username/gemini-goal.git
cd gemini-goal

# Run the installer
./install.sh
```

The installer will:
1. Symlink the skill to `~/.gemini/skills/goal`.
2. Configure a user-level `Stop` hook in `~/.gemini/settings.json`.
3. Create the local state directory at `~/.gemini/goal/`.

## 📖 Usage

### Setting a Goal
Give Gemini a concrete objective to work toward:
```text
/goal Refactor the authentication module to use JWT and add unit tests
```

### Soft Budgets
You can specify a soft token budget (displayed as a reminder):
```text
/goal --tokens 500K research and implement a distributed caching layer
```

### Managing Goals
- `/goal`: View the current goal and continuation instructions.
- `/goal status`: Check the status of the current session's goal.
- `/goal pause`: Temporarily pause automatic continuation.
- `/goal resume`: Resume work on a paused goal.
- `/goal clear`: Delete the current goal and its state.
- `/goal complete`: Mark a goal as complete (requires a completion audit).

## 🛠️ How it Works

1. **The Skill:** The `/goal` command is defined as a Gemini CLI skill in `goal/SKILL.md`. It invokes a lightweight Python script (`gemini_goal.py`) to manage the state.
2. **Persistence:** State is managed via SQLite. We use a combination of terminal session IDs and directory hashes to anchor goals to specific contexts.
3. **The Stop Hook:** The installer adds a command to your Gemini CLI `Stop` hooks. Every time the agent tries to stop, this hook checks for an active goal. If one is found, it injects "Gemini instructions" to keep the agent working until the objective is reached.
4. **Runaway Guard:** By default, it allows up to 500 automatic continuations. You can adjust this by setting `GEMINI_GOAL_MAX_STOP_CONTINUES`.

## 🧪 Testing

The project includes a comprehensive suite of tests covering state management, session isolation, and hook logic.

```bash
python3 -m pytest tests
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---
*Created by [Joseph Thacker](https://github.com/jthack)*
# gemini_goal
