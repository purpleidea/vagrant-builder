#!/bin/bash

# set $1's mtime to be the same as the Makefile
t=`stat -c %y Makefile`
touch -md "$t" "$1"
