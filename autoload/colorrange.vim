" File              : colorrange.vim
" Author            : Hiroki Konishi <relastle@gmail.com>
" Date              : 23.11.2019
" Last Modified Date: 14.12.2019
" Last Modified By  : Hiroki Konishi <relastle@gmail.com>

function colorrange#modify_current_line_color(count, operator) abort
  let l:pos = getpos('.')
  let l:cursor_index = l:pos[2]
  let l:line = getline(l:pos[1])
  let l:color_code_index = colorrange#get_color_code_index(l:line)
  if l:color_code_index < 0
    return
  endif
  let l:cursor_status = colorrange#get_cursor_status(l:line, l:cursor_index-1)
  if l:cursor_status < 0
    return
  endif

  let l:target_color_code = colorrange#find_color_code(l:line)

  if l:cursor_status == 0
    let l:arg_input = a:operator . '#' . repeat(printf('%02x', min([a:count, 255])), 3)
  else
    let l:arg_input = a:operator . '#' . repeat('0', l:cursor_status - 1) . a:count . repeat('0', 6 - l:cursor_status)
  endif
  let l:res_color_code = colorrange#change_color(l:target_color_code, l:arg_input)
  let l:res_line = l:line[ : l:color_code_index] . l:res_color_code . l:line[l:color_code_index+7 :]
  call setline(l:pos[1], l:res_line)
endfunction

function! colorrange#plus(hexcolor_x, hexcolor_y) abort
  let l:res_decimal = str2nr(a:hexcolor_x, 16) + str2nr(a:hexcolor_y, 16)
  let l:res_decimal = min([l:res_decimal, 255])
  return printf('%02x', l:res_decimal)
endfunction


function! colorrange#minus(hexcolor_x, hexcolor_y) abort
  let l:res_decimal = str2nr(a:hexcolor_x, 16) - str2nr(a:hexcolor_y, 16)
  let l:res_decimal = max([l:res_decimal, 0])
  return printf('%02x', l:res_decimal)
endfunction


function! colorrange#get_color_code_index(line) abort
  return match(a:line, '\v#[0-9a-f]{6}')
endfunction


" Get 24-bit color code from a given line
" Returns:
" - color code (i.g. 'aaaaaa')
function! colorrange#find_color_code(line) abort
  let l:match_index = colorrange#get_color_code_index(a:line)
  if l:match_index < 0
    return ''
  endif
  let l:color_code = a:line[l:match_index+1 : l:match_index+6]
  return l:color_code
endfunction

" Get current cursor index on color code context
" Args:
" - line
" - cursor index of line (0-index-based)
" Returns:
" - -1: color code not found or after color code
" - 0 : before color code ( |'#aaaaaa')
" - 1 : on R-2nd digit     ( '#|aaaaa')
" - 2 : on R-1st digit     ( '#a|aaaa')
" - 3 : on G-2nd digit     ( '#aa|aaa')
" - 4 : on G-1st digit     ( '#aaa|aa')
" - 5 : on B-2nd digit     ( '#aaaa|a')
" - 6 : on B-1st digit     ( '#aaaaa|')
function! colorrange#get_cursor_status(line, cursor_index) abort
  let l:match_index = colorrange#get_color_code_index(a:line)
  if l:match_index < 0
    return -1
  endif
  if a:cursor_index > l:match_index + 6
    return -1
  endif
  if a:cursor_index < l:match_index
    return 0
  endif
  return a:cursor_index - l:match_index
endfunction

function! colorrange#divide_into_rgb(color_code) abort
  return [
        \ a:color_code[0:1],
        \ a:color_code[2:3],
        \ a:color_code[4:5],
        \ ]
endfunction


" Validate the 24bit color code (for color code operation)
" It returns
" - only color code (i.g. 'fafafa')
" - operator (+1 for plus -1 for minus)
function! colorrange#validate_color_code(input) abort
  let l:match_index = match(a:input, '\v^[+-]?#[0-9a-f]{6}$')
  if l:match_index < 0
    echoerr 'input color code is invalid'
    return ['', 0]
  endif

  if a:input =~# '-'
    return [colorrange#find_color_code(a:input), -1]
  endif
  return [colorrange#find_color_code(a:input), +1]
endfunction


" Change color code using input
" Args:
" - target_color_code: 'aaaaaa'
" - arg_color_input: '-#111111'
" Returns:
" - '999999'
function! colorrange#change_color(target_color_code, arg_color_input) abort
  " parse arg color code
  let l:validation_res = colorrange#validate_color_code(a:arg_color_input)
  let l:arg_color_code = l:validation_res[0]
  if l:arg_color_code ==# ''
    return ''
  endif
  let l:arg_operation_code = l:validation_res[1]

  " divide into rgb [ 'aa', 'aa', 'aa' ]
  let l:target_rgb = colorrange#divide_into_rgb(a:target_color_code)
  let l:arg_rgb = colorrange#divide_into_rgb(l:arg_color_code)

  if l:arg_operation_code == -1
    let l:Operation = function('colorrange#minus')
  else
    let l:Operation = function('colorrange#plus')
  endif

  let l:res_r = l:Operation(l:target_rgb[0], l:arg_rgb[0])
  let l:res_g = l:Operation(l:target_rgb[1], l:arg_rgb[1])
  let l:res_b = l:Operation(l:target_rgb[2], l:arg_rgb[2])
  return printf('%s%s%s', l:res_r, l:res_g, l:res_b)
endfunction
