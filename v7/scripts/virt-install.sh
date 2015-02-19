#!/bin/bash
# Run a virt-install for eventual consumption by virt-builder
# Copyright (C) 2013 Red Hat Inc.
# Copyright (C) 2010-2013+ James Shubin
# Written by virt-builder contributors
# Modified by James Shubin <james@shubin.ca>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

unset CDPATH
export LANG=C
set -e
set -x

if [ $# -ne 3 ]; then
	echo "$0 NAME ISO OUTPUT"
	exit 1
fi

output="$1" # eg: rhel-7.0
iso="$2"
fulloutput="$3"

tmpname=tmp-$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)
guestroot=/dev/sda3

major=7
bootfs=ext4
rootfs=xfs

# Generate the kickstart to a temporary file.
ks=$(mktemp)
cat > $ks <<'EOF'
install
text
lang en_US.UTF-8
keyboard us
network --bootproto dhcp
rootpw builder
firewall --enabled --ssh
timezone --utc America/New_York
EOF

if [ $major -ge 4 ]; then
cat >> $ks <<EOF
selinux --enforcing
EOF
fi

cat >> $ks <<EOF
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200 rd_NO_PLYMOUTH"
zerombr
clearpart --all --initlabel
part /boot --fstype=$bootfs --size=512 --asprimary
part swap --size=1024 --asprimary
part / --fstype=$rootfs --size=1024 --grow --asprimary

EOF

if [ $major -ge 4 ]; then
cat >> $ks <<EOF
# Halt the system once configuration has finished.
poweroff

EOF
fi

cat >> $ks <<EOF
%packages
@core
EOF

# RHEL 5 didn't understand the %end directive, but RHEL >= 6
# requires it.
if [ $major -ge 6 ]; then
cat >> $ks <<EOF
%end
EOF
fi

# Clean up function.
cleanup ()
{
	rm -f $ks
	sudo virsh undefine $tmpname ||:
}
trap cleanup INT QUIT TERM EXIT ERR

sudo virt-install \
	--name=$tmpname \
	--ram=2048 \
	--cpu=host --vcpus=2 \
	--os-type=linux --os-variant=rhel$major \
	--initrd-inject=$ks \
	--extra-args="ks=file:/`basename $ks` console=tty0 console=ttyS0,115200" \
	--disk "$fulloutput,size=6" \
	--serial pty \
	--location="$iso" \
	--nographics \
	--noreboot

# if the whole script is run as root, then this needs to be $SUDO_USER
sudo chown $USER $fulloutput	# needed since virt-install needs to run as root...

