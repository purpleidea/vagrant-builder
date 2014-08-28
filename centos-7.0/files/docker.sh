#!/bin/bash

# workaround docker pull's inability to pull a list of images in one shot...
if [ "$1" = 'pull' ] && [ "$2" != '' ]; then

	# docker pull won't work if the daemon isn't running... :(
	# /usr/bin/docker -d -H fd:// --selinux-enabled &
	# /usr/bin/docker -d -H fd:// &
	while [ "$2" != '' ]; do
		docker pull "$2"
		e=$?
		if [ $e -ne 0 ]; then
			exit $e
		fi
		shift
	done
else
	exit 1
fi

