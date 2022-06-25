" https://github.com/ludovicchabant/vim-gutentags

if empty(globpath(&runtimepath, '/plugged/vim-gutentags')) | finish | endif

let g:gutentags_exclude_project_root = ['/usr/local', $HOME . '/.config']
let g:gutentags_file_list_command = {
      \   'markers': {
      \     '.git': 'git ls-files',
      \   },
      \ }
