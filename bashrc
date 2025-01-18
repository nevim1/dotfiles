#
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#define some constants
MACHINE=$(hostname)

GREEN="$(tput setaf 2)"
RES="$(tput sgr0)"

first=true

resize_clear=false

entry="${GREEN}${MACHINE}${RES} welcomes you ${GREEN}${USER}${RES}!"
entryPatch="${MACHINE} welcomes you ${USER}!"

#read configs
if $(head -n 1 ~/Documents/programs/bash/dotfiles/settings.conf); then
	bash ~/Documents/programs/bash/dotfiles/RAMWatch.sh &

	RAM_WATCH_PID=$!
	
	RAMPush=1
else
	RAMPush=0
fi

tput vpa $RAMPush

#make clearing method
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

#bind it to <ctrl> + l
bind -x '"\C-l":clear'

#make method for NOT making zombies
cleanup(){
	echo Hold on
	echo trying to kill ssh and ram
	if ! [ -z $SSH_AGENT_PID ];then
		kill $SSH_AGENT_PID
		unset SSH_AGENT_PID
		echo ssh agent killed
	fi

	if ! [ -z $RAM_WATCH_PID ]; then
		kill $RAM_WATCH_PID
		unset RAM_WATCH_PID
		echo ram watch killed
	fi
	sleep 5 
	echo terminal ended succesfully
}

#handle when the window of this shell is closed
sighupHandle(){
	cleanup
	exit
}

#when I am using vit too much
:q(){
	cleanup
	exit
}

#starting SSH agent
startSSH(){
	if [ -v $SSH_AGENT_PID ]; then
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/nevim-linux-lenovo-ssh-key
	fi
}

#autostart SSH agent when trying to access remote
git(){
	case $@ in
		push*)
			startSSH
			command git $@ 
			;;
		pull*)
			startSSH
			command git $@
			;;
		fetch*)
			startSSH
			command git $@
			;;
		*)
			command git $@
			;;
	esac
}

#somewhy doesn't work for multiword dir names
cl(){
	cd $@
	ls --color=auto
}

clear

if $resize_clear; then
	trap clear WINCH
fi

#just because I tried wsl on windows (fuck windows)
bind 'set bell-style none'

#make it that i wouldn't have zombies
trap cleanup EXIT
trap sighupHandle SIGHUP

#some aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias l='ls -la'
alias grep='grep --color=auto'
alias please='sudo'
alias pls='sudo'
alias nuke='rm -rf'
alias ip='ip -c'

#next line is for closing (I probablly won't use it)
#\[\n──────┴───────┘\033[1F\]

#TODO: add git status and program exit codes
PS1='\A │ \[$GREEN\]\u\[$RES\] │ \w \$> '
PS2='> '
