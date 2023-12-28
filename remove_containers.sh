#! /bin/bash
source env.sh
for distro in "alma9" "deb12" "ubu20" "ubu22"; do
  DISTRO=${distro^^};
  NAME="${distro}-misp"
  if $LXC_INCUS info "$NAME" 2>/dev/null 1>/dev/null; then
        echo "Stopping $NAME"
        $LXC_INCUS stop "$NAME"
        echo "Deleting $NAME"
        $LXC_INCUS delete "$NAME"
  fi
done