#!/bin/zsh

BLOCKED_IPS_FILE="$HOME/blockip.txt"

if [[ ! -f "$BLOCKED_IPS_FILE" ]]; then
  echo "File $BLOCKED_IPS_FILE does not exist!"
  exit 1
fi

sudo iptables -F INPUT

while IFS= read -r ip; do
  if [[ ! -z "$ip" ]]; then
    sudo iptables -C INPUT -s "$ip" -j DROP 2>/dev/null
    if [[ $? -ne 0 ]]; then
      echo "Blocking IP: $ip"
      sudo iptables -A INPUT -s "$ip" -j DROP
    else
      echo "IP $ip already blocked, skipping..."
    fi
  fi
done < "$BLOCKED_IPS_FILE"


# sudo iptables-save > /etc/iptables/rules.v4


sudo netfilter-persistent save
