" colorscheme elflord
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

