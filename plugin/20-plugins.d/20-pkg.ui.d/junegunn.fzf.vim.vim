" https://github.com/junegunn/fzf.vim 

if empty(globpath(&runtimepath, '/plugged/fzf.vim')) | finish | endif

nnoremap <Leader>zf :Files<CR>
nnoremap <Leader>zb :Buffers<CR>
nnoremap <Leader>zl :Lines<CR>
nnoremap <Leader>zh :Helptags<CR>
nnoremap <Leader>zH :History<CR>

if executable('rg') && (exists(':Rg') != 2)
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%', '?'),
    \   <bang>0)
  nnoremap <Leader>zg :Rg<CR>
endif

" vi:ft=vim
