" https://github.com/rlue/vim-rspec

if empty(globpath(&runtimepath, '/plugged/vim-rspec')) | finish | endif

augroup vimrc_rspec
  autocmd!
  autocmd FileType ruby call s:set_rspec_maps()
augroup END

function! s:set_rspec_maps()
  nnoremap <buffer> <LocalLeader>ss :call RunCurrentSpecFile()<CR>
  nnoremap <buffer> <LocalLeader>se :call RunExamples()<CR>
  vnoremap <buffer> <LocalLeader>se :call RunExamples()<CR>
  nnoremap <buffer> <LocalLeader>sr :call RunLastSpec()<CR>
  nnoremap <buffer> <LocalLeader>sa :call RunAllSpecs()<CR>
endfunction

if empty(globpath(&runtimepath, '/plugged/vim-dispatch')) | finish | endif

let g:rspec_command = 'Dispatch rspec {spec}'
