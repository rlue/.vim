" :make settings
compiler ruby
setlocal makeprg=ruby\ -wc\ %

" Easy execute and test mappings
nnoremap <buffer> <LocalLeader>r :exec 'w <bar> !ruby ' . fnameescape(expand('%:p'))<CR>
nnoremap <buffer> <LocalLeader>m :make<CR>

" " Set default directories for :find
" setlocal path+=lib/**,spec/**

" Folding ----------------------------------------------------------------------
if expand('%:t:r') !~ '_spec$'
  setlocal nofoldenable
  setlocal foldmethod=syntax
  setlocal foldtext=ruby#foldtext()
endif

function! ruby#foldtext()
  let s:line = getline(v:foldstart)
  let s:preview_maxwidth = 80 - 1 - (strdisplaywidth(s:stats())) - 2

  let s:preview = s:drop_trailing_do(s:line)[0:(s:preview_maxwidth - 1)]
  let s:preview = substitute(s:preview, '^\( *\)  ', '\1- ', '')

  let s:padding = repeat('-', s:preview_maxwidth - strdisplaywidth(s:preview) + 1)
  let s:padding = substitute(s:padding, '\(^.\|.$\)', ' ', 'g')

  return s:preview . s:padding . s:stats() . ' -'
endfunction

function! s:stats()
  let l:inner_block = range(v:foldstart + 1, prevnonblank(v:foldend) - 1)

  " don't count blank lines or comments
  call filter(l:inner_block, "getline(v:val) !~# '^\\(\\W*$\\|\\s*\#\\)'")
  return '[' . len(l:inner_block) . ']'
endfunction

function! s:drop_trailing_do(str)
  return substitute(a:str, '\s\+do\( |.\+|\)\=$', '', '')
endfunction
