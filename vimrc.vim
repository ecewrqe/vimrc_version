
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

" set enc=utf-8
set guifont=Powerline_Consolas:h11
"set renderoptions=type:directx,gamma:1.5,contrast:0.5,geom:1,renmode:5,taamode:1,level:0.5

" Plugin manager: vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'szw/vim-maximizer'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'kassio/neoterm'
Plug 'sbdchd/neoformat'

Plug 'ryanoasis/vim-devicons'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'tomasiser/vim-code-dark'

" github copilot
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'

Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chipsenkbeil/distant.nvim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'janko/vim-test'

call plug#end()

filetype on
syntax enable
filetype plugin indent on

set t_Co=256
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
nnoremap <Leader>S "_S
nnoremap <Leader>a ggVG
nnoremap yie ggVGy
nnoremap die ggVGd
nnoremap cie ggVGc
nnoremap <Leader>die ggVG"_d
" nnoremap <C-h> :bp<CR>
" nnoremap <C-l> :bn<CR>

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
"noremap <Leader>T :terminal<CR>
noremap <Leader>lsp :vsp<CR>
noremap <Leader>bsp :sp<CR>

" noremap <C-t>l :vsp<CR>:terminal<CR>
" tnoremap <C-t> exit<CR><CR>
" noremap <C-t>b :sp<CR>:terminal<CR>
nnoremap <C-k><C-k> :e $MYVIMRC<CR>

let g:netrw_banner=0
let g:markdown_fenced_language = ['javascript', 'js=javascript', 'json=javascript']


" gj gk gt gT gJ gI bp|bn
tnoremap <Esc> <C-\><C-n>

" commadn mode movement like emacs
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-A> <Home>
cnoremap <A-B> <S-Left>
cnoremap <A-F> <S-Right>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-D> <Del>

nnoremap <C-K><C-N> :set hlsearch!<CR>


" puremourning/vimspector
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = { 'node': 'vscode-node-debug2', 'python': 'vscode-python' }
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>
nnoremap <F9> :call vimspector#StepOut()<CR>
nnoremap <F10> :call vimspector#StepInto()<CR>
nnoremap <F8> :call vimspector#StepOver()<CR>
nnoremap <leader>d_ :call vimspector#Restart()<CR>
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dh :call vimspector#ToggleConditionalBreakpoint()<CR>

" VimspectorInstall --all --force-all

" szw/vim-maximizer
nnoremap <leader>m :MaximizerToggle!<CR>

" kassio/neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size = 60
let g:neoterm_autoinsert = 1
nnoremap <C-t> :Ttoggle<CR>
inoremap <C-t> <ESC>:Ttoggle<CR>
tnoremap <C-t> <c-\><c-n>:Ttoggle<CR>

" junegunn/fzf.vim
nnoremap <leader><space> :GFiles<CR>
nnoremap <leader>ff :Rg<CR>
inoremap <expr> <C-x><C-f> fzf#vim#complete#path(
            \ "find . -path '*/\.*' -prune -o -print \|sed '1d;s:^..::'",
            \ fzf#wrap({'dir': expand('#:p:h')}))

if has('nvim')
    au! TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
    au! FileType fzf tunmap <buffer> <Esc>
endif

" tpope/vim-fugitive
nnoremap <leader>gg :G<cr>

" autocmd VimEnter * NERDTree

nnoremap  <Leader>ee :lua CopilotChatBuffer()<CR>
nnoremap <Leader>cI :CopilotChat<CR>


" nerd Tree focus
nnoremap <Leader>t :NERDTreeToggle<CR>
let NERDTreeIgnore = ["package-lock.json", "node_modules", "\.exe$", "\.out$"]

" autocmd VimEnter * NERDTree | wincmd p

function s:nerdtree_load()
    if argc() == 0
        NERDTree
        wincmd p
    elseif argc() == 1 && isdirectory(argv()[0])
        execute 'NERDTree' argv()[0]
        wincmd p
        enew
        execute 'cd '.argv()[0]
    endif
endfunction

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * call s:nerdtree_load()



" janko/vim-test
nnoremap <silent> tt :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
nnoremap <silent> t_ :TestLast<CR>

let test#strategy = "neovim"
let test#neovim#term_position = "vertical"


" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <Leader>di <Plug>VimspectorBalloonEval
xmap <Leader>di <Plug>VimspectorBalloonEval


" colorscheme elflord
" set t_Co=256
" set t_ut=
" If you don't like many colors and prefer the conservative style of the standard Visual Studio
" let g:codedark_conservative=1
" If you like the new dark modern colors (Needs feedback!)
" let g:codedark_modern=1
" Activates italicized comments (make sure your terminal supports italics)
" let g:codedark_italics=1
" Make the background transparent
" let g:codedark_transparent=1
" If you have vim-airline, you can also enable the provided theme
let g:airline_powerline_fonts = 1
let g:airline_theme = 'codedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

highlight HighlightedyankRegion cterm=reverse gui=reverse

let g:lightline = {
            \ 'active': {
                \ 'left': [ ['mode', 'paste'],
                \ [ 'gitbranch', 'readonly', 'filename', 'modified'] ]
                    \ },
                \ 'component_function': {
                    \ 'gitbranch': 'gitbranch#name'
                    \ },
                    \ 'colorscheme': 'codedark',
                    \ }


