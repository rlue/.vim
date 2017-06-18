let liquid_ext = expand('%:e:e')
if liquid_ext =~? '\vs?css'
  set commentstring=/*%s*/
elseif liquid_ext =~? '\v(ht|x)ml'
  set commentstring=<!--%s-->
elseif liquid_ext =~? 'js'
  set commentstring=//%s
elseif liquid_ext =~? 'md'
  set commentstring=>\ %s
endif

