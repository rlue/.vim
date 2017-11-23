" Initializing variables for portability
let g:vim_home = expand('<sfile>:p:h')
let $MYVIMRC   = g:vim_home . '/vimrc'

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

" Navigation -------------------------------------------------------------------
" Smart j/k (move by display lines unless a count is provided)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Miscellaneous ----------------------------------------------------------------

" $MYVIMRC source/edit
nnoremap <Leader>ev :e $MYVIMRC<CR>

" Disable Ex mode (http://www.bestofvim.com/tip/leave-ex-mode-good/)
nnoremap Q <Nop>

" PLUGIN CONFIGURATION =========================================================
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

" manpager.vim -----------------------------------------------------------------
if filereadable($VIMRUNTIME . '/ftplugin/man.vim')
  let g:ft_man_folding_enable = 1
endif

" vim-dirvish ------------------------------------------------------------------
let g:loaded_netrwPlugin = 1 " Disable netrw

" vim-sensible -----------------------------------------------------------------
let g:syntax_on = 1

" UI ===========================================================================
" This section concerns vim's user interface.

" Colors & Highlighting --------------------------------------------------------
" Highlight search matches
if exists('+hlsearch')       | set hlsearch        | endif

" Folding ----------------------------------------------------------------------
set nofoldenable

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

" grep (repgrip/ag)
if exists('+grepprg') && exists('+grepformat')
  if executable('rg')
    let &grepprg = 'rg --vimgrep $*' 
  elseif executable('ag')
    let &grepprg = 'ag --vimgrep $*' 
  endif

  let &grepformat = '%f:%l:%c:%m'             
endif
