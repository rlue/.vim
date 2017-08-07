" GUI VIM CONFIGURATION ========================================================

" General ----------------------------------------------------------------------
set guioptions=                           " Disable GUI chrome 
set lines=999 columns=85                  " Maximize window height

" Colors -----------------------------------------------------------------------
if !empty(globpath(&rtp, 'colors/papercolor.vim')) | colorscheme papercolor | endif
if exists(':AirlineTheme') | AirlineTheme papercolor | endif
set bg=light

" Fonts ------------------------------------------------------------------------
if hostname() =~# 'sardanapalus'
  set guifont=PragmataPro:h14
elseif hostname() =~# 'liberte'
  set guifont=Source\ Code\ Pro:h17
else
  set guifont=Source\ Code\ Pro\ Light:h18
endif

highlight Comment gui=italic

" On Windows -------------------------------------------------------------------
if has('win32')
  " Fix garbled graphical menu text on Chinese (TW) Windows systems
  " if $COMPUTERNAME == "WEI-PC"
  "   so $VIMRUNTIME/delmenu.vim
  "   so $VIMRUNTIME/menu.vim
  "   language messages zh_TW.utf-8
  " endif

  " Enable full-screen (https://github.com/derekmcloughlin/gvimfullscreen_win32)
  if !empty(globpath(&runtimepath, 'gvimfullscreen.dll'))
    map <F11> <Esc>:call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<CR>
  endif

  " Remap <M-Space> to Windows system menu, add <C-n> shortcut to minimize
  :map <M-Space> :simalt ~<CR>
  :map <C-n> :simalt ~n<CR>
endif
