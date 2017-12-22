setlocal foldenable
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal foldexpr=FoldCommentHeadings(v:lnum)
setlocal foldtext=FoldText()

if executable('bean-web')
  nnoremap <buffer> <LocalLeader>w :!bean-web %<CR>
endif

nnoremap <silent> <buffer> <LocalLeader><Space> :set hls! <Bar> :s/\v^(.*%(:=\w+)+)(\s+)(-=\d.*)$/\=(submatch(1) . repeat(' ', (80 + strwidth(submatch(2)) - strwidth(getline('.')))) . submatch(3))<CR>:set hls! <Bar> nohl<CR>
