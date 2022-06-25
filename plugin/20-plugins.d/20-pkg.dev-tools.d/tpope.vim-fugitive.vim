" https://github.com/tpope/vim-fugitive

if empty(globpath(&runtimepath, '/plugged/vim-fugitive')) | finish | endif

nnoremap <Leader>gm :GMove<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gC :Git commit --amend --no-edit<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gl :Gclog<CR>
nnoremap <Leader>gb :Git blame<CR>

" Clear out temporary buffers automatically
" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
augroup vimrc_fugitive
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
