#!/bin/bash
COWFILE=""
if [ $# -ge 1 ]
then
	# use specified cow in first argument
	COWFILE="-f ${1}"
else
	# pick a random cow
	cows=($(find /usr/share/cowsay/cows -name *.cow -printf "%f\n"))
	cow_number=$(($RANDOM % ${#cows[@]} + 1))
	printf "${cows[$cow_number]}" | sed 's/.cow$/ says: \n/' | lolcat -F 0.75
	sleep 1
	COWFILE=$(echo "-f ${cows[$cow_number]}" | sed 's/.cow$//')
fi

# printf '%s\n' "$COWFILE"

printf '\n' >> fortune.txt

fortune /usr/share/games/fortunes | tee -a fortune.txt | (cowsay $COWFILE && printf "\n") | lolcat -a -F 0.5 -s 40 -p $(($RANDOM % 10 + 1)) && printf '_%.0s' {1..40} >> fortune.txt && printf '\n' >> fortune.txt


