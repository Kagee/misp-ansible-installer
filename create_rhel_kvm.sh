#! /bin/bash
echo "This script will create and start two RHEL (8&9)"
echo "KVM VMs (domains) based on the values in .env"
echo
echo "Press ENTER to continue, CTRL-C to cancel."
read

source env.sh

# Check if we are root, and print 
# a pretty message if we are not
sudo -n true 2>/dev/null \
  || echo "We need to be root"

sudo mkdir -p "$KVM_DISK_PATH"
for rhel in "rhel8" "rhel9"; do
  RHEL=${rhel^^}
  QCOW="${RHEL}_QCOW2_SOURCE"
  MAC="${RHEL}_MAC"
  VARIANT="${RHEL}_KVM_VARIANT"
  NAME="${rhel}-misp"
  echo "Setting up $NAME with source disk ${!QCOW} and MAC ${!MAC}"

  VM=$(sudo virsh list --all | grep " $NAME " | awk '{ print $3}')
  if [[ -n "$VM" ]];  then
    echo "VM named $NAME was found - delete? (Y/n)"
    read DELETE;
    # Try additional commands here...
    if [[ "$DELETE" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      sudo virsh shutdown "$NAME" 2>&1
      while ! (sudo virsh list --state-shutoff | grep -q "$NAME" ); do
      sleep 1; echo -n .
      done
      echo
      sudo virsh undefine --remove-all-storage "$NAME"
    else
      continue 
    fi
  fi

  OLD_DISKS=$(find "$KVM_DISK_PATH" -name '*'"-$NAME")
  if [[ -n "$OLD_DISKS" ]];  then
    echo "Old disks for $NAME was found - delete all? (Y/n)"
    echo $OLD_DISKS | tr ' ' '\n'
    read DELETE;
    if [[ "$DELETE" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      find "$KVM_DISK_PATH" -name '*'"-$NAME" -delete
    fi
  fi

  DISK="$(mktemp -p "$KVM_DISK_PATH" --suffix "-${rhel}-misp")"
  echo "Copying master ${!QCOW} to $DISK"
  rsync --quiet "${!QCOW}" "$DISK"
  echo "Generating XML for VM"
  XML=$(sudo virt-install --name "$NAME" --import --disk "${DISK}" --os-variant "${!VARIANT}" --graphics none --network "network=$KVM_NETWORK,mac=${!MAC}" --print-xml)
  echo "Creating VM using virsh define /dev/stdin"
  echo "$XML" | sudo bash -c "virsh define /dev/stdin" || { rm "$DISK" && exit; }
  sudo virsh start "$NAME"
  echo ""
done
sleep 5
sudo virsh list --all | grep -o 'rhel.-misp' | cat | while read -r NAME; do
IP=$(sudo virsh domifaddr "$NAME" --full | grep 'ipv4' | awk '{print $NF}' | cut -d/ -f1)
echo $NAME $IP
ssh-keygen -f "/home/hildenae/.ssh/known_hosts" -R "$IP" 2>/dev/null 1>/dev/null
done


## TODO loop 