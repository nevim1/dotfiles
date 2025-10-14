PWD=$(pwd)
for i in $(ls -A); do 
	mi=$( echo $i | sed -r -e s/[^\(tmux\)]\.conf$// -e s/.*\.md// -e s/^\.git\(i.*$\|$\)// -e s/setup\.sh// )
	if [[ ! -z $mi ]] then
		if [ -f ~/$mi ]; then
			echo $mi was found in your home dir.
			if read -p "Replace it? (y/N) " conf && [[ $conf == [yY] || $conf == [yY][eE][sS] ]]; then
				mv ~/$mi "$PWD"/"$mi".old
				ln -s "$PWD"/$mi ~/$mi
				echo the old version was moved to "$PWD"/"$mi".old
			fi
		else
			ln -s "$PWD"/$mi ~/$mi
		fi
	fi	
done

if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
