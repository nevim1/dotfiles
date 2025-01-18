set nocompatible

syntax on
set mouse=a
set tabstop=2 shiftwidth=2 smarttab
set nowrap
set hidden
set autoindent copyindent
set showmatch
set ignorecase smartcase
set incsearch hlsearch

set number relativenumber

set numberwidth=4

set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set novisualbell noerrorbells

set clipboard=unnamedplus

set splitright
set splitbelow


let g:OmniSharp_server_use_net6=1

call plug#begin('~/.vim/plugged')

	Plug 'rakr/vim-one'
	Plug 'jaredgorski/SpaceCamp'
	Plug 'Valloric/YouCompleteMe'
	Plug 'OmniSharp/omnisharp-vim'
	Plug 'simeji/winresizer'

call plug#end()

colorscheme one

set background=dark

if (empty($TMUX))
	if (has("termguicolors"))
		set termguicolors
	endif
endif

filetype plugin on

autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\"|normal! G
"autocmd VimEnter * vertical terminal
"autocmd VimEnter * wincmd p
autocmd VimLeavePre * if &buftype == 'terminal' | call nvim_input('<C-d>') | endif
autocmd BufNewFile,BufRead COMMIT_EDITMSG,MERGE_MSG,*.git/* let g:skip_terminal = 1
autocmd VimEnter * if !exists('g:skip_terminal') || g:skip_terminal == 0 | terminal | wincmd p | endif
autocmd BufLeave * let g:skip_terminal = 0
