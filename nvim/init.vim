"euewrqe(無 水雷屯)
"source ~/.vimrc
" Vim with all enhancements
" customize

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
source ~/.config/nvim/blueprint/colorscheme.vim

set number
source ~/.config/nvim/blueprint/keybind.vim
source ~/.config/nvim/blueprint/options.vim




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
    Plug 'preservim/nerdtree'
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


" STATUS LINE ------------:----------------

