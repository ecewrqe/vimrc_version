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

let lsp_log_verbose=1
let lsp_log_file = expand('~/lsp.log')
let g:lsp_settings_filetype_vue = ['volar-server', 'typescript-language-server', 'vtsls', 'eslint-language-server', 'html-languageserver']

let g:lsp_settings_filetype_html = ['html-languageserver']



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

    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    Plug 'ycm-core/youcompleteme'

    call plug#end()
else
    " if empty(glob('~/.vim/autoload/plug.vim'))
    "     silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "     autocmd VimEnter PlugInstall --sync | source $MYVIMRC
    " endif
    " call plug#begin('~/.vim/plugged')
endif

let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'

" nmap y <Plug>(highlightedyank)
" xmap y <Plug>(highlightedyank)
" omap y <Plug>(highlightedyank)
" let g:highlightedyank_highlight_duration = 1000
function! s:on_lsp_buffer_enabled() abort
    if &buftype ==# 'nofile' || &filetype =~# '^\(quickrun\)' || getcmdwintype() ==# ':'
        return
    endif
    setlocal omnifunc=lsp#complete

    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <f2> <plug>(lsp-rename)
    nmap <buffer> <c-k> <plug>(lsp-hover)
endfunction

augroup vimcr_lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END



" STATUS LINE ------------:----------------

