if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"         | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"        | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share"   | endif
let $VIM_CACHE_HOME  = $XDG_CACHE_HOME . "/nvim"
let $VIM_CONFIG_HOME = $XDG_CONFIG_HOME . "/nvim"
let $VIM_DATA_HOME   = $XDG_DATA_HOME . "/nvim"

source <sfile>:p:h/vimrc
