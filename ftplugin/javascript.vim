" Easy execute and test mappings
nnoremap <Leader>r :exec 'w <bar> !node ' . fnameescape(expand('%:p'))<CR>
nnoremap <Leader>R :exec 'w <bar> !jsc ' . fnameescape(expand('%:p'))<CR>
