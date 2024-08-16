#
# ~/.bashrc
#oi bruv

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


MACHINE=$(hostname)


GREEN="$(tput setaf 2)"
RES="$(tput sgr0)"

first=true

resize_clear=false

entry="${GREEN}${MACHINE}${RES} welcomes you ${GREEN}${USER}${RES}!"
entryPatch="${MACHINE} welcomes you ${USER}!"



if $(head -n 1 ~/Documents/programs/bash/bashrc/settings.conf); then
	bash ~/Documents/programs/bash/bashrc/RAMWatch.sh &

	RAM_WATCH_PID=$!
	
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

startSSH(){
	if [ -v $SSH_AGENT_PID ]; then
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/nevim-linux-lenovo-ssh-key
	fi
}

clear

if $resize_clear; then
	trap clear WINCH
fi

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
alias git='startSSH; git '

#\n──────┴───────┘\033[1F

#nuh uh
PS1='\A │ \u │ \w \$> '
PS2='> '
