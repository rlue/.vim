setlocal foldenable
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal foldexpr=FoldCSS(v:lnum)
setlocal foldtext=FoldTextCSS()

function! FoldCSS(lnum)
    let l:line = getline(a:lnum) | let l:nextline = getline(a:lnum + 1)
    if l:line =~# '^/\* #'
        return '>' . strlen(matchstr(l:line, '^#\+', 3))
    elseif l:nextline =~# '^/\* #'
        return (strlen(matchstr(l:nextline, '^#\+', 3)) - 1)
    elseif l:line =~# '{\( // .*\)\=$' ||
         \ (l:line =~# '{.\+}\( // .*\)\=$' && l:nextline =~# '^\s*$')
        return 'a1'
    elseif (l:line =~# '^\s*}$' && l:nextline !~# '^\s*$') ||
         \ (l:line =~# '^\s*$' && getline(a:lnum - 1) =~# '}$') ||
         \ (getline(a:lnum - 1) =~# '{.\+}\( // .*\)\=$' && l:line =~# '^\s*$')
        return 's1'
    else
        return '='
    endif
endfunction

function! FoldTextCSS()
    let l:heading = substitute(getline(v:foldstart),
                          \ '^/\* #\+ \| \*/\|^\s\+\| {.\+}\| [{}]', '', 'g')
    let l:heading = substitute(l:heading, '// \(.*\)', '(\1)', '')
    let l:indent  = repeat('  ', v:foldlevel - 1)
    let l:foldlen = v:foldend - v:foldstart + 1
    let l:filler  = repeat('-', 72 - strchars(l:indent . l:heading . l:foldlen))
    return l:indent . '+- ' . l:heading . ' ' . l:filler . '[' . l:foldlen . ']'
endfunction
