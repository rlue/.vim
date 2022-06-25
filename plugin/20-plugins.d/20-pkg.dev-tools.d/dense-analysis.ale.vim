" https://github.com/dense-analysis/ale

if empty(globpath(&runtimepath, '/plugged/ale')) | finish | endif

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_fix_on_save = 1
nnoremap <Leader>at :ALEToggle<CR>
nnoremap <Leader>ad :ALEDetail<CR>
nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>af :ALEFix<CR>

let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_options = 'run eslint'
let g:ale_fixers = {
      \   'javascriptreact': ['eslint'],
      \   'javascript': ['eslint'],
      \ }
