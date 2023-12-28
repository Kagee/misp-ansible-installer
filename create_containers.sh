#! /bin/bash
echo "This script will create and start three"
echo "containers based on the values in .env."
echo
echo "Press ENTER to continue, CTRL-C to cancel."
read

source env.sh

for distro in "alma9" "deb11" "deb12" "ubu20" "ubu22"; do
  DISTRO=${distro^^};
  NAME="${distro}-misp"
  CONTAINER_IMAGE="${DISTRO}_CONTAINER_IMAGE"
  if $CONTAINER_CMD info "$NAME" 2>/dev/null 1>/dev/null; then
    echo "Found container with name $NAME. Terminate or skip? (T/s)"
    read DELETE;
    # Try additional commands here...
    if [[ "$DELETE" =~ ^([tT])$ ]]; then
        $CONTAINER_CMD stop "$NAME"
        $CONTAINER_CMD delete "$NAME"
    else
        continue
    fi
    
  fi
  $CONTAINER_CMD launch --profile "$CONTAINER_PROFILE" "${!CONTAINER_IMAGE}" "$NAME"
done


# incus exec deb12-misp -- apt install -y openssh-server
# cat ssh/id_ed25519_ansible.pub | incus exec deb12-misp -- bash -c "cat > /root/.ssh/authorized_keys"
# incus exec deb12-misp -- /bin/bash -c "chmod 0600 /root/.ssh/authorized_keys"
