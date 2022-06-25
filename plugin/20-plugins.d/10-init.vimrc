call plug#begin($VIM_DATA_HOME . '/plugged')

let s:pluginrc_glob = $VIM_CONFIG_HOME . '/plugin/20-plugins.d/20-pkg.*.d/**/*.vim'
let s:pluginrc_list = split(glob(s:pluginrc_glob, '\n'))
let s:pluginrc_names = map(s:pluginrc_list, 'split(v:val, "/")[-1]')
let s:plugin_ids = map(s:pluginrc_names, 'substitute(v:val[:-5], "\\.", "/", "")')

for repo in s:plugin_ids
  Plug repo
endfor
