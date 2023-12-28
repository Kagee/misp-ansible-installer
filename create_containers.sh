#! /bin/bash
echo "This script will create and start three"
echo "LXC containers based on the values in .env."
echo
echo "Press ENTER to continue, CTRL-C to cancel."
read

source env.sh

for distro in "alma9" "deb12" "ubu20" "ubu22"; do
  DISTRO=${distro^^};
  NAME="${distro}-misp"
  LXC_IMAGE="${DISTRO}_LXC_IMAGE"
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
#lxc exec alma-8 -- /bin/bash