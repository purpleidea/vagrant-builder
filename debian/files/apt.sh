#!/bin/bash

# avoid failures if no packages are passed in to apt-get install
if [ "$1" = 'install' ]; then
	shift
	if [ x"$*" = 'x' ]; then
		exit
	fi
	apt-get -y install "$@"
	e=$?
	if [ $e -ne 0 ]; then
		exit $e
	fi

else
	exit 1
fi
