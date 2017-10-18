" Initializing variables for portability
let g:vim_home = expand('<sfile>:p:h')
let $MYVIMRC   = g:vim_home . '/vimrc'
let $MYGVIMRC  = g:vim_home . '/gvimrc'

" STAGING ======================================================================

" MAPPINGS =====================================================================
" Base -------------------------------------------------------------------------
let mapleader = "\<Space>"
let maplocalleader = "\\"
if exists('+wildcharm') | set wildcharm=<C-z> | endif

" Text Manipulation ------------------------------------------------------------
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
nnoremap <Leader>k    m`O<Esc>``
nnoremap <Leader>j    m`o<Esc>``
nnoremap <Leader>h    i <Esc>l
nnoremap <Leader>l    a <Esc>h
nnoremap <Leader><CR> i<CR><Esc>`.

" More text objects! 
for char in [ '_', '-', '.', ':', ',', ';', '<bar>',
            \ '/', '<bslash>', '*', '+', '%', '`' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" Buffer Management ------------------------------------------------------------
" Save
nnoremap <Leader>w :update<CR>
nnoremap <Leader>W :wa<CR>

" Switch
nnoremap <Leader>b :ls<CR>:b
nnoremap <Leader>B :browse oldfiles<CR>

" UI & Window Management -------------------------------------------------------
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

" File Management --------------------------------------------------------------
if isdirectory($HOME . '/Documents/Notes')
  nnoremap <Leader>en :e ~/Documents/Notes/**/
endif
" if isdirectory($HOME . '/Projects/rlue.github.io')
"   nnoremap <Leader>eb :e ~/Projects/rlue.github.io/_drafts/**/
" endif

" Navigation -------------------------------------------------------------------

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

" Miscellaneous ----------------------------------------------------------------

" $MYVIMRC source/edit
nnoremap <Leader>ev :e $MYVIMRC<CR>
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

" Seedbox ----------------------------------------------------------------------
" Reset colorscheme
if hostname() =~# 'porphyrion' | colorscheme default | endif

" Default Working Directory ----------------------------------------------------
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

" vim-plug ---------------------------------------------------------------------
" Automatically install and run if not found
if empty(glob(g:vim_home . '/autoload/plug.vim'))
  exec 'silent !curl -fLo ' . g:vim_home . '/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  augroup vimrc_vim_plug
    autocmd! | autocmd VimEnter * execute 'PlugInstall | source $MYVIMRC'
  augroup END
endif

call plug#begin()
Plug '~/Projects/vim-barbaric'
Plug '~/Projects/vim-fold-rspec'
Plug '~/Projects/vim-getting-things-down'
Plug '~/Projects/vim-rspec'

Plug           'w0rp/ale'
" Plug         'jaxbot/browserlink.vim'
Plug       'junegunn/goyo.vim'
Plug        'morhetz/gruvbox'
Plug       'junegunn/limelight.vim'
Plug      'NLKNguyen/papercolor-theme'
Plug    'AndrewRadev/splitjoin.vim'
Plug    'altercation/vim-colors-solarized'
Plug          'tpope/vim-commentary'
Plug             'ap/vim-css-color'
Plug    'vim-airline/vim-airline'
Plug    'vim-airline/vim-airline-themes'
Plug    'nathangrigg/vim-beancount'
Plug       'justinmk/vim-dirvish'
Plug          'tpope/vim-dispatch'
Plug       'junegunn/vim-easy-align'
" Plug           'rlue/vim-fold-rspec'
Plug       'jamessan/vim-gnupg'
Plug 'ludovicchabant/vim-gutentags'
" Plug           'rlue/vim-getting-things-down'
Plug           'w0ng/vim-hybrid'
Plug         'henrik/vim-indexed-search'
Plug       'pangloss/vim-javascript'
Plug          'tpope/vim-liquid'
Plug          'tpope/vim-rails'
Plug          'tpope/vim-repeat'
Plug          'tpope/vim-rsi'
" Plug     'thoughtbot/vim-rspec'
Plug          'tpope/vim-sensible'
Plug          'tpope/vim-sleuth'
Plug  'slim-template/vim-slim'
Plug          'tpope/vim-speeddating'
Plug          'tpope/vim-surround'
Plug           'kana/vim-textobj-user' | Plug 'reedes/vim-textobj-quote'
Plug          'tpope/vim-unimpaired'
Plug          'posva/vim-vue'

" Include fzf whether installed via Homebrew or user-locally
if executable('fzf') && v:version >= 740 && !has('gui_running')
  let fzf_dirs = ['~/.fzf']

  if executable('brew')
    call add(fzf_dirs, systemlist('brew --prefix')[0] . '/opt/fzf')
  endif

  for dir in fzf_dirs
    if isdirectory(dir)
      Plug dir | Plug 'junegunn/fzf.vim'
      break
    endif
  endfor
