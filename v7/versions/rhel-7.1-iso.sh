#!/bin/bash

# to use this script, from its parent dir, run: ./versions/<script>.sh <target>
# you'll want to edit the below bash variables to match your use cases :)
# eg: ./versions/rhel-7.0.sh upload
# to make your own base image and upload it to your own server somewhere.

VERSION='rhel-7.1'
POSTFIX='iso'
ISO='rhel-server-7.1-x86_64-dvd.iso'
SERVER=''
REMOTE_PATH=''	# make a $VERSION directory in this dir
KEYS='EPEL-7 puppetlabs'	# add extra keys to the base image
REPOS='epel7 epel7-testing el7-puppet'	# add extra repos for docker, etc...
IMAGES=''
# TODO: add moreutils
PACKAGES='sudo vim-enhanced git wget file man tree nmap tcpdump htop lsof telnet mlocate bind-utils koan iftop yum-utils nc psmisc bash-completion'
POOLID=''
RHELREPOS='rhel-7-server-rpms rhel-7-server-extras-rpms'
make VERSION=$VERSION POSTFIX=$POSTFIX ISO=$ISO SERVER=$SERVER REMOTE_PATH=$REMOTE_PATH KEYS="$KEYS" REPOS="$REPOS" IMAGES="$IMAGES" PACKAGES="$PACKAGES" POOLID="$POOLID" RHELREPOS="$RHELREPOS" $@

