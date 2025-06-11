#
# ~/.bashrc
# smth for starting WSL in windows Xserver
#export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
#export LIBGL_ALWAYS_INDIRECT=1

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#define some constants
MACHINE=$(hostname)

GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
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
	if [[ ! -z "$KILL_VIM_SSH" || ( -z "$VIM" && ! -z "$SSH_AGENT_PID" ) ]];then
		kill $SSH_AGENT_PID || echo no killing happend
		unset SSH_AGENT_PID
		echo ssh agent killed
	else
		echo ssh wasnt started in vim or isnt running altogether
	fi

	if [ ! -z $RAM_WATCH_PID ]; then
		kill $RAM_WATCH_PID
		echo ram watch killed
	fi
	unset RAM_WATCH_PID

	kill_tmux && echo tmux killed

	sleep $1
}

#handle when the window of this shell is closed
sighupHandle(){
	cleanup 0
	exit
}

#when I am using vim too much
:q(){
	cleanup 1
	exit
}

#starting SSH agent
startSSH(){
	if [ -z "$SSH_AGENT_PID" ]; then
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/nevim-linux-lenovo-ssh-key
		if [ ! -z "$VIM" ];then
			echo ssh started in vim
			KILL_VIM_SSH=True
			sleep 0.5
		fi
	fi
}

#autostart SSH agent when trying to access git remote
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

#In case of emergency type 'forkbomb'
forkbomb(){
	forkbomb | forkbomb &
}

#somewhy doesn't work for multiword dir names
#TODO fix that
cl(){
	cd $@
	ls --color=auto
}


################
#TMUX
################
export RUN_TMUX=true
export TMUX_BIN=/usr/bin/tmux

# running new tmux (or attaching) with session name derived from parent bash pid
runTmux() {

	SESSION_NAME="T$BASHPID"
	
	# try to find session with the correct session id (based on the bashs PID)
	# bugfix: added parenthesis around thing that gives value
	EXISTING_SESSION=$($TMUX_BIN ls 2> /dev/null | grep "$SESSION_NAME" | wc -l)

	if [[ "$EXISTING_SESSION" -gt "0" ]]; then
	
		# if such session exists, attach to it
		$TMUX_BIN -2 attach-session -t "$SESSION_NAME"
	
	else
		# if such session does not exist, create it
		$TMUX_BIN new-session -s "$SESSION_NAME"
	
	fi

	# hook after exitting the session
	# when the session exists, find a file in /tmp with the name of the session
	# and extract a path from it. Then cd to it.
	FILENAME="/tmp/tmux_restore_path.txt"
	if [ -f $FILENAME ]; then

		MY_PATH=$(tail -n 1 $FILENAME)

		rm /tmp/tmux_restore_path.txt

		cd $MY_PATH

	fi
}

kill_tmux() { $TMUX_BIN kill-session -t "T$BASHPID";}


# if opening new tmux window so it won't try to start new tmux session inside tmux
# basicly don't nest tmux
[[ $TERM != "screen" && -z $VIM && $RUN_TMUX && -z $TMUX ]] && TERM=xterm-256color && runTmux

sleep 0.5
clear

if $resize_clear; then
	trap clear WINCH
fi

#here just because I tried wsl on windows (fuck windows)
bind 'set bell-style none'

#make it that i wouldn't have zombies
trap 'cleanup 1' EXIT
trap sighupHandle SIGHUP

# some things for pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

#some aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias l='ls -la'
alias grep='grep --color=auto'
alias please='sudo'
alias pls='sudo'
alias nuke='rm -rf'
alias ip='ip -c'
alias vim='TMUX= vim'		#TODO: move insides of TMUX to different variable
alias clr='clear'

#next line is for closing (I probablly won't use it)
#\[\n──────┴───────┘\033[1F\]

#TODO: add git status and program exit codes
#TODO: add shorhand dir if pwd longer than half of screen
PS1='\A │ \[$GREEN\]\u\[$RES\] │ \w \$> '
PS2='> '
