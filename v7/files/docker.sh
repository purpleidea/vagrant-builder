#!/bin/bash

# workaround docker pull's inability to pull a list of images in one shot...
if [ "$1" = 'pull' ] && [ "$2" != '' ]; then
	# docker pull won't work if the daemon isn't running... :(
	# /usr/bin/docker -d -H fd:// --selinux-enabled &
	# /usr/bin/docker -d -H fd:// &
	# /usr/bin/docker -d -H unix:///var/run/docker.sock &
	docker -H unix:///var/run/docker.sock -d --selinux-enabled &

	# add a 5 second sleep so that it has time to be ready (FIXME)
	sleep 5

	while [ "$2" != '' ]; do
		docker pull "$2"
		e=$?
		if [ $e -ne 0 ]; then
			exit $e
		fi
		shift
	done
	# so that virt-builder can exit cleanly
	killall docker
fi

