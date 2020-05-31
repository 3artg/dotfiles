set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set shell=/bin/bash
set showcmd
set hidden
set nofixeol
set history=10000
set wildmenu
set wildmode=full
set mouse=a
set signcolumn=yes
set cursorline
set nobackup
set nowritebackup
set noswapfile
set incsearch
set ignorecase
set smartcase

" Plugin
if has('nvim')
    let autoload_path = '~/.local/share/nvim/site/autoload/plug.vim'
else
    let autoload_path = '~/.vim/autoload/plug.vim'
endif

if empty(glob(autoload_path))
    execute '!curl -fLo ' . autoload_path . ' --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync
endif

let mapleader=","
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'felleg/TeTrIs.vim'
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
Plug 'yuttie/comfortable-motion.vim'
call plug#end()

cabbrev W write
cabbrev ㅈ write
cabbrev ㅂ quit
cabbrev ㅈㅂ wq
cabbrev ㅂㅁ qa

set background=dark
colorscheme dracula

if has("syntax")
    syntax on
endif

set autoindent
set cindent

set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab