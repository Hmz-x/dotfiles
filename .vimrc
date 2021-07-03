call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe'
Plug 'morhetz/gruvbox'

call plug#end()

map s a<space><ESC>
map ! g$bi<return><ESC>
map F si<return><backspace>{<return><return>}<ESC>ki<tab>

set nocompatible  
filetype off

set nocp
syntax on
set tabstop=4 softtabstop=4 shiftwidth=4
set nu
set noswapfile
set smartcase
set incsearch
set nosmartindent
set nohls

highlight ColorColumn ctermbg=0 guibg=lightgrey

colorscheme gruvbox
set background=dark
let g:ycm_global_ycm_extra_conf='/home/hkm/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
set encoding=utf-8
