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
	Plug 'vuciv/golf'

call plug#end()


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
scriptencoding utf-8


" VISUAL STUFF

" for NOT breaking colors
if (empty($TMUX))			 "tmux evidently has some issues with my colors
	if (has("termguicolors"))
		set termguicolors
	endif
endif

colorscheme one

set background=dark

syntax on

set tabstop=2 shiftwidth=2 smarttab
set nowrap
set numberwidth=4
set number relativenumber
set title
set cursorline
set incsearch hlsearch
set novisualbell noerrorbells
set list
set listchars=tab:│_,trail:•,extends:\#,nbsp:.,precedes:\#
" set noexpandtab

" AUTOCMDs
"TODO: autoclose all terminal windows after :qa

" this is for setting and making filetype specific things
fun! SetSpecific()
	if &ft =~ 'gitcommit'
		setl spell
		set insertmode
	elseif &ft =~ 'python'
		vertical terminal
		wincmd p
	endif
endfun

aug FTSpecific
	autocmd!
	autocmd VimEnter * call SetSpecific()
aug END

aug AutoWriteFile
	autocmd!
	autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\"|normal! G
	autocmd BufReadPost * if &readonly | retab! 2 | w | endif
aug END

" Set linebreak wrap for tex files
augroup FileTypeWrap
  autocmd!
  autocmd FileType plaintex,tex,markdown setlocal wrap linebreak
augroup END

com Undokundo undo
