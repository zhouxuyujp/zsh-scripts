#!/bin/zsh

# 监听 blockip.txt 文件的更改（包括修改和关闭写操作）
while inotifywait -e modify,close_write "$HOME/blockip.txt"; do
  echo "blockip.txt modified: Applying new IP block rules"
  "$HOME/update_iptables.sh"
done
