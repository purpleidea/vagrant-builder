#!/bin/bash

# to use this script, from its parent dir, run: ./versions/<script>.sh <target>
# you'll want to edit the below bash variables to match your use cases :)
# eg: ./versions/centos-7.sh upload
# to make your own base image and upload it to your own server somewhere.

VERSION='centos-7.1'		# pick from the output of virt-builder -l
POSTFIX='docker'
SIZE='40'			# disk size of image
SERVER=''			# connect over ssh (add your public key first)
REMOTE_PATH=''			# make a $VERSION directory in this dir
KEYS='EPEL-7 puppetlabs'	# add extra keys to the base image
REPOS='epel7 epel7-testing el7-puppet'	# add extra repos to the base image
DOCKER='centos fedora'		# list of docker images to include
#PACKAGES='golang-github-docker-libcontainer'	# add for F20
PACKAGES='sudo vim-enhanced git wget file man tree nmap tcpdump htop lsof telnet mlocate bind-utils koan iftop yum-utils nc psmisc bash-completion moreutils kubernetes flannel'
make VERSION=$VERSION POSTFIX=$POSTFIX SIZE=$SIZE SERVER=$SERVER REMOTE_PATH=$REMOTE_PATH KEYS="$KEYS" REPOS="$REPOS" DOCKER="$DOCKER" PACKAGES="$PACKAGES" $@
