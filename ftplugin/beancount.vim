setlocal foldenable
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal foldexpr=FoldCommentHeadings(v:lnum)
setlocal foldtext=FoldText()

if executable('bean-web')
  nnoremap <buffer> <LocalLeader>w :!bean-web %<CR>
endif
