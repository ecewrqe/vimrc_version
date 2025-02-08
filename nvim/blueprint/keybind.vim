
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

nnoremap <C-K><C-,> :e $MYVIMRC<CR>
nnoremap <C-K><C-N> :set hlsearch!<CR>

" nerd Tree focus
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>

" puremourning/vimspector
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>
" nnoremap <S-k> :call vimspector#StepOut()<CR>
" nnoremap <S-l> :call vimspector#StepInto()<CR>
" nnoremap <S-j> :call vimspector#StepOver()<CR>
nnoremap <leader>d_ :call vimspector#Restart()<CR>
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dh :call vimspector#ToggleConditionalBreakpoint()<CR>

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


