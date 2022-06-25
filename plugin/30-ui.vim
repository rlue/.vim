" UI ===========================================================================
" Colors & Highlighting --------------------------------------------------------
" Enable syntax highlighting, but limit on very long lines
syntax on
if exists('+synmaxcol')      | set synmaxcol=200   | endif

" Highlight search matches
if exists('+hlsearch')       | set hlsearch        | endif

" Shade bg after column 80 (for visual cue of suggested max line width)
if exists('+colorcolumn') 
  set colorcolumn=81
endif

highlight Normal ctermbg=none

call system('infocmp | grep [sr]itm') | if !v:shell_error
  highlight Comment cterm=italic
endif

" Hints ------------------------------------------------------------------------
" Show relative line numbers in left sidebar
if exists('+number')      | set number      | endif

" Windows ----------------------------------------------------------------------
" Open new windows below or to the right of the current buffer
if exists('+splitbelow')  | set splitbelow  | endif
if exists('+splitright')  | set splitright  | endif

" Line Wrapping ----------------------------------------------------------------
if exists('+wrap')        | set nowrap      | endif

" Wrap at word boundaries (instead of breaking words at textwidth)
if exists('+linebreak')   | set linebreak   | endif

" On long, wrapped lines, indent whole paragraph (instead of just first line)
if exists('+breakindent') | set breakindent | endif
