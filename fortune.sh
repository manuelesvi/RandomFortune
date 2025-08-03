#!/bin/bash

COWFILE=""
if [ $# -ge 1 ]
then
  COWFILE="-f ${1}" # use 1st given argument
else
  cows=($(find /usr/share/cowsay/cows \
          -name *.cow \
          -printf "%f\n")) # get all cows
  cow_number=$(($RANDOM % ${#cows[@]} + 1)) # pick one randomly
  printf "\n${cows[$cow_number]}" | \
         sed 's/.cow$/ says: \n/' | \
         lolcat --freq=0.75 --duration=4 --speed=10
#  sleep 1
  COWFILE=$(echo "-f ${cows[$cow_number]}" | \
            sed 's/.cow$//')
fi

# keep a record in fortune.txt
printf '\n' >> fortune.txt
fortune=$(fortune)
echo $fortune | tee -a fortune.txt | \
       (printf '\n' && \
       cowsay $COWFILE && printf '\n') | \
       lolcat --animate \
              --freq=0.5 --duration=4 --speed=30 \
	      --spread=$(($RANDOM % 10 + 1)) && \
       printf '_%.0s' {1..40} >> fortune.txt && \
       printf '\n' >> fortune.txt

# create new file & commit it to repo
[ ! -d ~/fortunes/day_$(date +%Y_%m_%d) ] && \
  mkdir -p ~/fortunes/day_$(date +%Y_%m_%d)

filename=~/fortunes/day_$(date +%Y_%m_%d)/fortune_$(date +%Y%m%d)_$(date +%H%M%S).txt
echo $fortune > $filename

cd ~/fortunes; git add $filename

if [ ${#fortune} -lt 80 ]; then
  git commit -m "$fortune" > /dev/null 2>&1
else
  git commit -m "${fortune:0:80}..." > /dev/null 2>&1 # use first 80 characters only as commit's message
fi

cd - > /dev/null 2>&1

unset filename fortune
