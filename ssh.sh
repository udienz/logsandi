#!/bin/bash

git pull origin master

BASE=$HOME/logsandi

blacklist=$BASE/daftarhitam.log
whitelist=$BASE/daftarputih.log
wrapper=/etc/hosts.deny

if [ ! -f $BASE/daftarhitam.log ]; then
        touch $BASE/daftarhitam.log
fi

sed -e '/sshd\[[0-9]*\]: Failed password/!d' \
    -e 's/.*Failed password for.*from //' \
    -e 's/ port.*//' /var/log/auth.log | sort | uniq -c | \
while read count host
        do
        hostx=$(echo $host | sed -e 's/::ffff://')

if [ "$count" -gt "5" ]; then
	if grep "^$hostx" $whitelist ; then
		echo "host $hostx has whitelist"

	else
		if grep "^sshd: $hostx" $wrapper ; then
			echo "already blocked at tcpwrapper"
		else
			echo "sshd: $hostx" >> $wrapper
				if grep "^$hostx" $blacklist ; then
					echo "$hostx already blocked"
				else
					echo "$hostx" >> $blacklist
				fi
		fi
	fi
fi
done

git add *
git commit -m "autocommit at $(hostname)"
git push origin master

