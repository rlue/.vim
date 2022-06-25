" https://github.com/w0ng/vim-hybrid

if empty(globpath(&runtimepath, '/colors/hybrid.vim')) ||
      \ exists(':colorscheme') != 2 ||
      \ (filereadable($HOME . '/.config/darkmode') && !readfile($HOME . '/.config/darkmode')[0])
  finish
endif

colorscheme hybrid
set bg=dark
