" https://github.com/reedes/vim-textobj-quote

if empty(globpath(&runtimepath, '/plugged/vim-textobj-quote')) | finish | endif

augroup vimrc_textobj_quote
  autocmd!
  autocmd FileType markdown,text,mail call textobj#quote#init()
augroup END
