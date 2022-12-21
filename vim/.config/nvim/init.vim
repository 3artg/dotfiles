""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
set encoding=utf-8
set fileencodings=utf-8,euc-kr
set shell=/bin/bash
set showcmd
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
set updatetime=100
set shortmess+=c
set textwidth=80
set formatoptions-=t
set colorcolumn=+1,+2,+3
set scrolloff=3
set nowrap
set signcolumn=yes
set list

if has('persistent_undo')
    set undofile
endif

if has("syntax")
    syntax on
endif

set autoindent
set cindent

set number relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

autocmd FileType html,css,javascript,scss setlocal ts=2 sw=2 sts=0 et


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

let mapleader=" "
call plug#begin('~/.vim/plugged')
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
" Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode = 3
let g:NERDTreeUseTCD = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinPos = "right"
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:polyglot_disabled = ['sensible']
Plug 'sheerun/vim-polyglot'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
Plug 'yuttie/comfortable-motion.vim'
Plug 'lambdalisue/suda.vim'
let g:suda_smart_edit = 1
Plug 'mhinz/vim-startify'
let g:startify_bookmarks = [
    \ {'a': '~/workspace/algo'},
    \ {'b': '~/.bashrc'},
    \ {'d': '~/.dotfiles'},
    \ {'g': '~/.gitconfig'},
    \ {'i': '~/.config/nvim/init.vim'},
    \ {'s': '~/.ssh/config'},
    \ {'t': '~/.tmux.conf'},
    \ {'z': '~/.zshrc'}
    \ ]
let g:startify_custom_header ='startify#center(startify#fortune#cowsay())'
if has('nvim')
    autocmd TabNewEntered * redir => t | silent history -1 | redir END
        \ | if bufname() == '' && t !~ 'checkhealth' | Startify | endif
else
    autocmd BufWinEnter *
        \ if !exists('t:startify_new_tab')
        \     && empty(expand('%'))
        \     && empty(&l:buftype)
        \     && &l:modifiable |
        \   let t:startify_new_tab = 1 |
        \   Startify |
        \ endif
endif
autocmd User Startified nmap <buffer> . :e .<CR>
Plug 'aymericbeaumet/vim-symlink'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/dsf.vim'
Plug 'rhysd/clever-f.vim'
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
Plug 'easymotion/vim-easymotion'
map <leader> <Plug>(easymotion-prefix) " test. it should be chagned but i have no good idea.
Plug 'farmergreg/vim-lastplace'
Plug 'gcmt/taboo.vim'
Plug 'vim-scripts/LargeFile'
Plug 'alvan/vim-closetag'
let g:clsoetag_filenames = '*.html,*.xhtml,*.phtml,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'
Plug 'nathanaelkane/vim-indent-guides'
nmap <leader>i <Plug>IndentGuidesToggle
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_default_mapping = 0
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'startify']
Plug 'styled-components/vim-styled-components'
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :Files<CR>
nnoremap <Leader>ag :Ag<CR>
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
colorscheme gruvbox


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cabbrev W write
cabbrev Wq wq
cabbrev Qa qa
cabbrev ㅈ write
cabbrev ㅂ quit
cabbrev ㅈㅂ wq
cabbrev ㅂㅁ qa

inoremap jk <ESC>

nnoremap <C-s>      :update<CR>
inoremap <C-s> <ESC>:update<CR>
vnoremap <C-S> <ESC>:update<CR>

inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
" nnoremap <C-a> ^
nnoremap <C-e> $
vnoremap <C-a> ^
vnoremap <C-e> $

nnoremap <F5>      :update<CR>:!cat % \| sed '/^\s*$/d' \| xclip -selection clipboard -rmlastnl<CR>:!solve run %<CR>
inoremap <F5> <ESC>:update<CR>:!cat % \| sed '/^\s*$/d' \| xclip -selection clipboard -rmlastnl<CR>:!solve run %<CR>
vnoremap <F5> <ESC>:update<CR>:!cat % \| sed '/^\s*$/d' \| xclip -selection clipboard -rmlastnl<CR>:!solve run %<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-q> <C-w>q

nnoremap <silent> <a--> :split<CR>
nnoremap <silent> <a-\> :vertical split<CR>
nnoremap <silent> <a-h> :vertical resize -5<CR>
nnoremap <silent> <a-j> :resize -3<CR>
nnoremap <silent> <a-k> :resize +3<CR>
nnoremap <silent> <a-l> :vertical resize +5<CR>
nnoremap <a-t> :tabnew<CR>
nnoremap <a-T> :-tabnew<CR>
nnoremap <a-1> 1gt
nnoremap <a-2> 2gt
nnoremap <a-3> 3gt
nnoremap <a-4> 4gt
nnoremap <a-5> 5gt
nnoremap <a-6> 6gt
nnoremap <a-7> 7gt
nnoremap <a-8> 8gt
nnoremap <a-9> 9gt-

inoremap <S-Tab> <C-d>
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap <silent> <expr> <leader><leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"
nmap <leader>c<space> <Plug>NERDCommenterToggle
vmap <leader>c<space> <Plug>NERDCommenterToggle

nnoremap <leader>sn :set nu!<CR>
nnoremap <leader>srn :set rnu!<CR>

" <C-_> is <C-/>
nmap <C-_> <Plug>NERDCommenterToggle
imap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

nnoremap <expr> <C-g> "<ESC>" . (v:count+2)%3 . "<C-g>"
nnoremap ; :
nnoremap <silent> <ESC><ESC> <ESC>:nohlsearch<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <leader>rn <Plug>(coc-rename)
inoremap <C-k> <C-p>
inoremap <C-j> <C-n>

if has('nvim') " trigger completion? (vscode's trigger suggest)
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@>coc#refresh()
endif

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'

nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! EditTC(name)
    silent execute "!touch" a:name . ".in" a:name . ".out" a:name . ".ans"
    execute "split" a:name . ".ans"
    execute "normal \<c-w>J"
    execute "vs" a:name . ".out"
    execute "vs" a:name . ".in"
endfunction

function! EditTCs(...)
    if !exists("t:is_tctab")
        let l:pname = substitute(bufname(), '\v(_|\.).*', '', '')
        let l:path = './testcase/' . l:pname
        if !isdirectory(l:path)
            execute '!mkdir -p ' . l:path
        endif
        execute "tabe " . l:path
        execute ":tcd " . l:path
        execute "TabooRename " . "TC:" . l:pname
        let t:is_tctab = 1
    endif
    let l:names = a:000
    if a:0 == 0
        let l:names = []
        for name in split(globpath('.', '*.in'), '\n')
            let l:names += [name[2:-4]]
        endfor
    endif
    for s in l:names
        call EditTC(s)
    endfor
    if bufname() !~# 'NERD_tree'
        execute "NERDTreeClose"
    endif
endfunction

function! ClearTC()
    silent execute "!rm *"
    execute ":only"
    execute ":e ."
    execute "NERDTreeRefreshRoot"
endfunction

function! CloseTC()
    windo bd
endfunction

function! DeleteTC()
    echo pass
endfunction

command! -nargs=* Et call EditTCs(<f-args>)
command! Ct call CloseTC()
cnoreabbrev et Et
cnoreabbrev ct Ct

autocmd BufNewFile,BufRead *     set modifiable
autocmd BufNewFile,BufRead *.out set nomodifiable
autocmd WinLeave *.in  update
autocmd WinLeave *.ans update
