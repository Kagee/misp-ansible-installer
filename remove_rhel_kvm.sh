#! /bin/bash
source env.sh
sudo -n true 2>/dev/null || echo "We need to be root to run virt-install"
for rhel in "rhel8" "rhel9"; do
  RHEL=${rhel^^}
  NAME="${rhel}-misp"
  VM=$(sudo virsh list --all | grep " $NAME " | awk '{ print $3}')
  if [[ -n "$VM" ]];  then
    #echo "VM named $NAME was found - delete? (Y/n)"
    #read DELETE;
    echo "VM named $NAME was found, deleting"
    DELETE=y
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
done