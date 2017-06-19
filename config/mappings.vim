" CUSTOM KEY MAPPINGS ==========================================================

" Set leader & other variables
let mapleader = "\<Space>"
let maplocalleader = "\\"
if exists('+wildcharm') | set wildcharm=<C-z> | endif

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
              \            "expand('#' . v:val . ':p') =~# '^" .
              \              g:vim_home . "/config/.*\.vim'")
  for bufnr in config_bufs
    exec bufnr . 'buffer | update'
  endfor
  exec this_buf . 'buffer'
endfunction

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

" Disable Ex mode (http://www.bestofvim.com/tip/leave-ex-mode-good/)
nnoremap Q <Nop>

" Switch from Search to Replace super fast!
" nmap <expr> M ':%s/' . @/ . '//g<LEFT><LEFT>'
