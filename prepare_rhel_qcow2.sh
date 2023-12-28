#! /bin/bash
source env.sh
sudo -n true 2>/dev/null || echo "We need to be root to run virt-customize"

for rhel in "rhel8" "rhel9"; do
  RHEL=${rhel^^}
  QCOW="${RHEL}_QCOW2_SOURCE"
  NAME="${rhel}-misp"
  echo "Preparing $rhel"
  # /etc/pki/product prevent:ws
  set -x
  sudo virt-customize \
    --add "${!QCOW}" \
    --hostname "$NAME" \
    --root-password "password:toor" \
    --uninstall cloud-init \
    --delete /etc/pki/product \
    --ssh-inject "root:file:$SSH_PUB_KEY_FILE" \
    --selinux-relabel;
  set +x
done
