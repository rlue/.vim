" :make settings
compiler ruby
setlocal makeprg=ruby\ -wc\ %

" Easy execute and test mappings
nnoremap <Leader>r :exec 'w <bar> !ruby ' . fnameescape(expand('%:p'))<CR>
nnoremap <Leader>m :make<CR>
nnoremap <Leader>T :w <bar> !rspec<CR>
nnoremap <Leader>t :exec 'w <bar> !rspec ' . fnameescape(expand('%:p'))<CR>

" " Set default directories for :find
" setlocal path+=lib/**,spec/**
