" File              : colorrange.vim
" Author            : Hiroki Konishi <relastle@gmail.com>
" Date              : 23.11.2019
" Last Modified Date: 14.12.2019
" Last Modified By  : Hiroki Konishi <relastle@gmail.com>

if exists('loaded_plugin_vim_colorrange') || &compatible
    finish
endif
let loaded_plugin_vim_colorrange=1

" Get the count prefixed agains Ex command
function s:get_given_count(count)
  if a:count == 0
    return 1
  else
    return a:count - line('.') + 1
  endif
endfunction

function s:increment(count) abort
  let l:count = s:get_given_count(a:count)
  return colorrange#modify_current_line_color(l:count, '+')
endfunction

function s:decrement(count) abort
  let l:count = s:get_given_count(a:count)
  return colorrange#modify_current_line_color(l:count, '-')
endfunction


command! -count ColorrangeIncrement call s:increment(<count>)
command! -count ColorrangeDecrement call s:decrement(<count>)
