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
let g:airline_theme = 'codedark'
colorscheme codedark


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

