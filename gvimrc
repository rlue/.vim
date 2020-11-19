" GUI VIM CONFIGURATION ========================================================

" General ----------------------------------------------------------------------
set guioptions=                           " Disable GUI chrome 
set lines=999 columns=90                  " Maximize window height

" Colors -----------------------------------------------------------------------
let s:colorschemes = [
      \ "gruvbox",
      \ "iceberg",
      \ "OceanicNext",
      \ "sacredforest",
      \ "seoul256",
      \ "solarized",
      \ ]

let s:colorscheme_index = system(
      \ "awk -v min=0 -v max="
      \ . (len(s:colorschemes) - 1)
      \ . " 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'"
      \ )

execute "colorscheme " . s:colorschemes[s:colorscheme_index]
if s:colorschemes[s:colorscheme_index] == "PaperColor"
  set background=light
else
  set background=dark
endif

" Fonts ------------------------------------------------------------------------
if hostname() =~# 'herringbone'
  set guifont=Source\ Code\ Pro\ 14
elseif hostname() =~# 'shibori'
  set guifont=Source\ Code\ Pro\ 14
else
  set guifont=Source\ Code\ Pro\ Light:h18
endif

highlight Comment gui=italic

" On Windows -------------------------------------------------------------------
if has('win32')
  " Enable full-screen (https://github.com/derekmcloughlin/gvimfullscreen_win32)
  if !empty(globpath(&runtimepath, 'gvimfullscreen.dll'))
    map <F11> <Esc>:call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<CR>
  endif

  " Remap <M-Space> to Windows system menu, add <C-n> shortcut to minimize
  :map <M-Space> :simalt ~<CR>
  :map <C-n> :simalt ~n<CR>
endif
