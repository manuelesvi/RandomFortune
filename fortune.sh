#!/bin/bash
COWFILE=""
if [ $# -ge 1 ]
then
	COWFILE="-f ${1}"
else
	cows=($(find /usr/share/cowsay/cows -name *.cow -printf "%f\n"))
	cow_number=$(($RANDOM % ${#cows[@]} + 1))
	printf "\n${cows[$cow_number]}" | \
                sed 's/.cow$/ says: \n/' | \
                lolcat -F 0.75
	sleep 1
	COWFILE=$(echo "-f ${cows[$cow_number]}" | sed 's/.cow$//')
fi

# printf '%s\n' "$COWFILE"

printf '\n' >> fortune.txt

fortune | tee -a fortune.txt | \ (printf "\n" && | \ 
       cowsay $COWFILE && printf "\n") | \
       lolcat -a -F 0.5 -s 40 -p $(($RANDOM % 10 + 1)) && \
       printf '_%.0s' {1..40} >> fortune.txt && \
       printf '\n' >> fortune.txt
