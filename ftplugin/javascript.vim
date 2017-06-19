" Easy execute and test mappings
nnoremap <Leader>r :exec 'w <bar> !node ' . fnameescape(expand('%:p'))<CR>
nnoremap <Leader>R :exec 'w <bar> !jsc ' . fnameescape(expand('%:p'))<CR>

" Auto-expanding, courtesy of -romainl-
inoremap (; (<CR>);<C-[>O
inoremap (, (<CR>),<C-[>O
inoremap {; {<CR>};<C-[>O
inoremap {, {<CR>},<C-[>O
inoremap [; [<CR>];<C-[>O
inoremap [, [<CR>],<C-[>O
