# fairclaw-tools Index

Shared tools and entry points for Fairclaw / Mathika.

## Global scripts (`bin/`)

### `bin/split_subdir.sh`

Split a subdirectory of a git repo into a new repository using `git subtree split`.

Usage:

- Run from the root of the source repo:

  split_subdir.sh <subdir> <new-repo-dir> [<new-remote-url>]

Behaviour:

- Verifies you are inside a git repo with a clean working tree.
- Verifies the subdirectory exists.
- Runs `git subtree split --prefix=<subdir>` to create a split branch.
- Creates `<new-repo-dir>`, initialises a new repo there, and pulls the split branch.
- Optionally sets `origin` to `<new-remote-url>` and pushes `main`.

### `bin/coding-repl.sh`

Simple terminal REPL for the `coding` agent.

Usage:

- From any shell where `openclaw` is on PATH:

  coding-repl.sh

Behaviour:

- Creates a session id: `coding-repl-<timestamp>`.
- Enters a loop prompting with `coding> `.
- For each non-empty line you type, runs:

  openclaw agent --agent coding --session-id "$SESSION_ID" --message "$MSG"

- Prints the coding agent's reply to the terminal.

You can change the `SESSION_ID` definition in the script if you prefer a stable
session per terminal or per user.

## Related project-local resources

These are not in this repo, but are important pieces we refer to often.
Update this list as new tools/skills are added.

### `mac_org` (GTD / org workspace)

- `mac_org/.openclaw/skills/gtd-org/SKILL.md`
  - GTD/org-mode skill for weekly reviews and per-project reviews.
  - Uses `gtd.org` and `projects.org` as canonical sources.

- `mac_org/.openclaw/skills/gtd-org/references/gtd-weekly-checklist.md`
  - Paraphrased GTD Weekly Review checklist (Get Clear / Get Current / Get Creative).

- `mac_org/project-list.org`
  - Concise index of projects. One `* PROJECT ...` heading per project, with
    tags like `:ACTIVE:`, `:SOMEDAY:`, `:HOLD:`, `:ARCHIVE:` and a `:LINK:` back
    into the detailed org files.

- `mac_org/action.org`
  - Quick action inbox. `/action ...` in chat appends TODO entries here with a
    timestamp under `* Captured Actions`.

### `workspace` (OpenClaw main workspace)

- `/home/claws/.openclaw/workspace/git-tools/split_subdir.sh`
  - Original location of `split_subdir.sh` used when splitting `org/` out of
    the `mac_files` repo. The canonical version is now in `fairclaw-tools/bin/`.

Over time, prefer to:

- Keep generic, cross-project scripts here in `fairclaw-tools/bin/`.
- Keep project-specific scripts under each project's `.openclaw/skills/.../scripts/`.
- Reflect any new tools/skills in this INDEX.md so both human and agents have a
  single place to discover them.
