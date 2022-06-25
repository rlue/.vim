" https://github.com/mhinz/vim-signify

if empty(globpath(&runtimepath, '/plugged/vim-signify')) | finish | endif

let g:signify_vcs_list = [ 'git' ]
