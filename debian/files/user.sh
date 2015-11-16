#!/bin/bash

useradd -m vagrant
usermod -p $(echo vagrant | openssl passwd -1 -stdin) vagrant
grep '^admin:' /etc/group > /dev/null || groupadd admin
usermod -G admin vagrant

echo '%admin ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sed -i 's/Defaults\s*requiretty/Defaults !requiretty/' /etc/sudoers