endif

call plug#end()

" ALE --------------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/ale.vim'))
  let g:ale_set_quickfix = 1
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  nnoremap <Leader>at :ALEToggle<CR>
  nnoremap <Leader>ad :ALEDetail<CR>
  nnoremap <Leader>al :ALELint<CR>
endif

" browserlink.vim --------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/browserlink.vim'))
  let g:bl_no_mappings   = 1        " Disable default mappings

  " Override BL's built-in autocmd (give Jekyll time to rebuild before first)
  let g:bl_no_autoupdate = 1
  let s:delay_interval   = '1500m'
  let s:bl_pagefileexts  = 
        \ [ 'html' , 'js'     , 'php'  ,
        \   'css'  , 'scss'   , 'sass' ,
        \   'slim' , 'liquid' , 'md'     ]

  augroup vimrc_browserlink
    autocmd!
    exec 'autocmd BufWritePost *.' . join(s:bl_pagefileexts, ',*.') .
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
endif

" fzf.vim ----------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/fzf.vim')) && executable('fzf') && !has('gui_running')
  nnoremap <Leader>ef :Files<CR>
  nnoremap <Leader>eb :Buffers<CR>
endif

" goyo -------------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/goyo.vim'))
  augroup vimrc_goyo
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <Leader>f :Goyo<CR>
  augroup END
endif

" limelight --------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/limelight.vim'))
  let g:limelight_default_coefficient = 0.7   " Set deeper default shading

  if exists(':Goyo')
    augroup vimrc_limelight
      autocmd!
      autocmd User GoyoEnter Limelight           " Tie Limelight to Goyo
      autocmd User GoyoLeave Limelight!
    augroup END
  endif
endif

" vim-airline ------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/airline.vim'))
  let g:airline_powerline_fonts                   = 1
  let g:airline#extensions#whitespace#enabled     = 0
  let g:airline#extensions#tabline#enabled        = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1
endif

" vim-autoswap -----------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/autoswap.vim'))
  let g:autoswap_detect_tmux = 1
endif

" vim-barbarian ----------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/barbarian.vim'))
  let g:barbarian_default = 0
endif

" vim-dirvish ------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/dirvish.vim'))
  " Disable netrw
  let g:loaded_netrwPlugin = 1

  " Re-enable netrw's `gx` command
  nnoremap gx :call
        \ netrw#BrowseX(expand(exists("g:netrw_gx") ? g:netrw_gx : '<cfile>'),
        \               netrw#CheckIfRemote())<CR>

  augroup vimrc_dirvish
    autocmd!
    autocmd FileType dirvish silent g/.DS_Store/d    " Hide .DS_Store
  augroup END
endif

" vim-dispatch -----------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/dispatch.vim'))
  nnoremap <F9> :Dispatch<CR>

  augroup vimrc_dispatch
    autocmd!
    autocmd FileType ruby
          \ if expand('%:t:r') =~ '_spec$' | let b:dispatch = 'rspec %' | endif
  augroup END
endif

" vim-easy-align ---------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/easy_align.vim'))
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

" vim-fugitive -----------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/fugitive.vim'))
  nnoremap <Leader>gm :Gmove<CR>
  nnoremap <Leader>gr :Gread<CR>
  nnoremap <Leader>gd :Gdiff<CR>
  nnoremap <Leader>gs :Gstatus<CR>
  nnoremap <Leader>gw :Gwrite<CR>
  nnoremap <Leader>gc :Gcommit -m ""<Left>
  nnoremap <Leader>gp :Gpush<CR>
  nnoremap <Leader>gl :Glog<CR>
  nnoremap <Leader>gb :Gblame<CR>
endif

" Clear out temporary buffers automatically
" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
autocmd BufReadPost fugitive://* set bufhidden=delete

" vim-getting-things-down ------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/getting_things_down.vim'))
  " Quick-switch between current file and `TODO.md` of project root
  nnoremap <Leader><Leader> :call getting_things_down#show_todo()<CR>

  " Cycle through TODO keywords
  nnoremap <silent> <Leader>c :call getting_things_down#cycle_status()<CR>

  " Toggle TODO tasks
  nnoremap <silent> <Leader>C :call getting_things_down#toggle_task()<CR>
  vnoremap <silent> <Leader>C :call getting_things_down#toggle_task()<CR>
endif

