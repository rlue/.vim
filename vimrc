" Initializing variables for portability
let g:vim_home = expand('<sfile>:p:h')
let $MYVIMRC   = g:vim_home . '/vimrc'
let $MYGVIMRC  = g:vim_home . '/gvimrc'

" MAPPINGS =====================================================================

" BASE -------------------------------------------------------------------------

let mapleader = "\<Space>"
let maplocalleader = "\\"
if exists('+wildcharm') | set wildcharm=<C-z> | endif

" TEXT MANIPULATION ------------------------------------------------------------

" Y should be like C & D, not 'yy'
nnoremap Y y$

" Enable linewise repeat commands (via `.`) in Visual Mode
" (via http://vim.wikia.com/wiki/Repeat_command_on_each_line_in_visual_block)
vnoremap . :normal .<CR>

" Easy yank-put from system clipboard
if has('clipboard')
  nnoremap <Leader>p "*p
  nnoremap <Leader>P "*P
  nnoremap <Leader>y "*y
  nnoremap <Leader>Y "*y$
  nnoremap <Leader>d "*d
  nnoremap <Leader>D "*D
  vnoremap <Leader>p "*p
  vnoremap <Leader>P "*P
  vnoremap <Leader>y "*y
  vnoremap <Leader>Y "*y$
  vnoremap <Leader>d "*d
  vnoremap <Leader>D "*D
endif

" Easy whitespace
nnoremap <Leader>k m`O<Esc>``
nnoremap <Leader>j m`o<Esc>``
nnoremap <Leader>h i <Esc>l
nnoremap <Leader>l a <Esc>h
nnoremap <Leader><CR> i<CR><Esc>`.

" More text objects! 
for char in [ '_', '-', '.', ':', ',', ';', '<bar>',
            \ '/', '<bslash>', '*', '+', '%', '`' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" BUFFER MANAGEMENT ------------------------------------------------------------
" Save
nnoremap <Leader>w :update<CR>
nnoremap <Leader>W :wa<CR>

" Switch
nnoremap <Leader>b :ls<CR>:b
nnoremap <Leader>B :browse oldfiles<CR>

" UI & WINDOW MANAGEMENT -------------------------------------------------------
" Easy window switching
if exists('+winminheight') | set winminheight=0 | endif
if exists('+winminwidth')  | set winminwidth=0  | endif
nnoremap <C-w>h     <C-w>h<C-w>=
nnoremap <C-w>j     <C-w>j<C-w>=
nnoremap <C-w>k     <C-w>k<C-w>=
nnoremap <C-w>l     <C-w>l<C-w>=
nnoremap <C-w><C-h> <C-w>h<C-w>_<C-w><Bar>
nnoremap <C-w><C-j> <C-w>j<C-w>_<C-w><Bar>
nnoremap <C-w><C-k> <C-w>k<C-w>_<C-w><Bar>
nnoremap <C-w><C-l> <C-w>l<C-w>_<C-w><Bar>

" FILE MANAGEMENT --------------------------------------------------------------
if isdirectory($HOME . '/Documents/Notes')
  nnoremap <Leader>en :e ~/Documents/Notes/**/
endif
if isdirectory($HOME . '/Projects/rlue.github.io')
  nnoremap <Leader>eb :e ~/Projects/rlue.github.io/_drafts/**/
endif

" NAVIGATION -------------------------------------------------------------------

" Smart j/k (move by display lines unless a count is provided)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" " Find cursor
" nnoremap <silent> <Leader><Leader> :call FlashLine()<CR>
" function! FlashLine()
"   for i in [30, 50, 30, 250]
"     set cursorline!
"     exec 'sleep ' . i . 'm'
"     redraw
"   endfor
" endfunction

" MISCELLANEOUS ----------------------------------------------------------------

" $MYVIMRC source/edit
nnoremap <Leader>ev :e'e ' . g:vim_home . '/**/'<CR>
nnoremap <silent> <Leader>sv :call UpdateRCs() <Bar> source $MYVIMRC <Bar>
            \ if has('gui_running') <Bar> source $MYGVIMRC <Bar> endif<Bar>
            \ if exists(':AirlineRefresh') <Bar> AirlineRefresh <Bar> endif<CR>

" Save all open vimrc buffers, then source vimrc
function! UpdateRCs()
  let this_buf    = bufnr('%')
  let open_bufs   = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let config_bufs = filter(open_bufs, 
              \           "expand('#' . v:val . ':p') =~# '^" . g:vim_home . "/g\\=vimrc'")
  for bufnr in config_bufs
    exec bufnr . 'buffer | update'
  endfor
  exec this_buf . 'buffer'
