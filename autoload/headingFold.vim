" Accepts an optional callback function to define additional folding rules
function! headingFold#FoldCommentHeadings(lnum, ...)
  if s:heading_level(a:lnum)
    return '>' . s:heading_level(a:lnum)
  elseif s:end_of_hsubtree(a:lnum)
    return s:heading_level(nextnonblank(a:lnum))
  elseif getline(nextnonblank(a:lnum)) =~# '^" -\{3,\}'
    return 0
  elseif a:0 && exists('*' . a:1)
    return call(a:1, [a:lnum])
  else
    return '='
  endif
endfunction

function! s:heading_level(lnum)
  let l:rgx = substitute(&l:commentstring, '%s$', '', '') . ' .\+ \(=\+\|-\+\)'
  if matchend(getline(a:lnum), l:rgx) == 80
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

" Accepts an optional callback function to define custom foldtext
function! headingFold#FoldText(...)
  let l:stats_func = (a:0 && exists('*' . a:1)) ? a:1 : 's:stats'

  let s:line = getline(v:foldstart)
  let s:preview_maxwidth = 80 - 1 - (strdisplaywidth(call(l:stats_func, []))) - 2

  let s:preview = s:line[0:(s:preview_maxwidth - 1)]

  let s:padding = repeat('-', s:preview_maxwidth - strdisplaywidth(s:preview) + 1)
  let s:padding = substitute(s:padding, '\(^.\|.$\)', ' ', 'g')

  return s:preview . s:padding . call(l:stats_func, []) . ' -'
endfunction

function! s:stats()
  let l:fold_range = range(v:foldstart + 1, v:foldend)

  " don't count blank lines or comments
  call filter(l:fold_range, "getline(v:val) !~# '^\\(\\W*$\\|\\s*" .
        \ substitute(&l:commentstring, '%s$', '') . " \\)'")
  return '[' . len(l:fold_range) . ']'
endfunction
