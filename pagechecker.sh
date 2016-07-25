#!/bin/bash

#First parameter should be twitter username. Second parameter should be e-mail address to send prompt to.

prev=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweets)'`
echo "Running..."

while [ 1 ];
do
	current=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweets)'`
	if [ $current -gt $prev ]
	then
       		`echo "A new tweet!" | mail -s "New tweet from @$1!" $2`
		`notify-send "New tweet from @$1!"`
		prev=$current

	elif [ $current -lt $prev ]
	then
		`notify-send "@$1 removed a tweet!"`
		prev=$current
   	fi
	sleep 10   
done		
