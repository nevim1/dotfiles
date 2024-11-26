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

call plug#end()

colorscheme one

set background=dark

if (empty($TMUX))
	if (has("termguicolors"))
		set termguicolors
	endif
endif

filetype plugin on
