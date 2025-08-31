"euewrqe(辟｡ 豌ｴ髮ｷ螻ｯ)
"source ~/.vimrc
" Vim with all enhancements
" customize
" language en_US
" Disable compatibility with vi which can cause unexpected issues
if !has('nvim')
    set nocompatible
endif
" Enable type file detection.
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

colorscheme elflord

highlight HighlightedyankRegion cterm=reverse gui=reverse

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
" 
set linebreak
set breakindent
syntax case match

set list
set listchars+=eol:¬
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
" 
" set completeopt=longest,menu,menuone,noselect
" set infercase
" 
" 
" set colorcolumn=80
" set shiftround
" 

" PLUGINS --------------------------------
" plugin code goes here.
let mapleader="\<Space>"
" MAPPINGS ---------------
nnoremap <Leader>d "_d
nnoremap <Leader>D "_D
nnoremap <Leader>c "_c
nnoremap <Leader>C "_C
nnoremap <Leader>x "_x
nnoremap <Leader>s "_s nnoremap <Leader>S "_S
nnoremap <Leader>a ggVG
nnoremap yie ggVGy
nnoremap die ggVGd
nnoremap <Leader>die ggVG"_d



vnoremap <Leader>d "_d
vnoremap <Leader>D "_D
vnoremap <Leader>c "_c
vnoremap <Leader>C "_C
vnoremap <Leader>x "_x
vnoremap <Leader>s "_s
vnoremap <Leader>S "_S
vnoremap <Leader>a ggVG

" select all the buffer
nnoremap <Leader>n bi
nnoremap <Leader>m ea
nnoremap <Leader>N Bi
nnoremap <Leader>M Ea
noremap <Leader>T :terminal<CR>
noremap <Leader>lsp :vsp<CR>
noremap <Leader>bsp :sp<CR>

noremap <C-t>l :vsp<CR>:terminal<CR>
tnoremap <C-t> exit<CR><CR>
noremap <C-t>b :sp<CR>:terminal<CR>


noremap <C-Left> <C-w><
noremap <C-Right> <C-w>>
noremap <C-Up> <C-w>+
noremap <C-Down> <C-w>-



noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

" gj gk gt gT gJ gI bp|bn
tnoremap <Esc> <C-¥><C-n>

" commadn mode movement like emacs
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-A> <Home>
cnoremap <A-B> <S-Left>
cnoremap <A-F> <S-Right>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-D> <Del>

nnoremap <C-K><C-,> :e $MYVIMRC<CR>
nnoremap <C-K><C-N> :set hlsearch!<CR>


" invrightleft
 
 
 
 if has("win32")
     exec "source "..stdpath('config').."¥¥blueprint¥¥colorscheme.vim"
     exec "source "..stdpath('config').."¥¥blueprint¥¥keybind.vim"
     exec "source "..stdpath('config').."¥¥blueprint¥¥options.vim"
 
     " source $USERPROFILE¥AppData¥Local¥nvim¥blueprint¥colorscheme.vim
     " source $USERPROFILE¥AppData¥Local¥nvim¥blueprint¥keybind.vim
     " source $USERPROFILE¥AppData¥Local¥nvim¥blueprint¥options.vim
 else
     if has("nvim")
         source ~/.config/nvim/blueprint/colorscheme.vim
         source ~/.config/nvim/blueprint/keybind.vim
         source ~/.config/nvim/blueprint/options.vim
         source ~/.config/nvim/blueprint/lsp_config.vim
     endif
 endif

" let lsp_log_verbose=1
" let lsp_log_file = expand('~/lsp.log')
" let g:lsp_settings_filetype_vue = ['volar-server', 'typescript-language-server', 'vtsls', 'eslint-language-server', 'html-languageserver']
" 
" let g:lsp_settings_filetype_html = ['html-languageserver']

" terminal

if has("win32")
    let &shell = 'powershell'
    let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'

    let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

" Mappings code goes here.

" vim plugin-------------------------------

if has('nvim')
    if has('win32')
        if empty(glob('~/AppData/Local/nvim/autoload/plug.vim'))
            silent !New-Item -Path ~/AppData/Local/nvim/autoload/ -ItemType Directory
            silent !Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' -OutFile '~/AppData/Local/nvim/autoload/plug.vim'

            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
        call plug#begin('~/.vim/plugged')
    else
        if empty(glob('~/.config/nvim/autoload/plug.vim'))
            silent !mkdir -p ~/.config/nvim/autoload/
            silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
        call plug#begin('~/.config/nvim/plugged')
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !mkdir -p ~/.vim/autoload/
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.vim/plugged')
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'

call plug#end()


" nerd Tree focus
nnoremap <Leader>n :NERDTreeFocus<CR>
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>

" autocmd VimEnter * NERDTree


" STATUS LINE ------------:----------------
"


" go debug
" perl debug
function! s:Exe_perl()
    let file_name = @%
    let _exe_command = '!perl '.file_name
    exec _exe_command
endfunction
nnoremap <F5> :call Exe_perl()<CR>


