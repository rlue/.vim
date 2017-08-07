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
  let s:line = getline(v:foldstart)
  let s:preview_maxwidth = 80 - 1 - (strdisplaywidth(s:stats())) - 2

  let s:preview = s:line[0:(s:preview_maxwidth - 1)]

  let s:padding = repeat('-', s:preview_maxwidth - strdisplaywidth(s:preview) + 1)
  let s:padding = substitute(s:padding, '\(^.\|.$\)', ' ', 'g')

  return s:preview . s:padding . s:stats() . ' -'
endfunction

function! Stats(foldstart, foldend)
  let l:fold_range = range(a:foldstart + 1,
        \ s:is_funcdef(a:foldstart) ? prevnonblank(a:foldend) - 1 : a:foldend)

  " don't count blank lines or comments
  call filter(l:fold_range, "getline(v:val) !~# '^\\(\\W*$\\|\\s*\" \\)'")
  return '[' . len(l:fold_range) . ']'
endfunction

function! s:stats()
  let l:fold_range = range(v:foldstart + 1,
        \ s:is_funcdef(v:foldstart) ? prevnonblank(v:foldend) - 1 : v:foldend)

  " don't count blank lines or comments
  call filter(l:fold_range, "getline(v:val) !~# '^\\(\\W*$\\|\\s*\" \\)'")
  return '[' . len(l:fold_range) . ']'
endfunction

function! s:is_funcdef(lnum)
  return getline(a:lnum) =~ '^\s*function!\= \(\u\|s:\|\w\+#\).\+\(.*\)'
endfunction
