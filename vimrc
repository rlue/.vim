" PATHS ========================================================================
" Why can't we move this into the plugins/ directory?
"
" Because vim only looks there based on &runtimepath (which is set here).
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
silent! call mkdir($VIM_DATA_HOME . "/spell", 'p', 0700)
set viewdir=$VIM_DATA_HOME/view      | silent! call mkdir(&viewdir, 'p', 0700)
set backupdir=$VIM_CACHE_HOME/backup | silent! call mkdir(&backupdir, 'p', 0700)
set directory=$VIM_CACHE_HOME/swap   | silent! call mkdir(&directory, 'p', 0700)
set undodir=$VIM_CACHE_HOME/undo     | silent! call mkdir(&undodir,   'p', 0700)

if !has('nvim')
  let $MYVIMRC   = $VIM_CONFIG_HOME . '/vimrc'
  let $MYGVIMRC  = $VIM_CONFIG_HOME . '/gvimrc'

  let &runtimepath = substitute(&runtimepath, expand("$HOME/.vim"), $VIM_CONFIG_HOME, "g")
  let &packpath = substitute(&packpath, expand("$HOME/.vim"), $VIM_CONFIG_HOME, "g")
  if has('&viminfofile') | set viminfofile=$VIM_CACHE_HOME/viminfo | endif
endif

" PLUGINS ======================================================================
" Why do we have to manually source all these files?
"
" I don't know, but plugins don't get loaded otherwise!
" Maybe `plug#begin()` / `plug#end()` have to be invoked
" earlier in the startup process than the `plugins/` directory gets run
for vimplug_rc in split(glob($VIM_CONFIG_HOME . '/plugin/20-plugins.d/**/*.vimrc'), '\n')
  exec 'source ' . vimplug_rc
endfor
