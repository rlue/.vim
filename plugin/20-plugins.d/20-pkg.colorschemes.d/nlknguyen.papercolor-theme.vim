" https://github.com/NLKNguyen/papercolor-theme

if empty(globpath(&runtimepath, '/colors/PaperColor.vim')) ||
      \ exists(':colorscheme') != 2 ||
      \ !filereadable($HOME . '/.config/darkmode') ||
      \ readfile($HOME . '/.config/darkmode')[0]
  finish
endif

colorscheme PaperColor
set bg=light