endfunction

" Disable Ex mode (http://www.bestofvim.com/tip/leave-ex-mode-good/)
nnoremap Q <Nop>

" Switch from Search to Replace super fast!
" nmap <expr> M ':%s/' . @/ . '//g<LEFT><LEFT>'

" PER-MACHINE ==================================================================

" SEEDBOX ----------------------------------------------------------------------
" Reset colorscheme
if hostname() =~# 'porphyrion' | colorscheme default | endif

" DEFAULT WORKING DIRECTORY ----------------------------------------------------
" if has('win32')
"   if $COMPUTERNAME == "ODALISQUE"
"     :cd $HOMEPATH/Dropbox
"   endif
" elseif has('unix')
"   if hostname() =~ "liberte"
"     :cd $HOME/Dropbox/
"   elseif hostname() =~ "sardanapalus"
"     :cd $HOME/Dropbox/Work
"   endif
" else
"     :cd $HOME/
" endif

" PLUGINS ======================================================================

" VIM-PLUG ---------------------------------------------------------------------
" Automatically install and run if not found
if empty(glob(g:vim_home . '/autoload/plug.vim'))
  exec 'silent !curl -fLo ' . g:vim_home . '/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  augroup vimPlug
    autocmd!
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif

call plug#begin()

Plug        'jaxbot/browserlink.vim'
Plug      'junegunn/goyo.vim'
Plug      'junegunn/limelight.vim'
Plug     'NLKNguyen/papercolor-theme'
Plug 'vim-syntastic/syntastic'
Plug        'gioele/vim-autoswap'
Plug   'altercation/vim-colors-solarized'
Plug         'tpope/vim-commentary'
Plug            'ap/vim-css-color'
Plug   'vim-airline/vim-airline'
Plug   'vim-airline/vim-airline-themes'
Plug      'justinmk/vim-dirvish'
Plug      'junegunn/vim-easy-align'
Plug         'tpope/vim-fugitive'
Plug          'rlue/vim-getting-things-down'
Plug        'henrik/vim-indexed-search'
Plug      'pangloss/vim-javascript'
Plug         'tpope/vim-liquid'
Plug         'tpope/vim-rails'
Plug         'tpope/vim-repeat'
Plug         'tpope/vim-rsi'
Plug         'tpope/vim-sensible'
Plug         'tpope/vim-sleuth'
Plug 'slim-template/vim-slim'
Plug         'tpope/vim-speeddating'
Plug         'tpope/vim-surround'
Plug          'kana/vim-textobj-user' | Plug 'reedes/vim-textobj-quote'
Plug         'tpope/vim-unimpaired'
" Plug 'w0rp/ale'

call plug#end()

" BROWSERLINK ------------------------------------------------------------------

let g:bl_no_mappings   = 1        " Disable default mappings

" Override BL's built-in autocmd (give Jekyll time to rebuild before reloading)
let g:bl_no_autoupdate = 1
let s:delay_interval   = '1500m'
let s:bl_pagefileexts  = 
      \ [ 'html' , 'js'     , 'php'  ,
      \   'css'  , 'scss'   , 'sass' ,
      \   'slim' , 'liquid' , 'md'     ]

augroup browserlink
  autocmd!
  exec 'autocmd BufWritePost *.' . join(s:bl_pagefileexts,',*.') .
              \ ' call s:trigger_reload("' . expand('%:p:h') . '")'
augroup END

function! s:trigger_reload(dir)
  if filereadable(a:dir . '/_config.yml')         " in a Jekyll project root
    exec 'sleep ' . s:delay_interval
  elseif a:dir =~# $HOME . '\S\+'                 " somewhere inside home
    call s:trigger_reload(fnamemodify(a:dir, ':h'))
    return 0
  endif

  execute expand('%:e:e') =~? 'css' ? 'BLReloadCSS' : 'BLReloadPage' 
endfunction

" LIMELIGHT --------------------------------------------------------------------

let g:limelight_default_coefficient = 0.7   " Set deeper default shading

augroup goyo_ll
  autocmd!
  autocmd User GoyoEnter Limelight           " Tie Limelight to Goyo
  autocmd User GoyoLeave Limelight!
augroup END

" SYNTASTIC --------------------------------------------------------------------

let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_slim_checkers = ['slim_lint']
let g:syntastic_vim_checkers  = ['vint']
let g:syntastic_scss_checkers = ['sass_lint']
let g:syntastic_mode_map      = { 'mode':              'active',
            \                     'active_filetypes':  [],
            \                     'passive_filetypes': [''] }

