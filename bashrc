#
# ~/.bashrc
#oi bruv

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


MACHINE=$(hostname)


GREEN="$(tput setaf 2)"
RES="$(tput sgr0)"


first=true


entry="${GREEN}${MACHINE}${RES} welcomes you ${GREEN}${USER}${RES}!"
entryPatch="${MACHINE} welcomes you ${USER}!"


bash ~/Documents/programs/bash/RAMWatch.sh &

RAM_WATCH_PID=$!


if $(head -n 1 ~/Documents/programs/bash/settings.conf); then
	RAMPush=1
else
	RAMPush=0
fi

tput vpa $RAMPush

clear(){
	command clear
	
	date="$(date)"

	width=$(tput cols)

	tput vpa $RAMPush

	if $first;then
		tput hpa $(((width / 2)-(${#entryPatch} / 2)))
		echo $entry
		first=false
		tput vpa $((RAMPush + 1))
	fi

	tput hpa $(((width / 2)-(${#date} / 2)))
	echo $date
}

bind -x '"\C-l":clear'


cleanup(){
	echo "Hold on"
	kill $SSH_AGENT_PID
	kill $RAM_WATCH_PID
	sleep 1 
	echo "terminal ended succesfully"
}

sighupHandle(){
	echo "closing terminal window"
	cleanup
	exit
}


eval "$(ssh-agent -s)"
ssh-add ~/.ssh/OLupGM


clear
trap clear WINCH

trap cleanup EXIT
trap sighupHandle SIGHUP


alias ls='ls --color=auto'
alias l='ls'
alias la='ls -a --color=auto'
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias please='sudo'
alias pls='sudo'
alias nuke='rm -rf'


#nuh uh
PS1='\n──────┴───────┘\033[1F\A │ ${GREEN}\u${RES} │ \w \$> '
PS2='> '
