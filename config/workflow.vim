" This file modifies vim's basic editing environment: 
" how it loads buffers, loads new files, handles file metadata, etc.

" ENVIRONMENT PERSISTENCE ------------------------------------------------------

if &viminfo !~# ',n'              " Store viminfo within .vim/
  let &viminfo .= ',n' . g:vim_home . '/viminfo'
endif

" Remove files from path which have not been modified for 31 days
" (https://gist.github.com/mllg/5353184)
function! Tmpwatch(path, days)
  let l:path = expand(a:path)
  if isdirectory(l:path)
    for file in split(glob(l:path . '/*'), "\n")
      if localtime() > getftime(file) + 86400 * a:days && delete(file) != 0
        echoerr "Tmpwatch(): Error deleting '" . file . "'"
      endif
    endfor
  else
    echoerr "Tmpwatch(): Directory '" . l:path . "' not found"
  endif
endfunction

if has('persistent_undo')         " Store vimundo within .vim/
  set undofile
  set undolevels=5000
  if !isdirectory(g:vim_home . '/vimundo')
    call mkdir(g:vim_home . '/vimundo')
  endif
  let &undodir = g:vim_home . '/vimundo'
  call Tmpwatch(&undodir, 30)
endif

" ENCRYPTION -------------------------------------------------------------------

if has('crypt-blowfish2') | set cm=blowfish2 | endif

" FILE PERSISTENCE -------------------------------------------------------------

if exists('+nobackup')   | set nobackup                    | endif " Disable auto-backup when overwriting files
if exists('+hidden')     | set hidden                      | endif " Keep buffers alive when abandoned
if exists('+directory')  | set directory^=$HOME/.vim/swap/ | endif " Store all swap files together
if exists('+backupcopy') | set backupcopy=yes              | endif " Force backups to be copied from original, not renamed

" FILE MANIPULATION ------------------------------------------------------------

function! MoveFile(dest, bang)
  let l:source = expand('%:p')
  let l:target = fnamemodify(a:dest, ':p')
  let l:target_path = fnamemodify(l:target, ':h')

  " Potential errors (destination directory does not exist, overwrite existing file?)
  if !isdirectory(l:target_path)
    if (a:bang ==# '!')
      exec '!mkdir -p ' . l:target_path
    else
      echoerr l:target_path . ': No such directory'
      return 0
    endif
  elseif bufexists(l:target)
    if (a:bang ==# '!')
      exec 'bwipe!' . bufnr(l:target)
    else
      echoerr 'File is loaded in another buffer (add ! to override)'
      return 0
    endif
  endif

  execute 'saveas' . a:bang . ' ' . fnameescape(l:target) .
              \ (isdirectory(l:target) ? expand('%:t') : '')

  call delete(l:source)
  execute bufnr(l:source) . 'bwipe!'

  return 1
endfunction

command! -nargs=1 -complete=file -bar -bang Mv call MoveFile('<args>', '<bang>')

" FILE METADATA ----------------------------------------------------------------

filetype plugin indent on                                         " Enable filetype detection
if exists('+encoding')    | set encoding=utf-8           | endif  " Set Unicode
if exists('+fileformats') | set fileformats=unix,dos,mac | endif  " Order of preferred file formats

" COMMAND LINE OPTIONS ---------------------------------------------------------

cabbr <expr> %% fnameescape(expand('%:p:h'))        " shortcut: directory of current buffer
if exists('+ignorecase') | set ignorecase | endif   " Search with...
if exists('+smartcase')  | set smartcase  | endif   " ...smart case recognition
if exists('+wildignore') | set wildignore+=*/tmp/*,*.zip,*.swp,*.so | endif


" EXTERNAL TOOLS ---------------------------------------------------------------

" grep (ag)
call system('type ag')

if v:shell_error == 0
  if exists('+grepprg')    | set grepprg=ag\ --vimgrep\ $* | endif
  if exists('+grepformat') | set grepformat=%f:%l:%c:%m    | endif
endif
