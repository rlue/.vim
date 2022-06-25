" PER-MACHINE ==================================================================
" Helper functions -------------------------------------------------------------
function! s:sessionLaunchedOn(machine)
  if has('unix')
    if hostname() =~? a:machine | return 1 | endif
    if empty($SSH_CONNECTION) | return 0 | endif

    if !exists('s:dig_answer')
      let s:client_ip = split($SSH_CONNECTION)[0]
      let s:dig_answer = system('dig -x ' . s:client_ip . ' | grep -A1 "^;; ANSWER" | tail -n1')
    endif

    return s:dig_answer =~? a:machine
  elseif has('win32')
    return $COMPUTERNAME ==? a:machine
  endif
endfunction
