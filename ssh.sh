#!/bin/bash

BASE=$HOME/logsandi/

sed -e '/sshd\[[0-9]*\]: Failed password/!d' \
    -e 's/.*Failed password for.*from //' \
    -e 's/ port.*//' /var/log/auth.log | sort | uniq -c | \
while read count host
	do
	hostx=$(echo $host | sed -e 's/::ffff://')
#	echo $host $count
#	echo $hostx $count

	if grep "^$hostx" $BASE/daftarhitam.log ; then
		echo "$hostx already blocked"
	else

		if [ "$count" -gt "5" ]; then
			echo "$hostx brute force $count"
			echo "$hostx bf $count" >> $BASE/daftarhitam.log
		fi
	fi
done
