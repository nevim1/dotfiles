#!/usr/bin/env bash

# go over all files in this repo
for i in $(ls -A); do
	# skip markdowns, git files and this script
	mi=$( echo $i | sed -r -e s/[^\(tmux\)]\.conf$// -e s/.*\.md// -e s/^\.git\(i.*$\|$\)// -e s/setup\.sh// )
	if [[ ! -z $mi ]] then
		# check if it already exists in home folder
		if [ -f ~/$mi ]; then
			echo $mi was found in your home dir.
			if read -p "Replace it? (y/N) " conf && [[ "$conf" =~ ^[yY]([eE][sS]?)?$ ]]; then
				mv ~/$mi ~/"$mi".old
				ln -s "$(dirname "$0")"/$mi ~/$mi
				echo the old version was moved to ~/"$mi".old
			fi
		else
			ln -s "$(dirname "$0")"/$mi ~/$mi
		fi
	fi
done

# if there isn't plug.vim make it
# if it wasn't there vim plugins would break
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# if there is setup script for bins then execute it
if [[ -x ./bin/setup.sh ]]; then
	./bin/setup.sh
fi
