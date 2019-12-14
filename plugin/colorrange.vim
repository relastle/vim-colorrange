" File              : colorrange.vim
" Author            : Hiroki Konishi <relastle@gmail.com>
" Date              : 23.11.2019
" Last Modified Date: 14.12.2019
" Last Modified By  : Hiroki Konishi <relastle@gmail.com>

if exists('loaded_plugin_vim_colorrange') || &compatible
    finish
endif
let loaded_plugin_vim_colorrange=1

function s:increment() abort
  return colorrange#modify_current_line_color('+')
endfunction

function s:decrement() abort
  return colorrange#modify_current_line_color('-')
endfunction


command! ColorrangeIncrement call s:increment()
command! ColorrangeDecrement call s:decrement()
