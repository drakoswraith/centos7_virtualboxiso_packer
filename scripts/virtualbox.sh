 #!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

if systemctl list-unit-files | grep -q dkms.service; then
  sudo systemctl start dkms
  sudo systemctl enable dkms
fi
#apt-get install -y bzip2 gcc make perl
sudo mount -o loop,ro ~/VBoxGuestAdditions.iso /mnt/

# VBoxService --note that the VBox*.run scripts always returns 1, which looks like a failure
sudo /mnt/VBoxLinuxAdditions.run --nox11 || :
sudo umount /mnt/
rm -f ~/VBoxGuestAdditions.iso