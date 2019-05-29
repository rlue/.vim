setlocal nonumber
setlocal foldenable
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal foldexpr=FoldCommentHeadings(v:lnum)
setlocal foldtext=FoldText()

if executable('bean-web')
  nnoremap <buffer> <LocalLeader>w :!bean-web --public %<CR>
endif

nnoremap <silent> <buffer> <LocalLeader><Space> :call <SID>pad_line()<CR>
augroup beancount
  autocmd!
  autocmd InsertLeave <buffer> call <SID>pad_line()
augroup END

function! s:pad_line()
  if strlen(getline('.')) == 80 | return | endif

  if getline('.') =~? '\v^(\s+.*%(:[A-Z][a-zA-Z0-9-]+)+)(\s+)(-=\d+[0-9A-Z. @]*[A-Z]+)$'
    execute 'substitute/\v^(\s+.*%(:[A-Z][a-zA-Z0-9-]+)+)(\s+)(-=\d+[0-9A-Z. @]*[A-Z]+)$/\=(submatch(1) . repeat(" ", (80 + strwidth(submatch(2)) - strwidth(getline(".")))) . submatch(3))'
  elseif getline('.') =~? '\v^(\d{4}%(-\d{2}){2}\s+[*!P]%(\s+\"[^\"]*\"){,2})(\s+)([#^]\S+)$'
    execute 'substitute/\v^(\d{4}%(-\d{2}){2}\s+[*!P]%(\s+\"[^\"]*\"){,2})(\s+)([#^]\S+)$/\=(submatch(1) . repeat(" ", (80 + strwidth(submatch(2)) - strwidth(getline(".")))) . submatch(3))'
  endif
endfunction
