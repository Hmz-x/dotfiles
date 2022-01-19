call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

call plug#end()

" Map Ctrl-b to :%s/“/"/g<return>
map <C-b> :%s/“/"/g<return>:%s/”/"/g<return>

" Map Ctrl-f to gqip (format paragraph)
map <C-F> gqip

" Map # (shift + 3) tp detect filetype
map # :filetype detect<return>

" Create empty space
map s a<space><ESC>

" Write buffer not fitting on to the current line to the next line
map ! g$bi<return><ESC>

" Create { } for function and enter insert mode 
"map <C-P> si<return><backspace>{<return><return>}<ESC>ki<tab>

" Create function prototype
"map <C-X> JA;<ESC>jv%d

" Comment out line using '#'
"map <C-H> I#<ESC>j 

ab ## ######

set nocompatible  
filetype off

set nocp
syntax on
set tabstop=4 softtabstop=4 shiftwidth=4
set textwidth=90
set nu
set noswapfile
set smartcase
set incsearch
set nosmartindent
set nohls
set autowrite

highlight ColorColumn ctermbg=0 guibg=lightgrey
colorscheme gruvbox
set background=dark
set encoding=utf-8
