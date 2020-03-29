#!/bin/bash
### ### ### Settings ### ### ###
discord="[Discord Webhook]"
msg="Active Infected:"
# Country?
# Leave a forward slash '/' for global, use '/country/[country to track]' to set country tracking.
# If it does not work for your country, have a look at the table at https://www.worldometers.info/coronavirus/
country="/"
# https://github.com/jakesta13
### ### ### ### ### ### ###
# Set last to 0 if you want it to send the initial update, otherwise leave it blank.
last=0
while true; do
	count=$(curl -s "https://www.worldometers.info/coronavirus${country}" | grep number-table-main | head -n 2 | tail -n 1 | sed -e 's/.*\"//' -e 's/.//' -e 's/<.*//')
	if [ -z "${last}" ]; then
		echo "First Run, Don't send, ${count}"
		last="${count}"
	else
		if [ "${count}" != "${last}" ]; then
			dif=$(echo "${count} ${last}")
			dif=$(echo "${dif}" | sed 's/,//g' | awk '{print $1 - $2}')
			echo "${msg} ${count}. Change: ${dif}"
			curl -m 2 -H "Content-Type: application/json" -X POST -d '{"'"content"'": "'"${msg} ${count}. \n Change: ${dif}"'"}' "${discord}"
			last="${count}"
		else
			echo "No change. ${count}"
		fi
	fi
	sleep 300
done