" vim-rspec --------------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/rspec.vim'))
  if !empty(globpath(&rtp, '/plugin/dispatch.vim'))
    let g:rspec_command = "Dispatch rspec {spec}"
  endif

  if has('gui')
    let g:rspec_runner = "os_x_iterm"
  endif

  augroup vimrc_rspec
    autocmd!
    autocmd FileType ruby call s:set_rspec_maps()
  augroup END

  function! s:set_rspec_maps()
    nnoremap <buffer> <LocalLeader>ss :call RunCurrentSpecFile()<CR>
    nnoremap <buffer> <LocalLeader>se :call RunExamples()<CR>
    vnoremap <buffer> <LocalLeader>se :call RunExamples()<CR>
    nnoremap <buffer> <LocalLeader>sr :call RunLastSpec()<CR>
    nnoremap <buffer> <LocalLeader>sa :call RunAllSpecs()<CR>
  endfunction
endif

" vim-textobj-quote ------------------------------------------------------------
if !empty(globpath(&rtp, '/plugin/textobj/quote.vim'))
  augroup vimrc_textobj_quote
    autocmd!
    autocmd FileType markdown,text call textobj#quote#init()
  augroup END
endif

" UI ===========================================================================
" This section concerns vim's user interface.

" Colors & Highlighting --------------------------------------------------------
" Everyone's favorite colorscheme
if !empty(globpath(&rtp, '/colors/solarized.vim')) | colorscheme solarized | endif
" if !empty(globpath(&rtp, '/colors/hybrid.vim'))
"   let g:hybrid_custom_term_colors = 1
"   let g:hybrid_reduced_contrast = 1
"   colorscheme hybrid
" endif
if exists('+background')     | set background=dark | endif

" Enable syntax highlighting, but limit on very long lines
syntax on
if exists('+synmaxcol')      | set synmaxcol=200   | endif

" Highlight search matches
if exists('+hlsearch')       | set hlsearch        | endif

" Shade bg after column 80 (for visual cue of suggested max line width)
if exists('+colorcolumn') 
  let &colorcolumn = join(range(81,999), ',')
  " autocmd VimEnter * let &l:colorcolumn = ''
  " let colorcolumn_fts = ['ruby', 'sh', 'vim', 'css', 'scss', 'javascript', 'slim']
  " augroup vimrc_colorcolumn
  "   autocmd!
  "   execute 'autocmd FileType ' .
  "         \ join(colorcolumn_fts, ',') .
  "         \ ' let &l:colorcolumn= join(range(81,999), \',\')'
  " augroup END
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
if exists('+number')         | set number          | endif
if exists('+relativenumber') | set relativenumber  | endif

" Windows ----------------------------------------------------------------------
" Open new windows below or to the right of the current buffer
if exists('+splitbelow')  | set splitbelow  | endif
if exists('+splitright')  | set splitright  | endif

" Line Wrapping ----------------------------------------------------------------
" Wrap at word boundaries (instead of breaking words at textwidth)
if exists('+linebreak')   | set linebreak   | endif

" On long, wrapped lines, indent whole paragraph (instead of just first line)
if exists('+breakindent') | set breakindent | endif

" iTerm ------------------------------------------------------------------------
if $TERM_PROGRAM =~# 'iTerm'
  " Dynamic cursor type (INSERT: `|`, NORMAL: `█`, REPLACE: `_`)
  " per https://vi.stackexchange.com/questions/3379/cursor-shape-under-vim-tmux
  " and http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
  " if has('cursorshape')
  "   function! s:cursor_code(val)
  "     let l:base        = ']50;CursorShape=' . a:val . ''
  "     let l:prefix = exists('$TMUX') ? 'Ptmux;' : ''
  "     let l:suffix = exists('$TMUX') ? '\' : ''
  "     return l:prefix . l:base . l:suffix
  "   endfunction

  "   let &t_SI = s:cursor_code(1)
  "   let &t_SR = s:cursor_code(2)
  "   let &t_EI = s:cursor_code(0)
  " endif

  " Enable 256 color mode
  if exists('+t_Co') | set t_Co=256 | endif

  " Italicize comments
  highlight Comment cterm=italic
  highlight Normal ctermbg=none
endif

" WORKFLOW =====================================================================
" This section concerns vim's basic editing environment: 
" how it loads buffers, loads new files, handles file metadata, etc.

" Environment Persistence ------------------------------------------------------

if &viminfo !~# ',n'              " Store viminfo within .vim/
  let &viminfo .= ',n' . g:vim_home . '/viminfo'
endif

