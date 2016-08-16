#!/bin/bash

#First parameter should be twitter username. Second optional parameter should be e-mail address to send prompt to.

# Check if user is failing to enter the required parameters.
if [ ! $# -eq 1 ] && [ ! $# -eq 2 ]
then 
	echo "You must enter the username whose account you want to monitor and/or an e-mail address to send notifications!"
	exit 
fi

# Check if the indicated username is valid by checking if the corresponding webpage exists.
if curl --output /dev/null --head --fail --silent "https://twitter.com/$1"	
then
	echo "Running..."
else
	echo "Cannot find $1's profile!"
	exit 0
fi

# Parse number of tweets user currently has for comparison when user tweets/removes tweets.
prev=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweet)'`

# Remove any commas from the parsed number.
prev="${prev//,}"

while [ 1 ];
do
	current=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweet)'`
	
	# Remove any commas from the parsed number.

	current="${current//,}"

	if [ $current -gt $prev ]
	then
		if [ -n "$2" ]
		then
       			`echo "Check @$1's twitter for their latest tweet!" | mail -s "New tweet from @$1!" $2`
		fi
		
		# Add image to your notification by adding the path as a parameter to the the notify-send command.
		# Mine is called "smirk.png and is stored in the Pictures directory.
		# :smirk:

		`notify-send "New tweet from @$1!" -i ~/Pictures/smirk.png`
		prev=$current

	elif [ $current -lt $prev ]
	then
		`notify-send "@$1 removed a tweet!"`
		prev=$current
   	fi
	sleep 10
done		
