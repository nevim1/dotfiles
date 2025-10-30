# # ~/.bashrc
#TODO: make separte file for things that differ between machines

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#define some constants
MACHINE=$(hostname)

GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
BOLD="$(tput bold)"
NC="$(tput sgr0)"

first=true

entry="${GREEN}${MACHINE}${NC} welcomes you ${GREEN}${USER}${NC}!"
entryPatch="${MACHINE} welcomes you ${USER}!"


export PATH="$PATH:/home/nevim/.cargo/bin"
export PATH="$PATH:/home/nevim/Documents/KSP/ksp-klient"
export XDG_DATA_HOME="/home/nevim/.XDG_DATA"
export PYTHONPATH="/usr/lib/python3.13/site-packages/"



# {{{ VOLUNTARY CLEAR
#make clearing method
clear(){
	command clear

	date="$(date)"

	width=$(tput cols)

	if $first;then
		tput hpa $(((width / 2)-(${#entryPatch} / 2)))
			echo $entry
			first=false
	fi

	tput hpa $(((width / 2)-(${#date} / 2)))
		echo $date
	}

#bind it to <ctrl> + l
bind -x '"\C-l":clear'
bind -x '"\e\C-l":clear'
# }}}

# {{{ CLEANUP AFTER DEATH
# make method for NOT making zombies
cleanup(){
	if [[ ! -z "$KILL_VIM_SSH" || ( -z "$VIM" && ! -z "$SSH_AGENT_PID" ) ]];then
		kill $SSH_AGENT_PID || echo no killing happend
		unset SSH_AGENT_PID
		echo ssh agent killed
	else
		echo ssh wasnt started in vim or isnt running altogether
	fi

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


#make it that i wouldn't have zombies
trap 'cleanup 1' EXIT
trap sighupHandle SIGHUP
# }}}

# {{{ GIT
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

# support fo git-prompt
. ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# }}}

# {{{ TMUX
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
# }}}

clear

# {{{ RANGER SETUP
bind -x '"\C-o": ranger-select files ""'
bind -x '"\eo": ranger-select dir "/"'

function ranger-select {
	local F=$(mktemp)
	ranger --choose$1=$F
	if [ -s $F ] ; then
		local SEL="$(<$F sed '/[^0-9A-Za-z._/-]/{s/^/"/; s/$/"/;}' | tr '\n' ' ')"
		if [ "${SEL:${#SEL}-1}" != " " ] ; then
			SEL="$SEL$2 "
		fi
		READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$SEL${READLINE_LINE:$READLINE_POINT}"
		READLINE_POINT=$(($READLINE_POINT + ${#SEL}))
	fi
	rm -f $F
}

# }}}

# some things for pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# {{{ ALIASES
#somewhy doesn't work for multiword dir names
#TODO fix that
cl(){
	cd $@
	ls --color=auto
}

source(){
	if [[ $# == 0 ]]; then
		command source ~/.bashrc
	else
		command source "$@"
	fi
}

alias ls='ls --color=auto'
alias la='ls -a'
alias l='ls -la'
alias grep='grep --color=auto'
alias please='sudo'
alias pls='sudo'
alias nuke='rm -rf'
alias ip='ip -c'
alias vim='vim -p'
alias clr='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# }}}

#next line is for closing (I probablly won't use it)
#\[\n──────┴───────┘\033[1F\]

#TODO: add shorhand dir if pwd longer than half of screen
PS1='\A │ \[$GREEN\]\u\[$NC\] │ \w$(__git_ps1 " │ (%s)") $(ECODE=$?; if [ $ECODE != 0 ]; then echo "│ $RED$BOLD[$ECODE]$NC ";fi)\$> '
PS2='> '
