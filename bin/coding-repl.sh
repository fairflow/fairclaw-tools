#!/usr/bin/env bash
# Simple REPL for the `coding` agent.
# Each line you type is sent as a message to the coding agent using
# a fresh session id (or you can change this to something stable).

SESSION_ID="coding-repl-$(date +%s)"

echo "Coding REPL started (session: $SESSION_ID). Ctrl-C to exit."

while true; do
  read -rp "coding> " MSG || break
  [ -z "$MSG" ] && continue

  openclaw agent \
    --agent coding \
    --session-id "$SESSION_ID" \
    --message "$MSG"
done
