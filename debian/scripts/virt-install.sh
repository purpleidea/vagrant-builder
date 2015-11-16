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

# Generate the kickstart to a temporary file.
ks=$(mktemp)
cat > $ks <<'EOF'
d-i debian-installer/locale string en_US
d-i keyboard-configuration/xkb-keymap select us
d-i netcfg/choose_interface select auto
d-i netcfg/disable_autoconfig boolean false
d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain
d-i mirror/protocol string ftp
d-i mirror/ftp/hostname string ftp.cz.debian.org
d-i mirror/ftp/directory string /debian
d-i mirror/suite string stable
d-i passwd/root-login boolean true
d-i passwd/make-user boolean false
d-i passwd/root-password password builder
d-i passwd/root-password-again password builder
d-i clock-setup/utc boolean true
d-i time/zone string America/New_York
#firewall --enabled --ssh
EOF

cat >> $ks <<EOF
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/mount_style select uuid

EOF

cat >> $ks <<EOF
d-i base-installer/kernel/image string linux-image-amd64
d-i apt-setup/contrib boolean true
d-i apt-setup/services-select multiselect security, updates
d-i apt-setup/security_host string security.debian.org
tasksel tasksel/first multiselect minimal
d-i pkgsel/upgrade select safe-upgrade
popularity-contest popularity-contest/participate boolean false

d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev  string default
d-i debian-installer/add-kernel-opts string nousb
d-i finish-install/reboot_in_progress note
d-i debian-installer/exit/poweroff boolean true
EOF

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
	--os-type=linux --os-variant=debian7 \
	--initrd-inject=$ks \
	--extra-args="auto console=tty0 console=ttyS0,115200" \
	--disk "$fulloutput,size=6" \
	--serial pty \
	--location="$iso" \
	--nographics \
	--noreboot

# if the whole script is run as root, then this needs to be $SUDO_USER
sudo chown $USER $fulloutput	# needed since virt-install needs to run as root...
