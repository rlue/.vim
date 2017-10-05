" Easy execute and test mappings
nnoremap <buffer> <LocalLeader>r :exec 'w <bar> !node ' . fnameescape(expand('%:p'))<CR>
nnoremap <buffer> <LocalLeader>R :exec 'w <bar> !jsc ' . fnameescape(expand('%:p'))<CR>

" Auto-expanding, courtesy of -romainl-
inoremap (; (<CR>);<C-[>O
inoremap (, (<CR>),<C-[>O
inoremap {; {<CR>};<C-[>O
inoremap {, {<CR>},<C-[>O
inoremap [; [<CR>];<C-[>O
inoremap [, [<CR>],<C-[>O
