#!/bin/bash

#First parameter should be twitter username. Second parameter should be e-mail address to send prompt to.

# Check if user is failing to enter the two required parameters.
if [ ! $# -eq 2 ]
	then echo You must enter two arguments, the username you want to monitor and the e-mail to send notifications to!
	exit
fi

# Check if the indicated username is valid.
if curl --output /dev/null --head --fail --silent "https://twitter.com/$1"
then
	echo "Running..."
else
	echo "Cannot find $1's profile!"
	exit 0
fi

# Parse number of tweets user currently has for comparison when user tweets/removes tweets.
prev=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweets)'`

# Remove any commas from the parse number.
prev="${prev//,}"

while [ 1 ];
do
	current=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweets)'`
	
	# Remove any commas from the parse number.

	current="${current//,}"

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
