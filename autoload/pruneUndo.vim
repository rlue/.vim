function! pruneUndo#initialize(dir)
  call s:prune(a:dir)

  augroup pruneUndo
    autocmd!
  augroup END
endfunction

" Remove from {dir} all files not modified in the last {n} days (default 30)
" (https://gist.github.com/mllg/5353184)
function! s:prune(dir, ...)
  let l:days = a:0 ? a:1 : 30
  let l:path = expand(a:dir)

  if !isdirectory(l:path)
    echohl WarningMsg | echo 'Invalid directory' | echohl None
    return 0
  endif

  for l:file in split(glob(l:path . '/*'), "\n")
    if localtime() > getftime(l:file) + 86400 * l:days && delete(l:file) != 0
      echoerr 's:prune_old_files(): ' . l:file . ' could not be deleted'
    endif
  endfor
endfunction
