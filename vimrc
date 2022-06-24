" PATHS ========================================================================
" XDG compliance (adapted from https://blog.joren.ga/tools/vim-xdg) ------------
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME . "/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME . "/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME . "/.local/share" | endif

if $VIMINIT =~ "source " . $XDG_CONFIG_HOME . "/vim/vimrc"
  if empty($VIM_CACHE_HOME)  | let $VIM_CACHE_HOME  = $XDG_CACHE_HOME . "/vim"  | endif
  if empty($VIM_CONFIG_HOME) | let $VIM_CONFIG_HOME = $XDG_CONFIG_HOME . "/vim" | endif
  if empty($VIM_DATA_HOME)   | let $VIM_DATA_HOME   = $XDG_DATA_HOME . "/vim"   | endif
else
  if empty($VIM_CACHE_HOME)  | let $VIM_CACHE_HOME  = expand('<sfile>:p:h') | endif
  if empty($VIM_CONFIG_HOME) | let $VIM_CONFIG_HOME = expand('<sfile>:p:h') | endif
  if empty($VIM_DATA_HOME)   | let $VIM_DATA_HOME   = expand('<sfile>:p:h') | endif
endif

set runtimepath+=$VIM_DATA_HOME
set packpath^=$VIM_DATA_HOME
set packpath+=$VIM_DATA_HOME/after

let g:netrw_home = $VIM_DATA_HOME
call mkdir($VIM_DATA_HOME . "/spell", 'p', 0700)
set viewdir=$VIM_DATA_HOME/view      | call mkdir(&viewdir, 'p', 0700)
set backupdir=$VIM_CACHE_HOME/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$VIM_CACHE_HOME/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$VIM_CACHE_HOME/undo     | call mkdir(&undodir,   'p', 0700)

if !has('nvim')
  let $MYVIMRC   = $VIM_CONFIG_HOME . '/vimrc'
  let $MYGVIMRC  = $VIM_CONFIG_HOME . '/gvimrc'

  let &runtimepath = substitute(&runtimepath, expand("$HOME/.vim"), $VIM_CONFIG_HOME, "g")
  let &packpath = substitute(&packpath, expand("$HOME/.vim"), $VIM_CONFIG_HOME, "g")
  set viminfofile=$VIM_CACHE_HOME/viminfo
else
  let $MYVIMRC   = $VIM_CONFIG_HOME . '/init.vim'
  let $MYGVIMRC  = $VIM_CONFIG_HOME . '/ginit.vim'
endif

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
if isdirectory($HOME . '/notes')
  nnoremap <Leader>en :e ~/notes/**/
endif
if filereadable($HOME . '/notes/ledger.bean')
  nnoremap <Leader>el :e ~/notes/ledger.bean<CR>
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
nnoremap <silent> <Leader>sv source $MYVIMRC <Bar>
            \ if has('gui_running') <Bar> source $MYGVIMRC <Bar> endif<Bar>
            \ if exists(':AirlineRefresh') <Bar> AirlineRefresh <Bar> endif<CR>

" Disable Ex mode (http://www.bestofvim.com/tip/leave-ex-mode-good/)
nnoremap Q <Nop>

" Switch from Search to Replace super fast!
" nmap <expr> M ':%s/' . @/ . '//g<LEFT><LEFT>'

" PLUGIN MANAGEMENT ============================================================
" One-time setup: Install vim-plug ---------------------------------------------
if empty(glob($VIM_DATA_HOME . '/site/autoload/plug.vim'))
  exec 'silent !curl -fLo ' . $VIM_DATA_HOME . '/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin($VIM_DATA_HOME . '/plugged')

" Colorschemes -----------------------------------------------------------------
Plug        'morhetz/gruvbox'
Plug        'cocopon/iceberg.vim'
Plug     'raphamorim/lucario'
Plug    'mhartington/oceanic-next'
Plug      'NLKNguyen/papercolor-theme'
Plug          'KKPMW/sacredforest-vim'
Plug       'junegunn/seoul256.vim'
Plug    'altercation/vim-colors-solarized'
Plug           'w0ng/vim-hybrid'

" Dev Tools --------------------------------------------------------------------
" Plug          'rust-lang/rust'
Plug          'tpope/vim-bundler'
Plug          'tpope/vim-dispatch'
Plug          'tpope/vim-fugitive' | Plug 'junegunn/gv.vim' | Plug 'tpope/vim-rhubarb' | Plug 'shumphrey/fugitive-gitlab.vim'
Plug          'fatih/vim-go'
Plug          'tpope/vim-rails'
Plug          'mhinz/vim-signify'

if (v:version >= 740) && executable('ctags') | Plug 'ludovicchabant/vim-gutentags' | endif
if (v:version >= 800) | Plug 'dense-analysis/ale' | endif
if exists('*py3eval') | Plug 'baverman/vial-http' | Plug 'baverman/vial' | endif

