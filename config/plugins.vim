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
