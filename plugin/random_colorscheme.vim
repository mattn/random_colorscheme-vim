let s:seed = 0
function! s:srand(seed) abort
  let s:seed = a:seed
endfunction

function! s:rand() abort
  let s:seed = s:seed * 214013 + 2531011
  return (s:seed < 0 ? s:seed - 0x80000000 : s:seed) / 0x10000 % 0x8000
endfunction

let s:colorschemes = map(split(globpath(&runtimepath, 'colors/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')
let s:switch_scheme_time = get(s:, 'switch_scheme_time', reltime())

function! s:random_colorscheme()
  if str2nr(reltimestr(reltime(s:switch_scheme_time))) > 3
    let n = s:rand() % len(s:colorschemes)
    execute 'colorscheme' fnameescape(s:colorschemes[n])
    let s:switch_scheme_time = reltime()
  endif
  call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
endfunction

augroup random_colorscheme
  au!
  autocmd CursorHold,CursorHoldI * call s:random_colorscheme()
augroup END
