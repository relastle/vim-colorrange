#!/usr/bin/env bash
# if [[ -e ./vader.vim ]]; 

vim -Es -Nu <(cat << EOF
filetype off
set rtp+=$HOME/.local/share/nvim/plugged/vader.vim
set rtp+=$(pwd)/plugin
set rtp+=$(pwd)/autoload
filetype plugin indent on
syntax enable
EOF) -c 'Vader! tests/*'
