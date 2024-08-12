
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
nnoremap <Leader>n :NERDTreeFocus<CR>
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>

" autocmd VimEnter * NERDTree


