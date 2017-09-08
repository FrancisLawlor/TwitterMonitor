#!/bin/bash

if [ ! $# -eq 1 ] && [ ! $# -eq 2 ]
then
	echo "You must enter the username whose account you want to monitor and/or an e-mail address to send notifications!"
	exit
fi

if curl --output /dev/null --head --fail --silent "https://twitter.com/$1"
then
	echo "Running..."
else
	echo "Cannot find $1's profile!"
	exit 0
fi

previousNumberOfTweets=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweet)'`
previousNumberOfTweets="${previousNumberOfTweets//,}"

while [ 1 ];
do
	currentNumberOfTweets=`curl -s "https://twitter.com/$1" | grep -o -P '(?<=title=").*(?= Tweet)'`
	currentNumberOfTweets="${currentNumberOfTweets//,}"

	# Check if number of tweets increases from 0 (Edge case).
	if [ -z $previousNumberOfTweets ] && [ ! -z $currentNumberOfTweets ]
	then
		`notify-send "New tweet from @$1!" -i ~/Pictures/smirk.png`
		previousNumberOfTweets=$currentNumberOfTweets
	fi

	# Check if number of tweets decreases to 0 (Edge case).
	if [ ! -z $previousNumberOfTweets ] && [ -z $currentNumberOfTweets ]
	then
		`notify-send "@$1 removed a tweet!"`
		previousNumberOfTweets=$currentNumberOfTweets
	fi

	if [ ! -z $currentNumberOfTweets ] && [ ! -z $previousNumberOfTweets ]
	then
		if [ $currentNumberOfTweets -gt $previousNumberOfTweets ]
		then
			if [ -n "$2" ]
			then
				`echo "Check @$1's twitter for their latest tweet!" | mail -s "New tweet from @$1!" $2`
			fi

			# Replace image path with yours.
			`notify-send "New tweet from @$1!" -i ~/Pictures/twitter_icon.png`
			previousNumberOfTweets=$currentNumberOfTweets

		elif [ $currentNumberOfTweets -lt $previousNumberOfTweets ]
		then
			`notify-send "@$1 removed a tweet!"`
			previousNumberOfTweets=$currentNumberOfTweets
		fi
	fi
	sleep 10
done
