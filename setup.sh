#!/usr/bin/env bash
dir=$(cd "$(dirname "$0")"; pwd)

# go over all files in this repo
# and skip all files in .lsingore
for i in $(ls -A "$dir" $(sed 's|^|--ignore=|' .lsignore) ); do
	if [[ ! -z $i ]]; then
		# check if it already exists in home folder
		if [ -f ~/"$i" ]; then
			#TODO: check if the symlik is pointing to this file
			if [ ! -L ~/"$i" ]; then
				echo $i was found in your home dir.
				if read -p "Replace it? (y/N) " conf && [[ "$conf" =~ ^[yY]([eE][sS]?)?$ ]]; then
					mv ~/"$i" ~/"$i".old
					ln -s "$dir"/"$i" ~/"$i"
					echo the old version was moved to ~/"$i".old
				fi
			fi
		else
			ln -s "$dir"/"$i" ~/"$i"
		fi
	fi
done

# if there isn't plug.vim make it
# if it wasn't there vim plugins would break
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# if there is setup script for bins then execute it
git submodule init
git submodule update
if [[ -x "$dir"/bin/setup.sh ]]; then
	"$dir"/bin/setup.sh
fi
