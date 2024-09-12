#!/bin/zsh

# Get the block IP file path from the parameter
BLOCKED_IPS_FILE="$1"

# Watch for changes to the block IP file (e.g., modified or closed after writing)
while inotifywait -e modify,close_write "$BLOCKED_IPS_FILE"; do
  echo "$BLOCKED_IPS_FILE modified: Applying new IP block rules"
  "$HOME/update_iptables.zsh" "$BLOCKED_IPS_FILE"
done
