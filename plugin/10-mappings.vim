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

" Switch
nnoremap <Leader>b :b <C-z>

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

" Miscellaneous ----------------------------------------------------------------

" $MYVIMRC source/edit
nnoremap <Leader>ev :e $VIM_CONFIG_HOME/vimrc<CR>

" Disable Ex mode (http://www.bestofvim.com/tip/leave-ex-mode-good/)
nnoremap Q <Nop>

" Switch from Search to Replace super fast!
nmap <expr> <Leader>s :%s/<C-v>///g<Left><Left>
vmap <expr> <Leader>s :%s/<C-v>///g<Left><Left>
