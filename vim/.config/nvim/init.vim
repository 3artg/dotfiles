set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set shell=/bin/bash
set showcmd
set cmdheight=2
set hidden
set nofixeol
set history=10000
set wildmenu
set wildmode=full
set mouse=a
if has("nvim-0.5.0") || has("patch-8.1.1564")
    set signcolumn=number
else
    set signcolumn=yes
endif
set cursorline
set nobackup
set nowritebackup
set noswapfile
set incsearch
set ignorecase
set smartcase
set autoread
set updatetime=300
set shortmess+=c

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
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode = 3
let g:NERDTreeUseTCD = 1
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'rakr/vim-one'
Plug 'ryanoasis/vim-devicons'
Plug 'felleg/TeTrIs.vim'
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
Plug 'yuttie/comfortable-motion.vim'
Plug 'lambdalisue/suda.vim'
let g:suda_smart_edit = 1
call plug#end()

cabbrev W write
cabbrev ㅈ write
cabbrev ㅂ quit
cabbrev ㅈㅂ wq
cabbrev ㅂㅁ qa

nnoremap <C-s>      :update<CR>
inoremap <C-s> <ESC>:update<CR>
vnoremap <C-S> <ESC>:update<CR>

nnoremap <F5>      :update<CR>:!xclip -selection clipboard -rmlastnl %<CR>:!solve %<CR>
inoremap <F5> <ESC>:update<CR>:!xclip -selection clipboard -rmlastnl %<CR>:!solve %<CR>
vnoremap <F5> <ESC>:update<CR>:!xclip -selection clipboard -rmlastnl %<CR>:!solve %<CR>

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

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

function! EditTC(name)
    silent execute "!touch" a:name . ".in" a:name . ".out" a:name . ".ans"
    execute "split" a:name . ".ans"
    execute "normal \<c-w>J"
    execute "vs" a:name . ".out"
    execute "vs" a:name . ".in"
endfunction

function! EditTCs(...)
    " if bufname() == ''
    "     e .
    " endif
    for s in a:000
        call EditTC(s)
    endfor
    execute "NERDTreeClose"
endfunction

function! ClearTC()
    silent execute "!rm *"
    execute ":only"
    execute ":e ."
    execute "NERDTreeRefreshRoot"
endfunction

command! -nargs=+ Et call EditTCs(<f-args>)
command! Ct call ClearTC()
cnoreabbrev et Et
cnoreabbrev ct Ct

autocmd BufNewFile,BufRead *     set modifiable
autocmd BufNewFile,BufRead *.out set nomodifiable
autocmd WinLeave *.in  update
autocmd WinLeave *.ans update
