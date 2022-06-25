" https://github.com/lervag/vimtex

if empty(globpath(&runtimepath, '/plugged/vimtex')) | finish | endif

let g:vimtex_view_method = 'mupdf'
let g:tex_flavor = 'latex'
