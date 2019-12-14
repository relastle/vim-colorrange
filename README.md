# vim-colorrange

:rainbow: Edit 24 bit color code instantaneously like default &lt;C-a> and &lt;C-x>

## Demonstration

## Installation

Using vim-plug (https://github.com/junegunn/vim-plug)

```vim
Plug 'relastle/vim-colorrange'
```

## USAGE

It is recommended that these commands are mapped to keys
that can be hit continuously.

As `ColorrangeIncrement` and `ColorrangeDecrement` behave like vim's default
`<C-a>` and `<C-x>` respectively, mappings as follows might be natural.

```vim
nnoremap <A-a> :ColorrangeIncrement<CR>
nnoremap <A-x> :ColorrangeDecrement<CR>
```

pls refer `:help vim-colorrange` for more details.


## [LICENSE](./LICENSE)
