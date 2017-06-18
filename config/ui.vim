" This file contains adjustments to visual elements of the vim interface.

" Everyone's favorite colorscheme
if !empty(globpath(&rtp, 'colors/solarized.vim')) | colorscheme solarized | endif
if exists('+background')     | set background=dark | endif

" Enable syntax highlighting, but limit on very long lines
syntax on
if exists('+synmaxcol')      | set synmaxcol=200   | endif

" Show relative line numbers in left sidebar
if exists('+number')         | set number          | endif
if exists('+relativenumber') | set relativenumber  | endif

" Highlight search matches
if exists('+hlsearch')       | set hlsearch        | endif

" Shade bg after column 80 (for visual cue of suggested max line width)
augroup colorcolumn
  autocmd!
  autocmd FileType ruby,sh,vim,css,scss,javascript if exists('+colorcolumn') |
              \ let &l:colorcolumn=join(range(81,999),',') | endif
augroup END

" iTerm2 settings
if $TERM_PROGRAM =~# 'iTerm'
  " Dynamic cursor type (INSERT: `|` / NORMAL: `█`)
  if exists('+t_SI') | let &t_SI = "\<Esc>]50;CursorShape=1\x7" | endif
  if exists('+t_SI') | let &t_EI = "\<Esc>]50;CursorShape=0\x7" | endif

  if exists('+t_Co') | set t_Co=256 | endif " Enable 256 color mode
  highlight Comment cterm=italic            " Italicize comments
endif

" INTERFACE BEHAVIOR -----------------------------------------------------------

" Open new windows below or to the right of the current buffer
if exists('+splitbelow')  | set splitbelow  | endif
if exists('+splitright')  | set splitright  | endif

" Wrap at word boundaries (instead of breaking words at textwidth)
if exists('+linebreak')   | set linebreak   | endif

" On long, wrapped lines, indent whole paragraph (instead of just first line)
if exists('+breakindent') | set breakindent | endif
