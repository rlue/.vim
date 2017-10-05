function! vimrc#scroll_alt_window(mvmt)
  if a:mvmt == 'f'
    let mvmt = ''
  elseif a:mvmt == 'b'
    let mvmt = ''
  elseif a:mvmt == 'd'
    let mvmt = ''
  elseif a:mvmt == 'u'
    let mvmt = ''
  elseif a:mvmt == 'e'
    let mvmt = ''
  elseif a:mvmt == 'y'
    let mvmt = ''
  endif

  execute 'normal p' . mvmt . 'p'
endfunction
