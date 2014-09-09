#!/bin/bash

# to use this script, from its parent dir, run: ./versions/<script>.sh <target>
# you'll want to edit the below bash variables to match your use cases :)
# eg: ./versions/centos-7.sh upload
# to make your own base image and upload it to your own server somewhere.

VERSION='centos-7.0'		# pick from the output of virt-builder -l
POSTFIX='docker'
SERVER=''			# connect over ssh (add your public key first)
REMOTE_PATH=''			# make a $VERSION directory in this dir
REPOS=''			# add extra repos to the base image
IMAGES='centos fedora'		# list of docker images to include
#EXTRAS='golang-github-docker-libcontainer'	# for F20
EXTRAS=''			# list of extra packages to include
make VERSION=$VERSION POSTFIX=$POSTFIX SERVER=$SERVER REMOTE_PATH=$REMOTE_PATH REPOS="$REPOS" IMAGES="$IMAGES" EXTRAS="$EXTRAS" $@

