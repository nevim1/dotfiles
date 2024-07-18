#!/usr/bin/env bash
#oi bruv, i kinda dont get this

change(){
	W=$(tput cols)
}

change

trap change WINCH

padd=20		#in whitespaces

if ! test -f ./settings.conf ;then
	touch ./settings.conf 
	
	./settings.conf < echo true
fi

run=$(head -n 1 ./settings.conf)

while true; do
	if $run; then
		ram=$(free | grep -i Mem:)
		IFS=' ' read -ra ramArr <<< $ram
		declare ramArr
		
		
		nums="${ramArr[1]}/${ramArr[2]}"
		
		
		fill=$(echo $((((($W-${#nums}-2-$padd)*${ramArr[2]})/${ramArr[1]})/1)))
		
		
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
#		for ((i=0; i<$padd; i++)); do
#			tput cup 0 $(($i+1+${#nums}))
#			echo " "
#		done
 	      	tput cup 0 $((${#nums}+$padd))
		echo $out 
		tput rc
		sleep 1
	fi
done
