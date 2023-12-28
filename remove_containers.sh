#! /bin/bash
source env.sh
for distro in "alma9" "deb12" "ubu20" "ubu22"; do
  DISTRO=${distro^^};
  NAME="${distro}-misp"
  if $CONTAINER_CMD info "$NAME" 2>/dev/null 1>/dev/null; then
        echo "Stopping $NAME"
        $CONTAINER_CMD stop "$NAME"
        echo "Deleting $NAME"
        $CONTAINER_CMD delete "$NAME"
  fi
done