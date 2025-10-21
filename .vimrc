set nocompatible
" so it wouldn't fuck up anything else
set encoding=utf-8
set fileencoding=utf-8

let g:python_recommended_style=0
let g:markdown_recommended_style=0

" {{{ PLUGINS
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
	Plug 'tpope/vim-obsession'
	Plug 'stevearc/vim-arduino'
	Plug 'sputnick1124/uiua.vim'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
" }}}

" {{{ VISUAL STUFF

"for NOT breaking colors
if (has("termguicolors"))
	set termguicolors
endif

colorscheme one

set background=dark

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
set listchars=tab:│_,trail:•,extends:\#,nbsp:.,precedes:\#
set showbreak=↪\ 
",tab:|↦,trail:␠,nbsp:
" }}}

" {{{ NON-VISUAL STUFF
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
set foldmethod=marker
set spelllang=en_us,cs
" }}}

" {{{ KEYBINDS/REBINDS
" tab navigation
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>
nnoremap <C-t> :tabnew<CR>
execute "set <M-t>=\033t"
nnoremap <M-t> :tabclose<CR>

" line from Martin Škarytka
com Undokundo undo
" }}}

" {{{ AUTOCMDs
"TODO: autoclose all terminal windows after :qa not :qa!

" this is for setting and making filetype specific things
fun! SetSpecific()
	if &ft =~ 'gitcommit'
		setl spell
	elseif &ft =~ 'python'
		if winwidth(0) > (winheight(0)*2.5)
			vertical terminal
		else
			terminal
		endif
		wincmd p
	endif
endfun

aug FTSpecific
	autocmd!
	autocmd VimEnter * call SetSpecific()
aug END

aug AutoWriteFile
	autocmd!
	autocmd BufReadPost,BufNewFile *.py if !(getline(1) =~ '#!\/usr\/bin\/env python3') | 0put = '#!/usr/bin/env python3' | endif			" if there ins't hashbang at the begining of the code make it there
	autocmd BufReadPost,BufNewFile *.scad if !(getline(1) =~ '\$fn\s*=\s*\$preview\s*?\s*\d\+\s:\s*\d\+;') | 0put = '$fn = $preview ? 36 : 72;' | endif			" same but with number of fragments
	autocmd BufReadPost,BufNewFile *.scad if !(getline(2) =~ 'nothing\s*=\s*\d*\.\d\+;') | 1put = 'nothing=0.01;' | endif			" same but for adding miniscule amounts
	autocmd BufReadPost * if !&readonly | setl noexpandtab | retab! 2 | endif
aug END

" Set linebreak wrap for plaintext files
augroup FileTypeWrap
	autocmd!
	autocmd FileType plaintex,tex,markdown,html setl wrap linebreak spell breakindent
augroup END
" }}}

" {{{ LSP SETUP
let LSPDir='/home/nevim/builds/lsp-examples/vimrc.generated'
if !empty(glob('/home/nevim/builds/lsp-examples/vimrc.generated'))
	source /home/nevim/builds/lsp-examples/vimrc.generated
endif
" }}}
