#!/bin/bash

# to use this script, from its parent dir, run: ./versions/<script>.sh <target>
# you'll want to edit the below bash variables to match your use cases :)
# eg: ./versions/debian-8.sh upload
# to make your own base image and upload it to your own server somewhere.

VERSION='debian-8'		# pick from the output of virt-builder -l
POSTFIX=''			# add this string onto the base version
SIZE='40'			# disk size of image
SERVER=''			# connect over ssh (add your public key first)
REMOTE_PATH=''			# make a $VERSION directory in this dir
KEYS=''				# add extra keys to the base image
REPOS=''			# add extra repos to the base image
DOCKER=''			# list of docker images to include
PACKAGES='sudo vim-nox git wget file man tree nmap tcpdump htop lsof telnet mlocate bind9-host iftop netcat psmisc bash-completion moreutils'	# list of extra packages to include
make VERSION=$VERSION POSTFIX=$POSTFIX SIZE=$SIZE SERVER=$SERVER REMOTE_PATH=$REMOTE_PATH KEYS="$KEYS" REPOS="$REPOS" DOCKER="$DOCKER" PACKAGES="$PACKAGES" $@
