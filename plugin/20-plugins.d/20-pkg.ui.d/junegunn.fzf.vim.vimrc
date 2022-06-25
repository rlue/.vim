" https://github.com/junegunn/fzf.vim 

let g:fzf_plugin_path =
      \ get(
      \   filter(
      \     [fnamemodify(resolve(exepath('fzf')), ':h:h'),
      \      fnamemodify(resolve(exepath('fzf')), ':h:h') . '/share/doc/fzf/examples'],
      \     '!empty(globpath(v:val, "/plugin/fzf.vim"))'
      \   ), 0
      \ )

if v:version >= 740 && !empty(g:fzf_plugin_path)
      \ && (!has('gui_running') || has('terminal'))
  Plug g:fzf_plugin_path
  Plug 'junegunn/fzf.vim'
endif
