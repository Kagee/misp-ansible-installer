This is a repository for trying to write a ansible installer for https://github.com/MISP/MISP

It is currently in a barly-started state, and probably useless for you.

# RHEL test VM instructions
* Join developer program
* Make and download base images from https://console.redhat.com/insights/image-builder
* apt install virt-customize virtinst
* Copy example.env to .env, and configure appropriately, including cofiguring a KVM network
* ./prepare_rhel_qcow2.sh
* ./create_rhel_kvm.sh

restorecon -FRv /root/.ssh`
incus exec deb12-misp -- apt install -y openssh-server
incus exec deb12-misp -- mkdir -p /root/.ssh

lxc launch ubuntu:20.04 misp-develop
lxc launch images:almalinux/8 deleteme
lxc exec alma-8 -- /bin/bash

lxc exec deleteme -- ip -4 route show default | awk '/default/ {print $3}'
10.170.0.1
lxc exec deleteme -- ip -4 route show default | awk '/default/ {print $5}'
eth0
lxc exec deleteme -- ip -4 addr show eth0 | awk '/inet/ {print $2}'  | cut -d/ -f1
10.170.0.187/24

# Ansible
pipx install --include-deps ansible