#!/usr/bin/env bash
if [[ ! -e ./vader.vim ]]; then
    git clone https://github.com/junegunn/vader.vim
fi

nvim -Es -u <(cat << EOF
filetype off
set rtp+=$(pwd)/vader.vim
set rtp+=$(pwd)/plugin
set rtp+=$(pwd)/autoload
filetype plugin indent on
syntax enable
EOF) -c 'Vader! tests/*'
