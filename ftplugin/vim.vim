setlocal foldenable
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal foldexpr=VimrcFoldExpr(v:lnum)
setlocal foldtext=VimrcFoldText()

function! VimrcFoldExpr(lnum)
  if s:heading_level(a:lnum)
    return '>' . s:heading_level(a:lnum)
  elseif s:end_of_hsubtree(a:lnum)
    return s:heading_level(nextnonblank(a:lnum))
  elseif getline(nextnonblank(a:lnum)) =~# '^" -\{3,\}'
    return 0
  elseif match(getline(a:lnum), '^\s*function!\= \(\u\|s:\|\w\+#\).\+\(.*\)') == 0
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

function! s:heading_level(lnum)
  if matchend(getline(a:lnum), '" .\+ \(=\+\|-\+\)') == 80
    return getline(a:lnum) =~# '=$' ? 1 : 2
  endif
endfunction

function! Foo(lnum)
  return empty(getline(a:lnum)) &&
              \ 0 < s:heading_level(nextnonblank(a:lnum)) &&
              \ s:heading_level(nextnonblank(a:lnum)) <= s:parent_hlevel(a:lnum)
endfunction

function! s:end_of_hsubtree(lnum)
  return empty(getline(a:lnum)) &&
              \ 0 < s:heading_level(nextnonblank(a:lnum)) &&
              \ s:heading_level(nextnonblank(a:lnum)) <= s:parent_hlevel(a:lnum)
endfunction

function! s:parent_hlevel(lnum)
  if s:heading_level(a:lnum)
    return s:heading_level(a:lnum)
  elseif a:lnum > 1
    return s:parent_hlevel(a:lnum - 1)
  endif
endfunction

function! VimrcFoldText()
  let fold_stats = '[' . len(filter(range(v:foldstart, v:foldend), "getline(v:val) =~# '\\w'")) . ']'
  let first_line = len(getline(v:foldstart)) < 80 ?
              \ getline(v:foldstart) . repeat(' ', 80 - len(getline(v:foldstart))) :
              \ getline(v:foldstart)
  let truncate_right = len(fold_stats) + 4
  return first_line[:(truncate_right * -1)] . ' ' . fold_stats . ' -'
endfunction
