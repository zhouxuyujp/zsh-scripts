#!/bin/zsh

while inotifywait -e modify,close_write "$HOME/blockip.txt"; do
  echo "blockip.txt modified: Applying new IP block rules"
  "$HOME/update_iptables.sh"
done
