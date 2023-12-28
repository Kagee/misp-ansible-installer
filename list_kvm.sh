#! /bin/bash
source env.sh
sudo -n true 2>/dev/null || echo "We need to be root to run virt-install"

sudo virsh list --all | grep -o 'rhel.-misp' | cat | while read -r NAME; do
  while true; do
    IP=$(sudo virsh domifaddr "$NAME" --full | grep 'ipv4' | awk '{print $NF}' | cut -d/ -f1)
    if [[ -n "$IP" ]]; then
      break;
    fi
    done
    echo $NAME $IP
    ssh-keygen -f "/home/hildenae/.ssh/known_hosts" -R "$IP" 2>/dev/null 1>/dev/null;
done