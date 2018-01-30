setlocal commentstring=#\ %s

inoremap <buffer> <Enter> <Enter>=get(systemlist('date +[%H:%M]'), 0)<CR> 
inoremap <buffer> <Enter><Enter> <CR><CR>
nnoremap <buffer> o :read !date +[\%H:\%M]<CR>A 
