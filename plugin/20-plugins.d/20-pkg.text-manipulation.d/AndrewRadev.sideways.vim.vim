" https://github.com/AndrewRadev/sideways.vim

if empty(globpath(&runtimepath, '/plugged/sideways.vim')) | finish | endif

" t as in Transpose
nnoremap <Leader>t :SidewaysLeft<CR>
nnoremap <Leader>T :SidewaysRight<CR>
