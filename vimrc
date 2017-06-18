let g:vim_home = expand('<sfile>:p:h')
let $MYVIMRC   = g:vim_home . '/vimrc'
let $MYGVIMRC  = g:vim_home . '/gvimrc'

for file in split(glob(g:vim_home . '/config/**.vim'), '\n')
  exec 'source ' . file
endfor
