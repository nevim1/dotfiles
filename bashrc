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



if $(head -n 1 ~/Documents/programs/bash/dotfiles/settings.conf); then
	bash ~/Documents/programs/bash/dotfiles/RAMWatch.sh &

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
	echo trying to kill ssh and ram
	if ! [ -z $SSH_AGENT_PID ];then
		kill $SSH_AGENT_PID
		echo ssh agent killed
	fi
	if ! [ -z $RAM_WATCH_PID ]; then
		kill $RAM_WATCH_PID
		echo ram watch killed
	fi
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

git(){
	#next case is a lil bit repetetive but i'm too lazy to fix it
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

reboot(){
	if [ $@ == 'update' ]; then
		sudo pacman -Syu
	fi
	sudo reboot
}

clear

if $resize_clear; then
	trap clear WINCH
fi

trap cleanup EXIT
trap sighupHandle SIGHUP

alias ls='ls --color=auto'
alias la='ls -a'
alias l='ls -la'
alias grep='grep --color=auto'
alias please='sudo'
alias pls='sudo'
alias nuke='rm -rf'
alias ip='ip -c'

#\[\n──────┴───────┘\033[1F\]

#nuh uh
PS1='\A │ \[$GREEN\]\u\[$RES\] │ \w \$> '
PS2='> '
