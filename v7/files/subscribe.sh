#!/bin/bash

set -e

# TODO: ensure the password is stored/erased more securely...
if [ -e /root/subscribe.input.sh ]; then
	. /root/subscribe.input.sh

	if (test "$USERNAME" != "" && test "$PASSWORD" != ""); then
		subscription-manager register --username="$USERNAME" --password="$PASSWORD"

		if test "$ATTACH" = "" || test "$ATTACH" = '--auto'; then
			subscription-manager attach --auto
		else
			IFS=' ' read -ra x <<< "$ATTACH"	# split by spaces...
			for i in "${x[@]}"; do
				subscription-manager attach --pool="$i"
			done
			unset x
		fi


		if test "$REPOS" != ""; then
			# disable others first...
			subscription-manager repos --disable="*"	# faster
			#for i in `subscription-manager repos --list | tail -n +4 | grep -v "^ " | awk 'RS=""; FS="\n" {if ($4 == "Enabled:   1") print $1}' | awk '{print $3}'`; do
			#	echo "Repos(del): $i"
			#	subscription-manager repos --disable=$i
			#done

			IFS=' ' read -ra x <<< "$REPOS"	# split by spaces...
			for i in "${x[@]}"; do
				#echo "Repos(add): $i"
				subscription-manager repos --enable="$i"
			done
			unset x
		fi
	fi

	rm -f /root/subscribe.input.sh
fi

# clean up
cleanup ()
{
	subscription-manager unregister
}
trap cleanup INT ERR	# TODO: is this sufficient / correct ?

