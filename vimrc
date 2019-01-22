" Initializing variables for portability
let g:vim_home = expand('<sfile>:p:h')
let $MYVIMRC   = g:vim_home . '/vimrc'
let $MYGVIMRC  = g:vim_home . '/gvimrc'

" STAGING ======================================================================

" MAPPINGS =====================================================================
" Base -------------------------------------------------------------------------
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"
if exists('+wildcharm') | set wildcharm=<C-z> | endif

" Text Manipulation ------------------------------------------------------------
" Y should be like C & D, not 'yy'
nnoremap Y y$

" Enable linewise repeat commands (via `.`) in Visual Mode
" (via http://vim.wikia.com/wiki/Repeat_command_on_each_line_in_visual_block)
vnoremap . :normal .<CR>

" Easy yank-put from system clipboard
if has('clipboard')
  nnoremap <Leader>p "+p
  nnoremap <Leader>P "+P
  nmap     <Leader>]p "+]p
  nmap     <Leader>]P "+]P
  nmap     <Leader>[p "+[p
  nmap     <Leader>[P "+[P
  nnoremap <Leader>y "+y
  nnoremap <Leader>Y "+y$
  nnoremap <Leader>d "+d
  nnoremap <Leader>D "+D
  vnoremap <Leader>p "+p
  vnoremap <Leader>P "+P
  vnoremap <Leader>y "+y
  vnoremap <Leader>Y "+y$
  vnoremap <Leader>d "+d
  vnoremap <Leader>D "+D
endif

" Easy whitespace
nnoremap <Leader>k    m`O<Esc>``
nnoremap <Leader>j    m`o<Esc>``
nnoremap <Leader>h    i <Esc>l
nnoremap <Leader>l    a <Esc>h
nnoremap <Leader><CR> i<CR><Esc>`.

" More text objects! 
for s:delimiter in [ '_', '-', '.', ':', ',', ';', '<bar>',
            \ '/', '<bslash>', '*', '+', '%', '`' ]
  execute 'xnoremap i' . s:delimiter . ' :<C-u>normal! T' . s:delimiter . 'vt' . s:delimiter . '<CR>'
  execute 'onoremap i' . s:delimiter . ' :normal vi' . s:delimiter . '<CR>'
  execute 'xnoremap a' . s:delimiter . ' :<C-u>normal! F' . s:delimiter . 'vf' . s:delimiter . '<CR>'
  execute 'onoremap a' . s:delimiter . ' :normal va' . s:delimiter . '<CR>'
endfor

" Perform characterwise paste on linewise registers
" per https://www.reddit.com/r/vim/comments/7egiyf/inverse_of_p_p/dq52ni0/
function! ZeroPaste(p)
  let l:original_reg = getreg(v:register)
  let l:original_reg_type = getregtype(v:register)
  let l:stripped_reg = substitute(l:original_reg, '\v^%(\n|\s)*(.{-})%(\n|\s)*$', '\1', '')
  let l:stripped_reg = (a:p ==# 'p' && getcurpos()[2] == strlen(getline('.'))) ? (' ' . l:stripped_reg) : (l:stripped_reg . ' ')
  call setreg(v:register, l:stripped_reg, 'c')
  exe 'normal "' . v:register . a:p
  call setreg(v:register, l:original_reg, l:original_reg_type)
endfunction
nnoremap <silent> zp :call ZeroPaste('p')<CR>
nnoremap <silent> zP :call ZeroPaste('P')<CR>
vnoremap <silent> zp :<C-u>call ZeroPaste('p')<CR>
vnoremap <silent> zP :<C-u>call ZeroPaste('P')<CR>

" Buffer Management ------------------------------------------------------------
" Save
nnoremap <Leader>w :update<CR>
nnoremap <Leader>W :wa<CR>

" Switch
nnoremap <Leader>b :ls<CR>:silent! b
nnoremap <Leader>B :browse oldfiles<CR>

" vimdiff
nnoremap du :diffupdate<CR>

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
if filereadable($HOME . '/Documents/Notes/Accounting/Ledger.bean')
  nnoremap <Leader>el :e ~/Documents/Notes/Accounting/Ledger.bean<CR>
endif

" Navigation -------------------------------------------------------------------

" Smart j/k (move by display lines unless a count is provided)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Find cursor
nnoremap <silent> <Leader><Leader> :call FlashLine()<CR>
function! FlashLine()
  for s:i in [30, 50, 30, 250]
    set cursorline!
    exec 'sleep ' . s:i . 'm'
    redraw
  endfor
endfunction

" Miscellaneous ----------------------------------------------------------------

" $MYVIMRC source/edit
nnoremap <Leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <Leader>sv :call UpdateRCs() <Bar> source $MYVIMRC <Bar>
            \ if has('gui_running') <Bar> source $MYGVIMRC <Bar> endif<Bar>
            \ if exists(':AirlineRefresh') <Bar> AirlineRefresh <Bar> endif<CR>

" Save all open vimrc buffers, then source vimrc
function! UpdateRCs()
  let l:this_buf    = bufnr('%')
  let l:open_bufs   = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let l:config_bufs = filter(l:open_bufs, 
              \           "expand('#' . v:val . ':p') =~# '^" . g:vim_home . "/g\\=vimrc'")
  for l:bufnr in l:config_bufs
    exec l:bufnr . 'buffer | update'
  endfor
  exec l:this_buf . 'buffer'
endfunction

" Disable Ex mode (http://www.bestofvim.com/tip/leave-ex-mode-good/)
nnoremap Q <Nop>

" Switch from Search to Replace super fast!
" nmap <expr> M ':%s/' . @/ . '//g<LEFT><LEFT>'

" PLUGIN MANAGEMENT ============================================================
" One-time setup: Install vim-plug ---------------------------------------------
if empty(glob(g:vim_home . '/autoload/plug.vim'))
  exec 'silent !curl -fLo ' . g:vim_home . '/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin()

" WIP --------------------------------------------------------------------------
if isdirectory($HOME . '/Projects/vim-getting-things-down')
  Plug '~/Projects/vim-getting-things-down'
endif

" Colorschemes -----------------------------------------------------------------
Plug        'morhetz/gruvbox'
Plug     'raphamorim/lucario'
Plug    'mhartington/oceanic-next'
Plug      'NLKNguyen/papercolor-theme'
Plug          'KKPMW/sacredforest-vim'
Plug       'junegunn/seoul256.vim'
Plug    'altercation/vim-colors-solarized'
Plug           'w0ng/vim-hybrid'

" Dev Tools --------------------------------------------------------------------
Plug       'junegunn/gv.vim'
Plug    'AndrewRadev/splitjoin.vim'
Plug          'tpope/vim-bundler'
Plug         'kchmck/vim-coffee-script'
Plug          'tpope/vim-commentary'
Plug          'tpope/vim-dispatch'
Plug    'AndrewRadev/vim-eco'
Plug           'rlue/vim-fold-rspec'
Plug          'tpope/vim-fugitive'
Plug       'pangloss/vim-javascript'
Plug          'tpope/vim-liquid'
Plug          'tpope/vim-rails'
Plug          'tpope/vim-rhubarb'
Plug           'rlue/vim-rspec', { 'branch': 'feature/visual_selection' }
Plug          'mhinz/vim-signify'
Plug  'slim-template/vim-slim'
Plug          'tpope/vim-sleuth'
Plug          'posva/vim-vue'
Plug         'lervag/vimtex'

if (v:version >= 740) && executable('ctags') | Plug 'ludovicchabant/vim-gutentags' | endif
if (v:version >= 800) | Plug 'w0rp/ale' | endif
if exists('*pyeval') | Plug 'baverman/vial-http' | Plug 'baverman/vial' | endif

" Text Manipulation ------------------------------------------------------------
Plug         'mbbill/fencview'
Plug    'AndrewRadev/sideways.vim'
Plug       'junegunn/vim-easy-align'
Plug          'tpope/vim-speeddating'
Plug          'tpope/vim-surround'
Plug           'kana/vim-textobj-user' | Plug 'reedes/vim-textobj-quote'

" ftplugins --------------------------------------------------------------------
Plug           'aklt/plantuml-syntax'
Plug    'nathangrigg/vim-beancount'
Plug       'jamessan/vim-gnupg'
Plug           'rlue/vim-daylog'
" Plug           'rlue/vim-getting-things-down'

" UI ---------------------------------------------------------------------------
Plug       'junegunn/goyo.vim'
Plug       'junegunn/limelight.vim'
Plug    'vim-airline/vim-airline'
Plug    'vim-airline/vim-airline-themes'
Plug       'justinmk/vim-dirvish'
Plug         'henrik/vim-indexed-search'
Plug       'powerman/vim-plugin-AnsiEsc'
Plug          'tpope/vim-repeat'
Plug          'tpope/vim-rsi'
Plug          'tpope/vim-sensible'
Plug          'tpope/vim-unimpaired'

" Mail -------------------------------------------------------------------------
Plug        'felipec/notmuch-vim'

if has('unix') | Plug 'tpope/vim-eunuch' | endif

if v:version >= 740 && executable('fzf') &&
      \ (!has('gui_running') || has('terminal'))
  Plug fnamemodify(resolve(exepath('fzf')), ':h:h') | Plug 'junegunn/fzf.vim'
endif

call plug#end()

" One-time setup: Install plugins ----------------------------------------------
if empty(glob(g:vim_home . '/plugged')) | PlugInstall | endif

" PLUGIN CONFIGURATION =========================================================
" ALE --------------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/ale.vim'))
  let g:ale_set_quickfix = 1
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  nnoremap <Leader>at :ALEToggle<CR>
  nnoremap <Leader>ad :ALEDetail<CR>
  nnoremap <Leader>al :ALELint<CR>
endif

" fzf.vim ----------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/fzf.vim'))
  nnoremap <Leader>zf :Files<CR>
  nnoremap <Leader>zb :Buffers<CR>
  nnoremap <Leader>zl :Lines<CR>
  nnoremap <Leader>zh :Helptags<CR>

  if executable('rg') && (exists(':Rg') != 2)
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%', '?'),
      \   <bang>0)
    nnoremap <Leader>zg :Rg<CR>
  endif
endif

" goyo -------------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/goyo.vim'))
  augroup vimrc_goyo
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <LocalLeader>f :Goyo<CR>
  augroup END
endif

" limelight -------------------------------------- ------------------------------
if !empty(globpath(&runtimepath, '/plugin/limelight.vim'))
  let g:limelight_default_coefficient = 0.7             " Set default shading
  if !empty(globpath(&runtimepath, '/plugin/goyo.vim')) " Tie Limelight to Goyo
    augroup vimrc_limelight
      autocmd!
      autocmd User GoyoEnter Limelight
      autocmd User GoyoLeave Limelight!
    augroup END
  endif
endif

" gv.vim -----------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/gv.vim'))
  nnoremap <Leader>gv :GV<CR>
endif

" manpager.vim -----------------------------------------------------------------
if filereadable($VIMRUNTIME . '/ftplugin/man.vim')
  let g:ft_man_folding_enable = 1
endif

" sideways.vim -----------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/sideways.vim'))
  " t as in Transpose
  nnoremap <Leader>t :SidewaysLeft<CR>
  nnoremap <Leader>T :SidewaysRight<CR>
endif

" vim-airline ------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/airline.vim'))
  let g:airline_powerline_fonts                   = 1
  let g:airline#extensions#whitespace#enabled     = 0
  let g:airline#extensions#tabline#enabled        = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1
endif

" vim-daylog -------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/ftplugin/daylog.vim'))
  nnoremap <Leader>ed :call daylog#enter_log()<CR>

  if isdirectory($HOME . '/Documents/Notes/Daylogs')
    let g:daylog_home = $HOME . '/Documents/Notes/Daylogs'
  endif
endif

" vim-dirvish ------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/dirvish.vim'))
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
if !empty(globpath(&runtimepath, '/plugin/dispatch.vim'))
  nnoremap <F9> :Dispatch<CR>

  augroup vimrc_dispatch
    autocmd!
    autocmd FileType ruby
          \ if expand('%:t:r') =~ '_spec$' | let b:dispatch = 'rspec %' | endif
  augroup END
endif

" vim-easy-align ---------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/easy_align.vim'))
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

" vim-fugitive -----------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/fugitive.vim'))
  nnoremap <Leader>gm :Gmove<CR>
  nnoremap <Leader>gr :Gread<CR>
  nnoremap <Leader>gd :Gdiff<CR>
  nnoremap <Leader>gs :Gstatus<CR>
  nnoremap <Leader>gw :Gwrite<CR>
  nnoremap <Leader>gc :Gcommit -m ""<Left>
  nnoremap <Leader>gp :Gpush<CR>
  nnoremap <Leader>gl :Glog<CR>
  nnoremap <Leader>gb :Gblame<CR>

  " Clear out temporary buffers automatically
  " http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
  augroup vimrc_fugitive
    autocmd!
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END
endif

" vim-gutentags ----------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/gutentags.vim'))
  let g:gutentags_exclude_project_root = ['/usr/local', $HOME . '/.config']
endif

" vim-rspec --------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/rspec.vim'))
  if !empty(globpath(&runtimepath, '/plugin/dispatch.vim'))
    let g:rspec_command = 'Dispatch rspec {spec}'
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

" vim-signify ------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/signify.vim'))
  let g:signify_vcs_list = [ 'git' ]
endif

" vim-textobj-quote ------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/textobj/quote.vim'))
  augroup vimrc_textobj_quote
    autocmd!
    autocmd FileType markdown,text,mail call textobj#quote#init()
  augroup END
endif

" UI ===========================================================================
" This section concerns vim's user interface.

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

if exists(':colorscheme') == 2 && !empty(globpath(&runtimepath, '/colors/hybrid.vim'))
  colorscheme hybrid
  highlight Normal ctermbg=none

  if !empty(globpath(&runtimepath, '/plugin/limelight.vim'))
    let g:limelight_conceal_ctermfg = 'darkgray'
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
" Wrap at word boundaries (instead of breaking words at textwidth)
if exists('+linebreak')   | set linebreak   | endif

" On long, wrapped lines, indent whole paragraph (instead of just first line)
if exists('+breakindent') | set breakindent | endif

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
    augroup pruneUndo
      autocmd!
      autocmd CursorHold,CursorHoldI * call pruneUndo#initialize(&undodir)
    augroup END
  endif
endif

" Encryption -------------------------------------------------------------------

if has('crypt-blowfish2') | set cryptmethod=blowfish2 | endif

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

" File Metadata ----------------------------------------------------------------

if exists('+modeline') | set modeline | endif
if exists('+fileformats') | set fileformats=unix,dos,mac | endif
if exists('+filetype') | filetype plugin indent on | endif
if exists('+encoding') | set encoding=utf-8 | scriptencoding utf-8 | endif

" Command Line Options ---------------------------------------------------------

cabbr <expr> %% fnameescape(expand('%:p:h'))        " shortcut: directory of current buffer
if exists('+ignorecase') | set ignorecase | endif   " Search with...
if exists('+smartcase')  | set smartcase  | endif   " ...smart case recognition
if exists('+wildignore') | set wildignore+=*.zip,*.swp,*.so | endif

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

" PER-MACHINE ==================================================================
" Helper functions -------------------------------------------------------------
function! s:sessionLaunchedOn(machine)
  if has('unix')
    if hostname() =~? a:machine | return 1 | endif
    if empty($SSH_CONNECTION) | return 0 | endif

    if !exists('s:dig_answer')
      let s:client_ip = split($SSH_CONNECTION)[0]
      let s:dig_answer = system('dig -x ' . s:client_ip . ' | grep -A1 "^;; ANSWER" | tail -n1')
    endif

    return s:dig_answer =~? a:machine
  elseif has('win32')
    return $COMPUTERNAME ==? a:machine
  endif
endfunction
