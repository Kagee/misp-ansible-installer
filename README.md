pipx install --include-deps ansible


# RHEL
* Join developer program
* Make and download base images from https://console.redhat.com/insights/image-builder
* apt install virt-customize virtinst
* Copy example.env to .env, and configure appropriately
* ./prepare_rhel_qcow2.sh
* 
* ./create_rhel_kvm.sh