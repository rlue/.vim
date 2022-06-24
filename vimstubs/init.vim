# cache and data directories differ from those used for classic vim,
# as vimundo and viminfo formats are not compatible
let $VIM_CONFIG_HOME = expand('<sfile>:p:h')
let $VIM_CACHE_HOME  = expand('<sfile>:p:h') . '/cache'
let $VIM_DATA_HOME   = expand('<sfile>:p:h') . '/share'

source <sfile>:p:h:h/vimrc
