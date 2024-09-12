#!/bin/zsh

# Get block IP file path from the parameter
BLOCKED_IPS_FILE="$1"

# Check if the block IP file exists
if [[ ! -f "$BLOCKED_IPS_FILE" ]]; then
  echo "File $BLOCKED_IPS_FILE does not exist!"
  exit 1
fi

# Clear all existing DROP rules from the INPUT chain
sudo iptables -F INPUT

# Loop through the block IP file and apply the DROP rule for each IP
while IFS= read -r ip; do
  # Skip empty lines
  if [[ ! -z "$ip" ]]; then
    # Check if the IP is already blocked
    sudo iptables -C INPUT -s "$ip" -j DROP 2>/dev/null
    if [[ $? -ne 0 ]]; then
      # Add a DROP rule if the IP is not already blocked
      echo "Blocking IP: $ip"
      sudo iptables -A INPUT -s "$ip" -j DROP
    else
      echo "IP $ip is already blocked, skipping..."
    fi
  fi
done < "$BLOCKED_IPS_FILE"

# Save the iptables rules
sudo netfilter-persistent save
