setlocal foldenable
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal foldexpr=FoldCommentHeadings(v:lnum,'FoldVim')
setlocal foldtext=FoldText('FoldStatsVim')

function! FoldVim(lnum)
  if match(getline(a:lnum), '^\s*function!\= \(\u\|s:\|\w\+#\).\+\(.*\)') == 0
    return 'a1'
  elseif (match(getline(a:lnum), '^\s*endfunction$') == 0 &&
            \ (!empty(getline(a:lnum + 1)) || getline(nextnonblank(a:lnum + 1)) =~# '^" ')) ||
            \ (match(getline(a:lnum - 1), '^\s*endfunction$') == 0 &&
            \ (empty(getline(a:lnum)) && getline(nextnonblank(a:lnum)) !~# '^" '))
    return 's1'
  else
    return '='
  endif
endfunction

function! FoldStatsVim()
  let l:fold_range = range(v:foldstart + 1,
        \ s:is_funcdef(v:foldstart) ? prevnonblank(v:foldend) - 1 : v:foldend)

  " don't count blank lines or comments
  call filter(l:fold_range, "getline(v:val) !~# '^\\(\\W*$\\|\\s*\" \\)'")
  return '[' . len(l:fold_range) . ']'
endfunction

function! s:is_funcdef(lnum)
  return getline(a:lnum) =~ '^\s*function!\= \(\u\|s:\|\w\+#\).\+\(.*\)'
endfunction
