" https://github.com/justinmk/vim-dirvish

if empty(globpath(&runtimepath, '/plugged/vim-dirvish')) | finish | endif

" Disable netrw
" let g:loaded_netrwPlugin = 1

" Re-enable netrw's `gx` command
" nnoremap gx :call
"       \ netrw#BrowseX(expand(exists("g:netrw_gx") ? g:netrw_gx : '<cfile>'),
"       \               netrw#CheckIfRemote())<CR>

augroup vimrc_dirvish
  autocmd!
  autocmd FileType dirvish silent g/.DS_Store/d    " Hide .DS_Store
augroup END
