#!/bin/zsh

# 定义存储阻止IP的文件路径
BLOCKED_IPS_FILE="$HOME/blockip.txt"

# 检查文件是否存在
if [[ ! -f "$BLOCKED_IPS_FILE" ]]; then
  echo "File $BLOCKED_IPS_FILE does not exist!"
  exit 1
fi

# 删除所有已有的 DROP 规则
sudo iptables -F INPUT

# 遍历 blockip.txt 文件中的每个IP地址，并添加阻止规则
while IFS= read -r ip; do
  # 检查行是否为空
  if [[ ! -z "$ip" ]]; then
    # 检查该 IP 是否已经存在于规则中
    sudo iptables -C INPUT -s "$ip" -j DROP 2>/dev/null
    if [[ $? -ne 0 ]]; then
      echo "Blocking IP: $ip"
      sudo iptables -A INPUT -s "$ip" -j DROP
    else
      echo "IP $ip already blocked, skipping..."
    fi
  fi
done < "$BLOCKED_IPS_FILE"

# 保存规则（根据系统选择使用一个即可）
# 手动保存
# sudo iptables-save > /etc/iptables/rules.v4

# 使用 netfilter-persistent 保存规则
sudo netfilter-persistent save
