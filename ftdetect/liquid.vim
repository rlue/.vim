au BufNewFile,BufRead *.css,*.scss,*.js
\ if getline(1) == '---' | set ft=liquid | endif
