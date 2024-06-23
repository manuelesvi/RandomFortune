#!/bin/bash

# Este script obtiene frase cualquiera del comando fortune
# e imprime en pantalla con los colores del arcoiris
# la frase.

COWFILE="" # el nombre de la vaca

if [ $# -ge 1 ]
then # usa la vaca que el usuario quiere
	COWFILE="-f ${1}"
else # ó una vaca cualquiera
	cows=($(find /usr/share/cowsay/cows \
          -name *.cow \
          -printf "%f\n")) # todas las vacas disponibles
	cow_number=$(($RANDOM % ${#cows[@]} + 1)) # lanza los dados
	printf "\n${cows[$cow_number]}" | \
         sed 's/.cow$/ says: \n/' | \
         lolcat --freq=0.75 --duration=4 --speed=10
	sleep 1
	COWFILE=$(echo "-f ${cows[$cow_number]}" | \
            sed 's/.cow$//')
fi

printf '\n' >> fortune.txt # respaldo

fortune | tee -a fortune.txt | \
       (printf '\n' && \
       cowsay $COWFILE && printf '\n') | \
       lolcat --animate \
              --freq=0.5 --duration=4 --speed=30 \
	       --spread=$(($RANDOM % 10 + 1)) && \
       # print 40 times '_'
       printf '_%.0s' {1..40} >> fortune.txt && \
       printf '\n' >> fortune.txt
