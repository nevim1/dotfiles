# ~/.bash_profile

#&& [ "$XDG_VTNR" -eq 1 ]
if [ -z "$DISPLAY" ]; then
#	export GTK_THEME=Adwaita:dark
#	export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
#	export QT_STYLE_OVERRIDE=Adwaita-Dark
#	udiksie -t &
	exec startx /usr/bin/awesome
fi


[[ -f ~/.bashrc ]] && . ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
