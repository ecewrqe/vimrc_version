"euewrqe(無 水雷屯)
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

if has("win32")
    exec "source "..stdpath('config').."\\blueprint\\colorscheme.vim"
    exec "source "..stdpath('config').."\\blueprint\\keybind.vim"
    exec "source "..stdpath('config').."\\blueprint\\options.vim"

    " source $USERPROFILE\AppData\Local\nvim\blueprint\colorscheme.vim
    " source $USERPROFILE\AppData\Local\nvim\blueprint\keybind.vim
    " source $USERPROFILE\AppData\Local\nvim\blueprint\options.vim
else
    source ~/.config/nvim/blueprint/colorscheme.vim
    source ~/.config/nvim/blueprint/keybind.vim
    source ~/.config/nvim/blueprint/options.vim
    source ~/.config/nvim/blueprint/lsp_config.vim
endif

let lsp_log_verbose=1
let lsp_log_file = expand('~/lsp.log')
let g:lsp_settings_filetype_vue = ['volar-server', 'typescript-language-server', 'vtsls', 'eslint-language-server', 'html-languageserver']

let g:lsp_settings_filetype_html = ['html-languageserver']

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
            silent !New-Item -Path ~/AppData/Local/nvim/autoload -ItemType Directory
            silent !Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' -OutFile '~/AppData/Local/nvim/autoload/plug.vim'

            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
        call plug#begin('~/.vim/plugged')
    else
        if empty(glob('~/.config/nvim/autoload/plug.vim'))
            silent !mkdir -p ~/.config/nvim/autoload
            silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
        call plug#begin('~/.config/nvim/plugged')
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !mkdir -p ~/.vim/autoload
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.vim/plugged')
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'ycm-core/youcompleteme'
Plug 'puremourning/vimspector'

call plug#end()

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


" go debug

" nerd Tree focus
nnoremap <Leader>n :NERDTreeFocus<CR>
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>
" STATUS LINE ------------:----------------

let g:vimspector_enable_mappings = 'HUMAN'
nmap <Leader>di <Plug>VimspectorBalloonEval
xmap <Leader>di <Plug>VimspectorBalloonEval
