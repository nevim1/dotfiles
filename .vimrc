set nocompatible
" PLUGINS
let g:OmniSharp_server_use_net6=1

filetype plugin on

call plug#begin('~/.vim/plugged')

	Plug 'rakr/vim-one'
	Plug 'Valloric/YouCompleteMe'
	Plug 'OmniSharp/omnisharp-vim'
	Plug 'simeji/winresizer'
	Plug 'habamax/vim-godot'
	Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()

" VISUAL STUFF 

"for NOT breaking colors
if (empty($TMUX))			 "tmux evidently has some issues with my colors (maybe)
	if (has("termguicolors"))
		set termguicolors
	endif
endif

colorscheme one

set background=dark

"set t_8b=[48;2;%lu;%lu;%lum
"set t_8f=[38;2;%lu;%lu;%lum

syntax on

set tabstop=2 shiftwidth=2 smarttab
set noexpandtab
set nowrap
set numberwidth=4
set number relativenumber
set title
set cursorline
set incsearch hlsearch
set novisualbell noerrorbells
set list
set listchars=tab:¿_,trail:¿,extends:\#,nbsp:.,precedes:\#
",tab:|¿,trail:¿,nbsp:

" NON-VISUAL STUFF
set splitright splitbelow
set clipboard=unnamedplus
set autoindent copyindent
set hidden
set mouse=a
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class,*.docx,*.jpg,*.png,*.gif,*.pdf,*.exe,*.flv,*.img,*.xlsx
set ignorecase smartcase
set showmatch
set encoding=utf-8



" AUTOCMDs
fun! OpenVertTerm()
	if &ft =~ 'gitcommit'
		setl spell
	elseif &ft =~ 'python'
		vertical terminal
		wincmd p
	endif
endfun

autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\"|normal! G
autocmd VimEnter * call OpenVertTerm()
autocmd BufReadPost * if &readonly | set noexpandtab|retab!|w | endif
"TODO: autoclose all terminal windows after :qa
