# ~/.bash_profile

# {{{ EXPORTS
export PATH="$PATH:/home/nevim/.cargo/bin"
export PATH="$PATH:/home/nevim/Documents/KSP/ksp-klient"
export PATH="$PATH:/home/nevim/Documents/machineWaking"
export PATH="$PATH:/home/nevim/.dotnet/tools"
export PATH="$PATH:/home/nevim/.local/bin"
# }}}

if [ -z "$DISPLAY" ] &&  [ "$XDG_VTNR" -eq 2 ]; then
	source .xprofile
	exec startx /usr/bin/awesome
fi


[[ -f ~/.bashrc ]] && . ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
