" ~/.vimrc  single file, no plugins, sex_money_magick theme

" basics (work in every build, even vim-tiny)
set nocompatible
set encoding=utf-8
set number ruler showcmd
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set nosmartindent autoindent
set ignorecase smartcase incsearch nohlsearch
set noswapfile autowrite
set backspace=indent,eol,start
set scrolloff=5 splitright splitbelow
set wildmenu history=200 nrformats-=octal
set ttimeout ttimeoutlen=100

" mappings: Space is the leader, spelled out because vim-tiny ignores <leader>
iabbrev (l (line
iabbrev ## ######

" groff: plain = here, o-prefix = new line below
nnoremap <Space>p        i.PP<Esc>o
nnoremap <Space>op       o.PP<Esc>o
nnoremap <Space>i        i.IP<Esc>o
nnoremap <Space>oi       o.IP<Esc>o
nnoremap <Space>s        i.SH<Esc>o
nnoremap <Space>os       o.SH<Esc>o
nnoremap <Space>t        i.TL<Esc>o
nnoremap <Space>a        i.AU<Esc>o
xnoremap <Space>b        c.B "<C-r><C-r>""<Esc>
nnoremap <Space>eq       i.EQ<CR><CR>.EN<Esc>ki

" text
nnoremap <Space>u        :keeppatterns %s/[“”]/"/ge<Bar>keeppatterns %s/[‘’]/'/ge<Bar>keeppatterns %s/—/-/ge<CR>
nnoremap <Space>gq       gwip
nnoremap <Space>br       g$bi<CR><Esc>
nnoremap <Space><Space>  a<Space><Esc>

" comments
nnoremap <C-c>           I#<Esc>j
nnoremap <C-x>           :keeppatterns s/^\(\s*\)#/\1/e<CR>j
nnoremap <Space>hc       I<!--   --><Esc>hhhhi

" movement
nnoremap <C-j>           3j
nnoremap <C-k>           3k
xnoremap <C-j>           3j
xnoremap <C-k>           3k
nnoremap <C-h>           5b
nnoremap <C-l>           5w
nnoremap ]b              :bnext<CR>
nnoremap [b              :bprevious<CR>
nnoremap <Space>ft       :filetype detect<CR>

" everything below needs +eval, skipped silently on vim-tiny
if 1
  if has('syntax')
    filetype plugin indent on
    syntax on
  endif

  if has('persistent_undo')
    silent! call mkdir(expand('~/.vim/undo'), 'p')
    set undodir=~/.vim/undo//
    set undofile
  endif

  " truecolor only where the terminal says so; TTY and plain ssh get a fallback
  let s:truecolor = has('termguicolors')
        \ && ($COLORTERM =~# '^\(truecolor\|24bit\)$' || $TERM =~# 'kitty\|alacritty\|direct')

  set background=dark
  if s:truecolor
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    hi clear
    if exists('syntax_on')
      syntax reset
    endif

    " sex_money_magick: warm ember ground, esoteric accents,
    " rose (sex), gold (money), crystal violet (magick)
    hi Normal           guifg=#ccc2ad guibg=#15120d gui=NONE cterm=NONE
    hi NormalFloat      guifg=#ccc2ad guibg=#1d1a14 gui=NONE cterm=NONE
    hi Cursor           guifg=#15120d guibg=#b58af1 gui=NONE cterm=NONE
    hi CursorLine       guifg=NONE guibg=#1d1a14 gui=NONE cterm=NONE
    hi CursorColumn     guifg=NONE guibg=#1d1a14 gui=NONE cterm=NONE
    hi ColorColumn      guifg=NONE guibg=#1d1a14 gui=NONE cterm=NONE
    hi LineNr           guifg=#5c574d guibg=NONE gui=NONE cterm=NONE
    hi CursorLineNr     guifg=#d8af4c guibg=NONE gui=bold cterm=bold
    hi SignColumn       guifg=NONE guibg=#15120d gui=NONE cterm=NONE
    hi FoldColumn       guifg=#5c574d guibg=NONE gui=NONE cterm=NONE
    hi Folded           guifg=#7f796b guibg=#242018 gui=NONE cterm=NONE
    hi VertSplit        guifg=#5c574d guibg=NONE gui=NONE cterm=NONE
    hi EndOfBuffer      guifg=#15120d guibg=NONE gui=NONE cterm=NONE
    hi NonText          guifg=#5c574d guibg=NONE gui=NONE cterm=NONE
    hi SpecialKey       guifg=#5c574d guibg=NONE gui=NONE cterm=NONE
    hi Conceal          guifg=#7f796b guibg=NONE gui=NONE cterm=NONE
    hi Visual           guifg=NONE guibg=#3d3052 gui=NONE cterm=NONE
    hi VisualNOS        guifg=NONE guibg=#342b1b gui=NONE cterm=NONE
    hi Search           guifg=#15120d guibg=#d8af4c gui=NONE cterm=NONE
    hi IncSearch        guifg=#15120d guibg=#d08d5c gui=NONE cterm=NONE
    hi CurSearch        guifg=#15120d guibg=#d08d5c gui=NONE cterm=NONE
    hi MatchParen       guifg=#b58af1 guibg=#3d3052 gui=bold cterm=bold
    hi Directory        guifg=#7f9fc9 guibg=NONE gui=NONE cterm=NONE
    hi Title            guifg=#e3dbc9 guibg=NONE gui=bold cterm=bold
    hi Question         guifg=#8da46e guibg=NONE gui=NONE cterm=NONE
    hi MoreMsg          guifg=#8da46e guibg=NONE gui=NONE cterm=NONE
    hi ModeMsg          guifg=#ccc2ad guibg=NONE gui=bold cterm=bold
    hi ErrorMsg         guifg=#e26b67 guibg=NONE gui=NONE cterm=NONE
    hi WarningMsg       guifg=#b49a52 guibg=NONE gui=NONE cterm=NONE
    hi QuickFixLine     guifg=NONE guibg=#342b1b gui=NONE cterm=NONE
    hi StatusLine       guifg=#ccc2ad guibg=#1d1a14 gui=NONE cterm=NONE
    hi StatusLineNC     guifg=#7f796b guibg=#1d1a14 gui=NONE cterm=NONE
    hi StatusLineTerm   guifg=#ccc2ad guibg=#1d1a14 gui=NONE cterm=NONE
    hi StatusLineTermNC guifg=#7f796b guibg=#1d1a14 gui=NONE cterm=NONE
    hi TabLine          guifg=#7f796b guibg=#1d1a14 gui=NONE cterm=NONE
    hi TabLineFill      guifg=NONE guibg=#15120d gui=NONE cterm=NONE
    hi TabLineSel       guifg=#e3dbc9 guibg=#15120d gui=bold cterm=bold
    hi Pmenu            guifg=#ccc2ad guibg=#1d1a14 gui=NONE cterm=NONE
    hi PmenuSel         guifg=#e3dbc9 guibg=#342b1b gui=NONE cterm=NONE
    hi PmenuSbar        guifg=NONE guibg=#1d1a14 gui=NONE cterm=NONE
    hi PmenuThumb       guifg=NONE guibg=#5c574d gui=NONE cterm=NONE
    hi PmenuMatch       guifg=#d8af4c guibg=NONE gui=bold cterm=bold
    hi PmenuMatchSel    guifg=#d08d5c guibg=NONE gui=bold cterm=bold
    hi WildMenu         guifg=#e3dbc9 guibg=#342b1b gui=NONE cterm=NONE
    hi SpellBad         guifg=NONE guibg=NONE gui=undercurl cterm=undercurl guisp=#e26b67
    hi SpellCap         guifg=NONE guibg=NONE gui=undercurl cterm=undercurl guisp=#b49a52
    hi SpellLocal       guifg=NONE guibg=NONE gui=undercurl cterm=undercurl guisp=#75a69c
    hi SpellRare        guifg=NONE guibg=NONE gui=undercurl cterm=undercurl guisp=#a299ab
    hi DiffAdd          guifg=NONE guibg=#28291d gui=NONE cterm=NONE
    hi DiffChange       guifg=NONE guibg=#242627 gui=NONE cterm=NONE
    hi DiffDelete       guifg=#e26b67 guibg=#36201b gui=NONE cterm=NONE
    hi DiffText         guifg=NONE guibg=#333942 gui=NONE cterm=NONE
    hi Added            guifg=#8da46e guibg=NONE gui=NONE cterm=NONE
    hi Changed          guifg=#7f9fc9 guibg=NONE gui=NONE cterm=NONE
    hi Removed          guifg=#e26b67 guibg=NONE gui=NONE cterm=NONE
    hi Comment          guifg=#7f796b guibg=NONE gui=italic cterm=italic
    hi Constant         guifg=#8da46e guibg=NONE gui=NONE cterm=NONE
    hi String           guifg=#8da46e guibg=NONE gui=NONE cterm=NONE
    hi Character        guifg=#8da46e guibg=NONE gui=NONE cterm=NONE
    hi Number           guifg=#eb85b4 guibg=NONE gui=NONE cterm=NONE
    hi Boolean          guifg=#eb85b4 guibg=NONE gui=italic cterm=italic
    hi Float            guifg=#eb85b4 guibg=NONE gui=NONE cterm=NONE
    hi Identifier       guifg=#ccc2ad guibg=NONE gui=NONE cterm=NONE
    hi Function         guifg=#b3977f guibg=NONE gui=NONE cterm=NONE
    hi Statement        guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Keyword          guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Conditional      guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Repeat           guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Label            guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Exception        guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Operator         guifg=#b58af1 guibg=NONE gui=NONE cterm=NONE
    hi PreProc          guifg=#b49a52 guibg=NONE gui=NONE cterm=NONE
    hi Include          guifg=#b49a52 guibg=NONE gui=NONE cterm=NONE
    hi Define           guifg=#b49a52 guibg=NONE gui=NONE cterm=NONE
    hi Macro            guifg=#b49a52 guibg=NONE gui=NONE cterm=NONE
    hi PreCondit        guifg=#b49a52 guibg=NONE gui=NONE cterm=NONE
    hi Type             guifg=#7f9fc9 guibg=NONE gui=NONE cterm=NONE
    hi StorageClass     guifg=#7f9fc9 guibg=NONE gui=NONE cterm=NONE
    hi Structure        guifg=#7f9fc9 guibg=NONE gui=NONE cterm=NONE
    hi Typedef          guifg=#7f9fc9 guibg=NONE gui=NONE cterm=NONE
    hi Special          guifg=#b58af1 guibg=NONE gui=NONE cterm=NONE
    hi SpecialChar      guifg=#75a69c guibg=NONE gui=NONE cterm=NONE
    hi Tag              guifg=#d08d5c guibg=NONE gui=NONE cterm=NONE
    hi Delimiter        guifg=#7f796b guibg=NONE gui=NONE cterm=NONE
    hi SpecialComment   guifg=#7f796b guibg=NONE gui=bold cterm=bold
    hi Debug            guifg=#e26b67 guibg=NONE gui=NONE cterm=NONE
    hi Underlined       guifg=NONE guibg=NONE gui=underline cterm=underline
    hi Error            guifg=#e26b67 guibg=NONE gui=NONE cterm=NONE
    hi Todo             guifg=#15120d guibg=#d8af4c gui=bold cterm=bold

    let g:terminal_ansi_colors = ['#242018', '#e26b67', '#8da46e', '#d8af4c',
          \ '#7f9fc9', '#b58af1', '#75a69c', '#ccc2ad', '#7f796b', '#e6817e',
          \ '#9eb284', '#debb67', '#92add1', '#eb85b4', '#8ab3ab', '#e3dbc9']
  else
    try
      colorscheme habamax
    catch
      silent! colorscheme desert
    endtry
  endif
endif
