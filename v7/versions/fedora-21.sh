#!/bin/bash

# to use this script, from its parent dir, run: ./versions/<script>.sh <target>
# you'll want to edit the below bash variables to match your use cases :)
# eg: ./versions/fedora-21.sh upload
# to make your own base image and upload it to your own server somewhere.

VERSION='fedora-21'		# pick from the output of virt-builder -l
POSTFIX=''
SIZE='40'			# disk size of image
SERVER=''	# connect over ssh (add your public key first)
REMOTE_PATH=''	# make a $VERSION directory in this dir
KEYS='puppetlabs'
REPOS='f20-puppet'	# XXX: puppetlabs doesn't have an f21 repo yet...
IMAGES=''
PACKAGES='sudo vim-enhanced git wget file man tree nmap tcpdump htop lsof telnet mlocate bind-utils koan iftop yum-utils nmap-ncat psmisc bash-completion moreutils'	# list of extra packages to include
make VERSION=$VERSION POSTFIX=$POSTFIX SIZE=$SIZE SERVER=$SERVER REMOTE_PATH=$REMOTE_PATH KEYS="$KEYS" REPOS="$REPOS" IMAGES="$IMAGES" PACKAGES="$PACKAGES" $@