" Text Manipulation ------------------------------------------------------------
Plug         'mbbill/fencview'
Plug    'vim-scripts/ReplaceWithRegister'
Plug    'AndrewRadev/sideways.vim'
Plug    'AndrewRadev/splitjoin.vim'
Plug          'tpope/vim-commentary'
Plug       'junegunn/vim-easy-align'
Plug          'tpope/vim-sleuth'
Plug          'tpope/vim-speeddating'
Plug          'tpope/vim-surround'
Plug           'kana/vim-textobj-user' | Plug 'reedes/vim-textobj-quote'

" ftplugins --------------------------------------------------------------------
Plug         'othree/html5.vim'
Plug           'aklt/plantuml-syntax'
Plug         'hail2u/vim-css3-syntax'
Plug           'rlue/vim-daylog'
Plug           'rlue/vim-fold-js'
Plug           'rlue/vim-fold-rspec'
Plug        'jparise/vim-graphql'
Plug       'jamessan/vim-gnupg'
Plug       'pangloss/vim-javascript'
Plug      'MaxMEllon/vim-jsx-pretty'
Plug          'tpope/vim-liquid'
Plug       'hallison/vim-rdoc'
Plug           'rlue/vim-rspec', { 'branch': 'feature/visual_selection' }
Plug      'joker1007/vim-ruby-heredoc-syntax'
Plug  'slim-template/vim-slim'
Plug        'cespare/vim-toml'
Plug         'lervag/vimtex'

" UI ---------------------------------------------------------------------------
Plug       'junegunn/goyo.vim'
Plug       'junegunn/limelight.vim'
Plug    'vim-airline/vim-airline'
Plug    'vim-airline/vim-airline-themes'
Plug           'rlue/vim-barbaric'
Plug       'justinmk/vim-dirvish'
Plug          'tpope/vim-sleuth'
Plug       'powerman/vim-plugin-AnsiEsc'
Plug          'tpope/vim-repeat'
Plug          'tpope/vim-rsi'
Plug          'tpope/vim-sensible'
Plug          'tpope/vim-unimpaired'

if has('unix') | Plug 'tpope/vim-eunuch' | endif

let g:fzf_plugin_path =
      \ get(
      \   filter(
      \     [fnamemodify(resolve(exepath('fzf')), ':h:h'),
      \      fnamemodify(resolve(exepath('fzf')), ':h:h') . '/share/doc/fzf/examples'],
      \     '!empty(globpath(v:val, "/plugin/fzf.vim"))'
      \   ), 0
      \ )

if v:version >= 740 && !empty(g:fzf_plugin_path)
      \ && (!has('gui_running') || has('terminal'))
  Plug g:fzf_plugin_path | Plug 'junegunn/fzf.vim'
endif

call plug#end()

" One-time setup: Install plugins ----------------------------------------------
if empty(glob($VIM_DATA_HOME . '/plugged')) | PlugInstall | endif

" PLUGIN CONFIGURATION =========================================================
" ALE --------------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/ale.vim'))
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:ale_fix_on_save = 1
  nnoremap <Leader>at :ALEToggle<CR>
  nnoremap <Leader>ad :ALEDetail<CR>
  nnoremap <Leader>al :ALELint<CR>
  nnoremap <Leader>af :ALEFix<CR>

  let g:ale_javascript_eslint_use_global = 1
  let g:ale_javascript_eslint_options = 'run eslint'
  let g:ale_fixers = {
  \   'javascriptreact': ['eslint'],
  \   'javascript': ['eslint'],
  \ }
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

  if isdirectory($HOME . '/notes/daylog')
    let g:daylog_home = $HOME . '/notes/daylog'
  endif
endif

" vim-dirvish ------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/dirvish.vim'))
  " Disable netrw
  " let g:loaded_netrwPlugin = 1

  " Re-enable netrw's `gx` command
  " nnoremap gx :call
  "       \ netrw#BrowseX(expand(exists("g:netrw_gx") ? g:netrw_gx : '<cfile>'),
  "       \               netrw#CheckIfRemote())<CR>

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
  nnoremap <Leader>gm :GMove<CR>
  nnoremap <Leader>gr :Gread<CR>
  nnoremap <Leader>gd :Gvdiffsplit<CR>
  nnoremap <Leader>gs :Git<CR>
  nnoremap <Leader>gw :Gwrite<CR>
  nnoremap <Leader>gc :Git commit<CR>
  nnoremap <Leader>gC :Git commit --amend --no-edit<CR>
  nnoremap <Leader>gp :Git push<CR>
  nnoremap <Leader>gl :Gclog<CR>
  nnoremap <Leader>gb :Git blame<CR>

  " Clear out temporary buffers automatically
  " http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
  augroup vimrc_fugitive
    autocmd!
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END

  let g:fugitive_gitlab_domains = ['https://git.znuny.com']
endif

" vim-gutentags ----------------------------------------------------------------
if !empty(globpath(&runtimepath, '/plugin/gutentags.vim'))
  let g:gutentags_exclude_project_root = ['/usr/local', $HOME . '/.config']
  let g:gutentags_file_list_command = {
        \   'markers': {
        \     '.git': 'git ls-files',
        \   },
        \ }
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

" vimtex -----------------------------------------------------------------------
if !empty(globpath(&runtimepath, '/autoload/vimtex.vim'))
  let g:vimtex_view_method = 'mupdf'
  let g:tex_flavor = 'latex'
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
