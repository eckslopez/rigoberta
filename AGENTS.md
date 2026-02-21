# AGENTS.md


  ## Collaboration Workflow

  We are using a tmux-first workflow for this repo.

  Working rules:
  1. Keep VS Code as my editor; I run you from a terminal/tmux pane.
  2. Use Docker for runtime services and test execution when needed.
  3. Prefer bind mounts so host code edits are reflected quickly in container runs.
  4. Before making changes, explain the plan briefly; then implement directly.
  5. For larger tasks, explain each step first, then give exact edits/commands.
  6. Keep responses concise and practical; teach as we go.
  7. Never use destructive git commands unless I explicitly ask.
  8. If dependencies conflict, resolve with a stable constraints-based strategy.
  9. End each task with: what changed, how verified, and next action.
