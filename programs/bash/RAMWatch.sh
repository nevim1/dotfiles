#!/usr/bin/env bash

change(){
	W=$(tput cols)
}

change

trap change WINCH

padd=20		#in whitespaces

while true; do
	ram=$(free | grep -i Mem:)
	IFS=' ' read -ra ramArr <<< $ram
	declare ramArr


	nums="${ramArr[1]}/${ramArr[6]}"


	fill=$(echo $((((($W-${#nums}-2-$padd)*${ramArr[6]})/${ramArr[1]})/1)))


	out="["

	for ((i=0; i<$fill; i++)); do
		out+="#"
	done

	for ((i=0; i<$(($W-$fill-${#nums}-2-$padd)); i++)); do
		out+="_"
	done
	out+="]"

	tput sc
	tput home
	echo $nums
#	for ((i=0; i<$padd; i++)); do
#		tput cup 0 $(($i+1+${#nums}))
#		echo " "
#	done
       	tput cup 0 $((${#nums}+$padd))
	echo $out 
	tput rc
	sleep 1
done
