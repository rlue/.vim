" UI ===========================================================================
" Colors & Highlighting --------------------------------------------------------
" Enable syntax highlighting, but limit on very long lines
syntax on
if exists('+synmaxcol')      | set synmaxcol=200   | endif

" Highlight search matches
if exists('+hlsearch')       | set hlsearch        | endif

" Shade bg after column 80 (for visual cue of suggested max line width)
if exists('+colorcolumn') 
  let s:colorcolumn_fts = ['sh', 'bash', 'vim',
        \                  'javascript', 'coffee',
        \                  'ruby', 'python']

  augroup vimrc_colorcolumn
    autocmd!
    execute 'autocmd FileType ' . join(s:colorcolumn_fts, ',') .
          \ ' let &l:colorcolumn = "' . join(range(81,999), ',') . '"'
  augroup END
endif

" Colorscheme
if exists('+background') | set background=dark | endif

if exists(':colorscheme') == 2
  if filereadable($HOME . '/.config/darkmode') && !readfile($HOME . '/.config/darkmode')[0] &&
        \ !empty(globpath(&runtimepath, '/colors/PaperColor.vim'))
    colorscheme PaperColor
    set bg=light
  elseif !empty(globpath(&runtimepath, '/colors/hybrid.vim'))
    colorscheme hybrid
    highlight Normal ctermbg=none

    if !empty(globpath(&runtimepath, '/plugin/limelight.vim'))
      let g:limelight_conceal_ctermfg = 'darkgray'
    endif
  endif
endif

call system('infocmp | grep [sr]itm') | if !v:shell_error
  highlight Comment cterm=italic
endif

" Folding ----------------------------------------------------------------------
set foldlevel=2

" Accepts an optional callback function to define additional folding rules
function! FoldCommentHeadings(lnum, ...)
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
function! FoldText(...)
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

" Hints ------------------------------------------------------------------------
" Show relative line numbers in left sidebar
if exists('+number')         | set number         | endif
" if exists('+relativenumber') | set relativenumber | endif

" Windows ----------------------------------------------------------------------
" Open new windows below or to the right of the current buffer
if exists('+splitbelow')  | set splitbelow  | endif
if exists('+splitright')  | set splitright  | endif

" Line Wrapping ----------------------------------------------------------------
if exists('+wrap')        | set nowrap   | endif

" Wrap at word boundaries (instead of breaking words at textwidth)
if exists('+linebreak')   | set linebreak   | endif

" On long, wrapped lines, indent whole paragraph (instead of just first line)
if exists('+breakindent') | set breakindent | endif

if filereadable($VIMRUNTIME . '/ftplugin/man.vim')
  let g:ft_man_folding_enable = 1
endif
