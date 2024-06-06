#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

MACHINE=$(hostname)

GREEN="$(tput setaf 10)"
RES="$(tput sgr0)"

first=true

entry="${GREEN}${MACHINE}${RES} welcomes you ${GREEN}${USER}${RES}!"
entryPatch="${MACHINE} welcomes you ${USER}!"

bash ~/programs/bash/RAMWatch.sh &

tput vpa 1

clear(){
	command clear
	
	date="$(date)"

	width=$(tput cols)

	tput vpa 1

	if $first;then
		tput hpa $(((width / 2)-(${#entryPatch} / 2)))
		echo $entry
		first=false
		tput vpa 2 
	fi

	tput hpa $(((width / 2)-(${#date} / 2)))
	echo $date
}

bind -x '"\C-l":clear'

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/OLupGM

clear
trap clear WINCH

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias please='sudo'
alias pls='sudo'

PS1='\A | ${GREEN}\u${RES} | \w \$> '
PS2='> '
