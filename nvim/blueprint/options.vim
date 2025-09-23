filetype on
syntax enable
filetype plugin indent on

set number
set modifiable
set encoding=UTF-8
set fileencoding=utf-8
set fileencodings=UTF-8,SJIS
scriptencoding utf-8
set showtabline=1
set mouse= 
set fileformat=unix
set fileformats=unix,dos,mac
set completeopt=menuone,noinsert,noselect

" set backupdir=./.vimbackup/

set bufhidden
set linebreak
set breakindent
syntax case match

set nocompatible

if has('clipboard')
    if has('unnamedplus')
        set clipboard=unnamed,unnamedplus
    else
        set clipboard=unnamed
    endif
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

if (has("termguicolors"))
    set termguicolors
endif
set nobackup
set nowritebackup
" set scrolloff=10
set wrap
set wrapscan
set numberwidth=4
" title
set title
set titlestring=" %F "

" set guifont=Consolas:h18

set ignorecase
set smartcase
set showmode
set showmatch

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


" autocmd BufWritePre *.log let &bex='-'..strftime("%Y%m%d")

" set fillchars=stl:^,stlnc:=,vert:│,fold:·,diff:-

