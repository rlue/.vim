" WORKFLOW =====================================================================
" This section concerns vim's basic editing environment: 
" how it loads buffers, loads new files, handles file metadata, etc.

" Environment Persistence ------------------------------------------------------
if has('persistent_undo')         " Store vimundo within .vim/
  set undofile
  set undolevels=5000
  augroup pruneUndo
    autocmd!
    autocmd CursorHold,CursorHoldI * call pruneUndo#initialize(&undodir)
  augroup END
endif

" Encryption -------------------------------------------------------------------

if has('crypt-blowfish2') | set cryptmethod=blowfish2 | endif

" File Persistence -------------------------------------------------------------

if exists('+nobackup')   | set nobackup       | endif " Disable auto-backup when overwriting files
if exists('+hidden')     | set hidden         | endif " Keep buffers alive when abandoned
if exists('+backupcopy') | set backupcopy=yes | endif " Force backups to be copied from original, not renamed

" File Metadata ----------------------------------------------------------------

if exists('+modeline') | set modeline | endif
if exists('+fileformats') | set fileformats=unix,dos,mac | endif
if exists('+filetype') | filetype plugin indent on | endif
if exists('+encoding') | set encoding=utf-8 | scriptencoding utf-8 | endif

" Command Line Options ---------------------------------------------------------

cabbr <expr> %% fnameescape(expand('%:p:h'))        " shortcut: directory of current buffer
if exists('+path')       | set path+=**   | endif   " Search files recursively
if exists('+ignorecase') | set ignorecase | endif   " Search with...
if exists('+smartcase')  | set smartcase  | endif   " ...smart case recognition
if exists('+wildignore') | set wildignore+=*.zip,*.swp,*.so | endif

" Text parsing -----------------------------------------------------------------
" if exists('+cpoptions') | set cpoptions+=J | endif  " from http://stevelosh.com/blog/2012/10/why-i-two-space/

" Snippets ---------------------------------------------------------------------
nnoremap <silent> <LocalLeader>bp :call <SID>insertBoilerplate()<CR>

function! s:insertBoilerplate()
  let l:boilerplate_file = $VIM_CONFIG_HOME . '/boilerplate/_.' . &filetype

  if filereadable(l:boilerplate_file)
    exec '-1read ' . l:boilerplate_file
  endif
endfunction

" External Tools ---------------------------------------------------------------

" grep (repgrip/ag)
if exists('+grepprg') && exists('+grepformat')
  if executable('rg')
    let &grepprg = 'rg --vimgrep $*' 
  elseif executable('ag')
    let &grepprg = 'ag --vimgrep $*' 
  endif

  let &grepformat = '%f:%l:%c:%m'             
endif

if executable('black')
    augroup black
      autocmd!
      autocmd BufWritePost *.py silent exec "!black -q %"
    augroup END
endif

