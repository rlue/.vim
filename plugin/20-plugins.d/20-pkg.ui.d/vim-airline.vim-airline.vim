" https://github.com/vim-airline/vim-airline

if empty(globpath(&runtimepath, '/plugged/vim-airline')) | finish | endif

let g:airline_powerline_fonts                   = 1
let g:airline#extensions#whitespace#enabled     = 0
let g:airline#extensions#tabline#enabled        = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
