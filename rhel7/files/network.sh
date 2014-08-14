#!/bin/bash

# Disable firewall
systemctl disable firewalld
# Enable sshd
systemctl enable sshd

# Networking setup...
rm -rf /var/lib/dhclient/*	# remove any old leases that could be around...

# XXX: unsure if this will help, but we'll try it out:
# Problem situation: Two interfaces are connected to same network. One interface
# wants to renew DHCP lease and asks server for address. DHCPACK message from
# server arrives, client moves to BOUND state. The client performs a check on
# the suggested address to ensure that the address is not already in use. On
# arping for specified IP address, other interface replies and that's why
# dhclient-script replies with DHCPDECLINE message. (See RFC2131, 4.4.1.).
# Solution: Set sysctl to reply only if the target IP address is local address
# configured on the incoming interface. (See kernel documentation
# Documentation/networking/ip-sysctl.txt)
set_sysctl() {
	grep "$1" /etc/sysctl.conf > /dev/null
	[ $? -eq 0 ] && sed -i '/'$1'/d' /etc/sysctl.conf
	echo "$1 = $2" >> /etc/sysctl.conf
}
set_sysctl 'net.ipv4.conf.all.arp_ignore' 1
set_sysctl 'net.ipv4.conf.all.arp_announce' 2
set_sysctl 'net.ipv4.conf.all.rp_filter' 3

# Interface eth0 should get IP address via dhcp.
# FIXME
