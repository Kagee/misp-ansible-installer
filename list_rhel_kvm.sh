#! /bin/bash
source env.sh
sudo -n true 2>/dev/null || echo "We need to be root to run virt-install"

sudo virsh list --all | grep -o 'rhel.-misp' | cat | while read -r NAME; do
    echo "$NAME"
    sudo virsh domifaddr "$NAME"
done