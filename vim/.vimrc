set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')
Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'ycm-core/YouCompleteMe'
call vundle#end()

" English stuff
ab (l (line

" Groff stuff
map <C-p> i.PP<ESC>o
map <C-o><C-p> o.PP<ESC>o
map <C-i> i.IP<ESC>o
map <C-o><C-i> o.IP<ESC>o
map <C-s> i.SH<ESC>o
map <C-o><C-s> o.SH<ESC>o
map <C-t> i.TL<ESC>o
map <C-a> i.AU<ESC>o
map <C-b> di.B "<ESC>pi"

map <C-j> jjj
" Map <C-k> to k x 3
map <C-k> kkk
" Map <C-h> to b x 5
map <C-h> bbbbb
" Map <C-l> to w x 5
map <C-l> wwwww

" Script comment line
map <C-c> I#<ESC>j
" Uncomment line
map <C-x> ^xj
" HTML comment line
map <C-v> I<!--   --><ESC>hhhhi

" Map Ctrl-e to new Equation in eqn syntax
map <C-e> i.EQ<return><return>.EN<ESC>ki

" Map Ctrl-b to :%s/“/"/g<return>
map <C-z> :%s/“/"/g<return>:%s/”/"/g<return>:%s/’/'/g<return>:%s/—/-/g<return>

" Map Ctrl-f to gqip (format paragraph)
map <C-F> m9gqip`9

" Map # (shift + 3) tp detect filetype
map # :filetype detect<return>

" Create empty space
map s a<space><ESC>

" Write buffer not fitting on to the current line to the next line
map ! g$bi<return><ESC>

" Map Ctrl-n to buffer next and Ctrl-m to buffer previous
map <C-n> :bn<return>
map <C-m> :bp<return>

" Create function prototype
"map <C-X> JA;<ESC>jv%d

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
