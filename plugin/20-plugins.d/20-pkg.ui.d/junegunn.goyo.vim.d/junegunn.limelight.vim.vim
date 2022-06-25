" https://github.com/junegunn/limelight.vim

if empty(globpath(&runtimepath, '/plugged/limelight.vim')) | finish | endif

let g:limelight_default_coefficient = 0.7
let g:limelight_conceal_ctermfg = 'darkgray'

if empty(globpath(&runtimepath, '/plugged/goyo.vim')) | finish | endif

augroup vimrc_goyo
  autocmd!
  autocmd FileType markdown nnoremap <buffer> <LocalLeader>f :Goyo<CR>
  autocmd User GoyoEnter Limelight
  autocmd User GoyoLeave Limelight!
augroup END
