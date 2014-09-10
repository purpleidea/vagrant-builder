#!/bin/bash

# avoid failures if no packages are passed in to yum install
if [ "$1" = 'install' ]; then
	shift
	if [ x"$@" = 'x' ]; then
		exit
	fi
	yum -y install "$@"
	e=$?
	if [ $e -ne 0 ]; then
		exit $e
	fi

else
	exit 1
fi

