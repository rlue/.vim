" https://github.com/tpope/vim-dispatch

if empty(globpath(&runtimepath, '/plugged/vim-dispatch')) | finish | endif

nnoremap <F9> :Dispatch<CR>

augroup vimrc_dispatch
  autocmd!
  autocmd FileType ruby
        \ if expand('%:t:r') =~ '_spec$' | let b:dispatch = 'rspec %' | endif
augroup END
