# Gemini Goal
> Codex-inspired persistent goals for the Gemini CLI.

Gemini Goal provides a robust framework for managing long-running objectives within your Gemini sessions. It brings persistent local state, automatic continuation, and completion guardrails to ensure your agent stays focused until the job is truly done.

Inspired by the original OpenAI Codex `/goal` behavior, this tool is designed for developers who need Gemini to work through complex, multi-step tasks without losing context or stopping prematurely.

---

## Core Capabilities

* **Persistent State**: Goals are stored in a local SQLite database, ensuring they survive terminal restarts, crashes, or shell drift.
* **Auto-Continuation**: Integrates with the Gemini CLI `Stop` hook to automatically resume work as long as a goal remains active.
* **Session Isolation**: Advanced session anchoring prevents goal leakage between concurrent terminal tabs or different projects.
* **Rigorous Verification**: Enforces a completion audit checklist before marking tasks as finished, preventing premature success claims.
* **Resource Tracking**: Monitors elapsed time and supports soft token budgets for better resource visibility.

---

## Quick Start

### Prerequisites
* [Gemini CLI](https://github.com/google/gemini-cli) installed and configured.

### Installation
```bash
git clone https://github.com/L0C4LH057/gemini-goal.git
cd gemini-goal
./install.sh
```

The installer automatically symlinks the skill to `~/.gemini/skills/goal` and registers the necessary hooks in your `settings.json`.

---

## Command Reference

| Command | Description |
| :--- | :--- |
| `/goal <objective>` | Set a new active goal for the current session. |
| `/goal --tokens <N> <obj>` | Set a goal with a soft token budget (e.g., 250K). |
| `/goal` | View the current objective and continuation state. |
| `/goal status` | Check the current goal's status and elapsed time. |
| `/goal pause` | Temporarily halt automatic continuation. |
| `/goal resume` | Resume work on a paused objective. |
| `/goal clear` | Delete the current goal and reset state. |
| `/goal complete` | Finalize the goal after passing the completion audit. |

---

## Technical Architecture

### The Skill Layer
The `/goal` command is registered as a Gemini CLI skill. When invoked, it executes a lightweight Python bridge (`gemini_goal.py`) that manages all logic and state transitions.

### Persistence
State is maintained in `~/.gemini/goal/goals.sqlite`. We anchor goals using a preference-ordered list of session identifiers, including stable terminal session IDs and directory-based hashes, ensuring the right goal always surfaces in the right context.

### The Stop Hook
A command-type hook is registered in `~/.gemini/settings.json`. Every time the Gemini agent attempts to finish its turn, the hook intercepts. If a goal is active, it injects specialized instructions into the prompt, guiding the model to continue its work toward the objective.

### Runaway Guard
To prevent infinite loops, a runaway guard limits the number of automatic continuations (default: 500). This can be configured via the `GEMINI_GOAL_MAX_STOP_CONTINUES` environment variable.

---

## Development

### Testing
Run the comprehensive test suite to verify state management and session isolation:
```bash
python3 -m pytest tests
```

---

## License
Distributed under the MIT License. See `LICENSE` for more information.

---
**Created by [Bashir Kabir Zarewa (L0C4L057)](https://github.com/L0C4LH057)**