if has('persistent_undo')         " Store vimundo within .vim/
  set undofile
  set undolevels=5000
  let &undodir = g:vim_home . '/vimundo'
  if !isdirectory(&undodir)
    call mkdir(&undodir)
  else
    " Remove from {dir} all files not modified in the last {n} days (default 30)
    " (https://gist.github.com/mllg/5353184)
    function! s:prune_old_files(dir, ...)
      let l:days = a:0 ? a:1 : 30
      let l:path = expand(a:dir)

      if !isdirectory(l:path)
        echohl WarningMsg | echo "Invalid directory" | echohl None
        return 0
      endif

      for file in split(glob(l:path . '/*'), "\n")
        if localtime() > getftime(file) + 86400 * l:days && delete(file) != 0
          echoerr 's:prune_old_files(): ' . file . ' could not be deleted'
        endif
      endfor
    endfunction
  
    call s:prune_old_files(&undodir)
  endif
endif

" Encryption -------------------------------------------------------------------

if has('crypt-blowfish2') | set cm=blowfish2 | endif

" File Persistence -------------------------------------------------------------

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

" File Manipulation ------------------------------------------------------------

function! MoveFile(dest, bang)
  let l:source = expand('%:p')
  let l:target = fnamemodify(a:dest, ':p')
  let l:target_dir = fnamemodify(l:target, ':h')

  if l:source == l:target
    return 0
  " Destination directory does not exist
  elseif !isdirectory(l:target_dir)
    if (a:bang ==# '!')
      call mkdir(l:target_dir, 'p')
    else
      echohl WarningMsg
        echo l:target_dir . ': no such directory (add ! to create)'
      echohl None
      return 0
    endif
  " Overwrite existing file?
  elseif bufexists(l:target)
    if (a:bang ==# '!')
      exec 'bwipe!' . bufnr(l:target)
    else
      echohl WarningMsg
        echo 'File is loaded in another buffer (add ! to override)'
      echohl None
      return 0
    endif
  endif

  execute 'saveas' . a:bang . ' ' . fnameescape(l:target) .
              \ (isdirectory(l:target) ? expand('%:t') : '')

  if !isdirectory(l:target) && fnamemodify(l:source, ':e') != fnamemodify(l:target, ':e')
    edit
  endif

  call delete(l:source)
  execute bufnr(l:source) . 'bwipe!'

  return 1
endfunction

function! RmFile(target, bang)
  let l:target = expand(a:target)

  " Target file does not exist or is not writable
  if empty(glob(l:target))
    echohl WarningMsg | echo l:target . ': no such file' | echohl None
    return 0
  elseif isdirectory(a:target)
    if (a:bang ==# '!')
      " close all related buffers
      let target_bufs = filter(filter(range(1, bufnr('$')), 'buflisted(v:val)'),
                  \            "expand('#' . v:val . ':p') =~# fnamemodify(l:target, ':p')")
      for buffer in target_bufs
        execute 'bd!' . buffer
      endfor

      call delete(a:target, 'rf')
    else
    echohl WarningMsg
      echo l:target . ' is a directory (add ! to override)'
    echohl None
      return 0
    end
  elseif !filewritable(l:target)
    echohl WarningMsg | echo l:target . ': read-only file' | echohl WarningMsg
    return 0
  else
    " close buffer
    let l:target_buf = 1 + index(map(range(1, bufnr('$')),
                \                    "expand('#' . v:val . ':p')"),
                \                fnamemodify(l:target, ':p'))
    if buflisted(l:target_buf)
      if bufnr('%') == l:target_buf
        buffer #
      endif
      execute 'bd!' . l:target_buf
    endif

    call delete(a:target)
  endif

  return 1
endfunction

command! -nargs=1 -complete=file -bar -bang Mv call MoveFile('<args>', '<bang>')
command! -nargs=1 -complete=file -bar -bang Rm call RmFile('<args>', '<bang>')

" File Metadata ----------------------------------------------------------------

if exists('+fileformats') | set fileformats=unix,dos,mac | endif

if exists('+filetype') | filetype plugin indent on | endif

if exists('+encoding')
  set encoding=utf-8
  scriptencoding utf-8
endif

" Command Line Options ---------------------------------------------------------

cabbr <expr> %% fnameescape(expand('%:p:h'))        " shortcut: directory of current buffer
if exists('+ignorecase') | set ignorecase | endif   " Search with...
if exists('+smartcase')  | set smartcase  | endif   " ...smart case recognition
if exists('+wildignore') | set wildignore+=*/tmp/*,*.zip,*.swp,*.so | endif


" External Tools ---------------------------------------------------------------

" grep (ag)
call system('type ag')

if v:shell_error == 0
  if exists('+grepprg')    | set grepprg=ag\ --vimgrep\ $* | endif
  if exists('+grepformat') | set grepformat=%f:%l:%c:%m    | endif
endif

