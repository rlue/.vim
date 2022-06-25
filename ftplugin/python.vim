
if executable('black')
    augroup black
      autocmd!
      autocmd BufWritePost *.py silent exec "!black -q %"
    augroup END
endif