" per https://github.com/Kuniwak/vint/issues/198
let g:syntastic_vim_vint_exe = 'LC_CTYPE=UTF-8 vint'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0

" " Close location list (i.e., error list) on :bd
" cabbrev <silent> bd <C-r>=(getcmdtype()==#':' && getcmdpos()==1 ? 
"                            \ 'lclose\|bdelete' : 'bd')<CR>

nnoremap <Leader>sc :SyntasticCheck<CR>
nnoremap <Leader>st :SyntasticToggleMode<CR>

" VIM-AIRLINE ------------------------------------------------------------------

let g:airline_powerline_fonts                   = 1
let g:airline#extensions#whitespace#enabled     = 0
let g:airline#extensions#tabline#enabled        = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme                             = 'solarized'

" VIM-DIRVISH ------------------------------------------------------------------

" Disable netrw
let g:loaded_netrwPlugin = 1

" Re-enable netrw's `gx` command
nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx") ?
            \                             g:netrw_gx : '<cfile>')),
            \     netrw#CheckIfRemote())<CR>

augroup dirvish
  autocmd!
  autocmd FileType dirvish silent g/.DS_Store/d    " Hide .DS_Store
augroup END

" VIM-EASY-ALIGN ---------------------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" VIM-FUGITIVE -----------------------------------------------------------------

nnoremap <Leader>gm :Gmove<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gc :Gcommit -m ""<Left>
nnoremap <Leader>gp :Gpush<CR>

" VIM-GETTING-THINGS-DOWN ------------------------------------------------------

" Quick-switch between current file and `TODO.md` of project root
nnoremap <Leader><Leader> :call getting_things_down#show_todo()<CR>

" Cycle through TODO keywords
nnoremap <silent> <Leader>c :call getting_things_down#cycle_status()<CR>

" VIM-TEXTOBJ-QUOTE ------------------------------------------------------------

augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType text     call textobj#quote#init()
augroup END

" UI ===========================================================================
" This section concerns vim's user interface.

" COLORS & HIGHLIGHTING --------------------------------------------------------
" Everyone's favorite colorscheme
if !empty(globpath(&rtp, '/colors/solarized.vim')) | colorscheme solarized | endif
if exists('+background')     | set background=dark | endif

" Enable syntax highlighting, but limit on very long lines
syntax on
if exists('+synmaxcol')      | set synmaxcol=200   | endif

" Highlight search matches
if exists('+hlsearch')       | set hlsearch        | endif

" Shade bg after column 80 (for visual cue of suggested max line width)
augroup colorcolumn
  autocmd!
  autocmd FileType ruby,sh,vim,css,scss,javascript if exists('+colorcolumn') |
              \ let &l:colorcolumn=join(range(81,999),',') | endif
augroup END

" HINTS ------------------------------------------------------------------------
" Show relative line numbers in left sidebar
if exists('+number')         | set number          | endif
if exists('+relativenumber') | set relativenumber  | endif

" WINDOWS ----------------------------------------------------------------------
" Open new windows below or to the right of the current buffer
if exists('+splitbelow')  | set splitbelow  | endif
if exists('+splitright')  | set splitright  | endif

" LINE WRAPPING ----------------------------------------------------------------
" Wrap at word boundaries (instead of breaking words at textwidth)
if exists('+linebreak')   | set linebreak   | endif

" On long, wrapped lines, indent whole paragraph (instead of just first line)
if exists('+breakindent') | set breakindent | endif

" iTERM 2 ----------------------------------------------------------------------
if $TERM_PROGRAM =~# 'iTerm'
  " Dynamic cursor type (INSERT: `|` / NORMAL: `█`)
  if exists('+t_SI') | let &t_SI = "\<Esc>]50;CursorShape=1\x7" | endif
  if exists('+t_SI') | let &t_EI = "\<Esc>]50;CursorShape=0\x7" | endif

  if exists('+t_Co') | set t_Co=256 | endif " Enable 256 color mode
  highlight Comment cterm=italic            " Italicize comments
endif

" WORKFLOW =====================================================================
" This section concerns vim's basic editing environment: 
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

if exists('+nobackup')   | set nobackup       | endif " Disable auto-backup when overwriting files
if exists('+hidden')     | set hidden         | endif " Keep buffers alive when abandoned
if exists('+backupcopy') | set backupcopy=yes | endif " Force backups to be copied from original, not renamed
" Store all swap files together
if exists('+directory')
  if !isdirectory(g:vim_home . '/swap')
    call mkdir(g:vim_home . '/swap')
  endif
  let &directory = g:vim_home . '/swap'
endif

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

