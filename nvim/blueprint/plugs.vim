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

Plug 'szw/vim-maximizer'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'kassio/neoterm'
Plug 'sbdchd/neoformat'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'ycm-core/youcompleteme'
Plug 'puremourning/vimspector'
Plug 'github/copilot.vim'

Plug 'tomasiser/vim-code-dark'
Plug 'pangloss/vim-javascript'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'nvim-lua/completion-nvim'

call plug#end()


source ~/.config/nvim/blueprint/neoformat_config.vim

