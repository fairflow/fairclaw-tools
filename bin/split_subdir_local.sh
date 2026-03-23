#!/usr/bin/env bash
set -euo pipefail

# split_subdir.sh
# Usage: split_subdir.sh <subdir> <new-repo-dir> [<new-remote-url>]
#
# From the root of an existing git repo, create a new repo that
# contains only the history for <subdir> using git subtree split.
#
# This script does NOT modify the original repo (no git rm / submodule);
# it only creates the new repo. You can decide what to do in the
# original repo afterwards.

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <subdir> <new-repo-dir> [<new-remote-url>]" >&2
  exit 1
fi

SUBDIR="$1"
NEW_REPO_DIR="$2"
REMOTE_URL="${3-}"

# Ensure we are in a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: not inside a git repository" >&2
  exit 1
fi

# Ensure working tree is clean (avoid surprises)
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: working tree not clean. Commit or stash changes first." >&2
  git status
  exit 1
fi

# Ensure subdir exists
if [[ ! -d "$SUBDIR" ]]; then
  echo "Error: subdir '$SUBDIR' does not exist" >&2
  exit 1
fi

# Derive a branch name from the subdir
NAME="$(basename "$SUBDIR")"
BRANCH="split-${NAME}-$(date +%Y%m%d%H%M%S)"

echo "[split_subdir] Creating split branch '$BRANCH' from prefix '$SUBDIR'..."
git subtree split --prefix="$SUBDIR" -b "$BRANCH"

echo "[split_subdir] Creating new repo at '$NEW_REPO_DIR'..."
mkdir -p "$NEW_REPO_DIR"
cd "$NEW_REPO_DIR"

git init

echo "[split_subdir] Pulling history from original repo..."
ORIG_REPO="$OLDPWD"

git pull "$ORIG_REPO" "$BRANCH"

echo "[split_subdir] New repo created with history for '$SUBDIR'."

if [[ -n "$REMOTE_URL" ]]; then
  echo "[split_subdir] Adding remote '$REMOTE_URL' and pushing..."
  git remote add origin "$REMOTE_URL"
  git branch -M main
  git push -u origin main
fi

echo "[split_subdir] Done."
