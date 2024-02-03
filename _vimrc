"euewrqe(無 水雷屯)
"source ~/.vimrc
" Vim with all enhancements
" customize

" Disable compatibility with vi which can cause unexpected issues
if !has('nvim')
    set nocompatible
endif
" Enable type file detection.
filetype on
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on
" Turn syntax highlighting on
syntax enable
" 1 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
" cursor on Mode Changing
let &t_SI = "\e[5 q" "SI = INSERT mode
let &t_SR = "\e[4 q" "SR = REPLACE mode
let &t_EI = "\e[1 q" "EI = NORMAL mode

set number
set encoding=UTF-8
" set fileencoding=utf-8
scriptencoding utf-8
set ffs=unix,dos,mac
set nocompatible

if has('linebreak')
    set textwidth=120
    set linebreak
    set breakindent
    set breakindentopt=shift:2

    let &showbreak = '↳ '
    set cpo+=n
endif

set joinspaces
set whichwrap+=<,>

set cmdheight=1
set laststatus=2


set incsearch
set hlsearch
set showcmd
set tabstop=4
set shiftwidth=4
" Use space characters instead of tabs
set expandtab
set cursorline
" set cursorcolumn

set history=1000
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

set signcolumn=auto " yes
set noerrorbells
set visualbell

if has('clipboard')
    if has('unnamedplus')
        set clipboard=unnamed,unnamedplus
    else
        set clipboard=unnamed
    endif
endif
set cindent
"set autowrite
"set bufhidden=hide
set belloff=
set mouse=a

set nobackup
set scrolloff=10
set wrap
set wrapscan
set numberwidth=4
" title
set title
set titlestring=" %F "

set ignorecase
set smartcase
set showmode
set showmatch
set showcmd

" set shell=/bin/bash
set splitright
set splitbelow

set wildmenu
set wildmode=list:longest,full
set wildignore+=.hg,.git,.svn,.vscode
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
set wildignore+=*.pyc,*.class
set list

set completeopt=longest,menu,menuone,noselect
set infercase


set colorcolumn=80
set shiftround

if has("gui_running")
    set background=dark
    colorscheme evening
    set guifont=Consolas:h20
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
    " menu bar
    set guioptions-=m
    set guioptions-=b
    set lines=75
    set columns=180
else
    colorscheme morning
endif

"map Q gq
nnoremap <c-a> ^
nnoremap <c-e> $


" PLUGINS --------------------------------
" plugin code goes here.
let mapleader="\<Space>"
" MAPPINGS ---------------
nnoremap <Leader>d "_d
nnoremap <Leader>D "_D
nnoremap <Leader>c "_c
nnoremap <Leader>C "_C
nnoremap <Leader>x "_x
nnoremap <Leader>s "_s
nnoremap <Leader>a ^
nnoremap <Leader>e $
nnoremap yie ggVGy
nnoremap die ggVGd
nnoremap <Leader>die ggVG"_d
nnoremap U u

" select all the buffer
nnoremap <Leader>n bi
nnoremap <Leader>m ea
nnoremap <Leader>N Bi
nnoremap <Leader>M Ea
noremap <Leader>T :terminal<CR>
noremap <Leader>lsp :vsp<CR>
noremap <Leader>bsp :sp<CR>

noremap <C-t>l :vsp<CR>:terminal<CR>i
tnoremap <C-t> exit<CR><CR>
noremap <C-t>b :sp<CR>:terminal<CR>i


noremap <C-Left> <C-w><
noremap <C-Right> <C-w>>
noremap <C-Up> <C-w>+
noremap <C-Down> <C-w>-

" delete without copy
vnoremap <Leader>d "_d
vnoremap <Leader>D "_D
vnoremap <Leader>c "_c
vnoremap <Leader>C "_C
vnoremap <Leader>x "_x
vnoremap <Leader>s "_s
vnoremap <Leader>a ^
vnoremap <Leader>e $
vnoremap ie <Esc>ggVG



noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

" gj gk gt gT gJ gI bp|bn

nnoremap <A-m> :bn<CR>  " buffer next
nnoremap <A-n> :bp<CR>  " buffer prev
nnoremap <A-d> :bd<CR>  " buffer delet
nnoremap <C-p> :tabonly<CR>
nnoremap <C-o> :only<CR>
nnoremap <C-n> :tabnew<CR>
" invrightleft
noremap <F9> :set invrl!<CR> " invrightleft
inoremap <F9> <Esc>:set invrl!<CR>a

nnoremap <Leader>rn :set relativenumber!<CR>

" Mappings code goes here.

" vim plugin-------------------------------

if has('nvim')
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.config/nvim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'machakann/vim-highlightedyank'
    call plug#end()
else
    " if empty(glob('~/.vim/autoload/plug.vim'))
    "     silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "     autocmd VimEnter PlugInstall --sync | source $MYVIMRC
    " endif
    " call plug#begin('~/.vim/plugged')
endif


" nmap y <Plug>(highlightedyank)
" xmap y <Plug>(highlightedyank)
" omap y <Plug>(highlightedyank)
" let g:highlightedyank_highlight_duration = 1000
highlight HighlightedyankRegion cterm=reverse gui=reverse

" STATUS LINE ------------:----------------

