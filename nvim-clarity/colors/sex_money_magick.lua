-- sex_money_magick
-- warm ember ground, esoteric accents, plus three magic colors:
-- rose (sex), gold (money), crystal violet (magick)

vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' == 1 then vim.cmd 'syntax reset' end
vim.o.background = 'dark'
vim.g.colors_name = 'sex_money_magick'

local c = {
  -- ground
  bg = '#15120d',
  surface = '#1d1a14', -- cursor line, popups, statusline
  raised = '#242018', -- folds
  visual = '#342b1b', -- popup selection, references
  line = '#5c574d', -- line numbers, borders
  comment = '#7f796b',
  fg = '#ccc2ad',
  bright = '#e3dbc9',

  -- esoteric accents
  keyword = '#d08d5c', -- rubric
  string = '#8da46e', -- green wash
  ident = '#b3977f', -- iron-gall ink
  type = '#7f9fc9', -- lapis blue
  preproc = '#b49a52', -- ochre
  special = '#a299ab', -- faded violet
  cyan = '#75a69c', -- verdigris
  red = '#e26b67', -- errors only

  -- magic
  rose = '#eb85b4', -- sex: numbers, booleans, builtins
  gold = '#d8af4c', -- money: search, line number, matches
  violet = '#b58af1', -- magick: operators, cursor, brackets
  glow = '#3d3052', -- selection

  -- diff backgrounds
  diff_add = '#28291d',
  diff_change = '#242627',
  diff_delete = '#36201b',
  diff_text = '#333942',
}

-- terminal colors, same 16 as kitty and alacritty
local ansi = {
  '#242018',
  '#e26b67',
  '#8da46e',
  '#d8af4c',
  '#7f9fc9',
  '#b58af1',
  '#75a69c',
  '#ccc2ad',
  '#7f796b',
  '#e6817e',
  '#9eb284',
  '#debb67',
  '#92add1',
  '#eb85b4',
  '#8ab3ab',
  '#e3dbc9',
}

local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end
local link = function(group, target) vim.api.nvim_set_hl(0, group, { link = target }) end

-- editor ---------------------------------------------------------------
hl('Normal', { fg = c.fg, bg = c.bg })
hl('NormalNC', { fg = c.fg, bg = c.bg })
hl('NormalFloat', { fg = c.fg, bg = c.surface })
hl('FloatBorder', { fg = c.line, bg = c.surface })
hl('FloatTitle', { fg = c.bright, bg = c.surface, bold = true })
hl('Cursor', { fg = c.bg, bg = c.violet })
hl('CursorLine', { bg = c.surface })
hl('CursorColumn', { bg = c.surface })
hl('ColorColumn', { bg = c.surface })
hl('LineNr', { fg = c.line })
hl('CursorLineNr', { fg = c.gold, bold = true })
hl('SignColumn', { bg = c.bg })
hl('FoldColumn', { fg = c.line })
hl('Folded', { fg = c.comment, bg = c.raised })
hl('VertSplit', { fg = c.line })
hl('WinSeparator', { fg = c.line })
hl('EndOfBuffer', { fg = c.bg })
hl('NonText', { fg = c.line })
hl('Whitespace', { fg = c.line })
hl('SpecialKey', { fg = c.line })
hl('Conceal', { fg = c.comment })
hl('Visual', { bg = c.glow })
hl('VisualNOS', { bg = c.visual })
hl('Search', { fg = c.bg, bg = c.gold })
hl('IncSearch', { fg = c.bg, bg = c.keyword })
link('CurSearch', 'IncSearch')
hl('Substitute', { fg = c.bg, bg = c.keyword })
hl('MatchParen', { fg = c.violet, bg = c.glow, bold = true })
hl('Directory', { fg = c.type })
hl('Title', { fg = c.bright, bold = true })
hl('Question', { fg = c.string })
hl('MoreMsg', { fg = c.string })
hl('ModeMsg', { fg = c.fg, bold = true })
hl('ErrorMsg', { fg = c.red })
hl('WarningMsg', { fg = c.preproc })
hl('QuickFixLine', { bg = c.visual })

hl('StatusLine', { fg = c.fg, bg = c.surface })
hl('StatusLineNC', { fg = c.comment, bg = c.surface })
hl('TabLine', { fg = c.comment, bg = c.surface })
hl('TabLineFill', { bg = c.bg })
hl('TabLineSel', { fg = c.bright, bg = c.bg, bold = true })
hl('WinBar', { fg = c.comment })
hl('WinBarNC', { fg = c.line })

hl('Pmenu', { fg = c.fg, bg = c.surface })
hl('PmenuSel', { fg = c.bright, bg = c.visual })
hl('PmenuSbar', { bg = c.surface })
hl('PmenuThumb', { bg = c.line })
hl('PmenuMatch', { fg = c.gold, bold = true })
hl('PmenuMatchSel', { fg = c.keyword, bold = true })
hl('WildMenu', { fg = c.bright, bg = c.visual })

hl('SpellBad', { sp = c.red, undercurl = true })
hl('SpellCap', { sp = c.preproc, undercurl = true })
hl('SpellLocal', { sp = c.cyan, undercurl = true })
hl('SpellRare', { sp = c.special, undercurl = true })

hl('DiffAdd', { bg = c.diff_add })
hl('DiffChange', { bg = c.diff_change })
hl('DiffDelete', { fg = c.red, bg = c.diff_delete })
hl('DiffText', { bg = c.diff_text })
hl('Added', { fg = c.string })
hl('Changed', { fg = c.type })
hl('Removed', { fg = c.red })

-- syntax ---------------------------------------------------------------
hl('Comment', { fg = c.comment, italic = true })
hl('Constant', { fg = c.string })
hl('String', { fg = c.string })
hl('Character', { fg = c.string })
hl('Number', { fg = c.rose })
hl('Boolean', { fg = c.rose, italic = true })
hl('Float', { fg = c.rose })
hl('Identifier', { fg = c.fg })
hl('Function', { fg = c.ident })
hl('Statement', { fg = c.keyword })
hl('Keyword', { fg = c.keyword })
hl('Conditional', { fg = c.keyword })
hl('Repeat', { fg = c.keyword })
hl('Label', { fg = c.keyword })
hl('Exception', { fg = c.keyword })
hl('Operator', { fg = c.violet })
hl('PreProc', { fg = c.preproc })
hl('Include', { fg = c.preproc })
hl('Define', { fg = c.preproc })
hl('Macro', { fg = c.preproc })
hl('PreCondit', { fg = c.preproc })
hl('Type', { fg = c.type })
hl('StorageClass', { fg = c.type })
hl('Structure', { fg = c.type })
hl('Typedef', { fg = c.type })
hl('Special', { fg = c.violet })
hl('SpecialChar', { fg = c.cyan })
hl('Tag', { fg = c.keyword })
hl('Delimiter', { fg = c.comment })
hl('SpecialComment', { fg = c.comment, bold = true })
hl('Debug', { fg = c.red })
hl('Underlined', { underline = true })
hl('Error', { fg = c.red })
hl('Todo', { fg = c.bg, bg = c.gold, bold = true })

-- treesitter (only where the classic link isn't right) ----------------
link('@variable', 'Identifier')
hl('@variable.builtin', { fg = c.rose, italic = true })
hl('@variable.parameter', { fg = c.fg, italic = true })
hl('@variable.member', { fg = c.fg })
hl('@property', { fg = c.fg })
link('@constant', 'Constant')
link('@number', 'Number')
link('@number.float', 'Float')
link('@boolean', 'Boolean')
hl('@constant.builtin', { fg = c.rose, italic = true })
link('@module', 'Type')
link('@string.escape', 'SpecialChar')
link('@string.regexp', 'SpecialChar')
link('@string.special', 'SpecialChar')
hl('@string.special.url', { fg = c.type, underline = true })
link('@function.builtin', 'Function')
link('@function.call', 'Function')
link('@function.method', 'Function')
link('@function.macro', 'Macro')
link('@constructor', 'Type')
link('@keyword.function', 'Keyword')
link('@keyword.return', 'Keyword')
link('@keyword.import', 'Include')
link('@keyword.directive', 'PreProc')
link('@type.builtin', 'Type')
link('@punctuation.delimiter', 'Delimiter')
link('@punctuation.bracket', 'Delimiter')
hl('@punctuation.special', { fg = c.cyan })
hl('@tag', { fg = c.keyword })
hl('@tag.attribute', { fg = c.ident })
hl('@tag.delimiter', { fg = c.comment })
hl('@markup.heading', { fg = c.bright, bold = true })
hl('@markup.strong', { bold = true })
hl('@markup.italic', { italic = true })
hl('@markup.link', { fg = c.type })
hl('@markup.link.url', { fg = c.type, underline = true })
hl('@markup.raw', { fg = c.string })
hl('@markup.list', { fg = c.keyword })
hl('@markup.quote', { fg = c.comment, italic = true })
link('@diff.plus', 'Added')
link('@diff.minus', 'Removed')
link('@diff.delta', 'Changed')

-- lsp / diagnostics ----------------------------------------------------
hl('DiagnosticError', { fg = c.red })
hl('DiagnosticWarn', { fg = c.preproc })
hl('DiagnosticInfo', { fg = c.type })
hl('DiagnosticHint', { fg = c.cyan })
hl('DiagnosticOk', { fg = c.string })
hl('DiagnosticUnderlineError', { sp = c.red, undercurl = true })
hl('DiagnosticUnderlineWarn', { sp = c.preproc, undercurl = true })
hl('DiagnosticUnderlineInfo', { sp = c.type, undercurl = true })
hl('DiagnosticUnderlineHint', { sp = c.cyan, undercurl = true })
hl('DiagnosticVirtualTextError', { fg = c.red, bg = c.diff_delete })
hl('DiagnosticVirtualTextWarn', { fg = c.preproc, bg = c.surface })
hl('DiagnosticVirtualTextInfo', { fg = c.type, bg = c.surface })
hl('DiagnosticVirtualTextHint', { fg = c.cyan, bg = c.surface })
hl('LspReferenceText', { bg = c.visual })
hl('LspReferenceRead', { bg = c.visual })
hl('LspReferenceWrite', { bg = c.visual, underline = true })
hl('LspInlayHint', { fg = c.line, italic = true })
hl('LspSignatureActiveParameter', { fg = c.keyword, bold = true })

-- plugins LazyVim ships with -------------------------------------------
hl('GitSignsAdd', { fg = c.string })
hl('GitSignsChange', { fg = c.type })
hl('GitSignsDelete', { fg = c.red })
hl('WhichKey', { fg = c.keyword })
hl('WhichKeyGroup', { fg = c.type })
hl('WhichKeyDesc', { fg = c.fg })
hl('WhichKeySeparator', { fg = c.line })
link('WhichKeyNormal', 'NormalFloat')
hl('FlashLabel', { fg = c.bg, bg = c.violet, bold = true })
hl('FlashMatch', { fg = c.bright, bg = c.visual })
hl('FlashBackdrop', { fg = c.line })
hl('SnacksIndent', { fg = c.surface })
hl('SnacksIndentScope', { fg = c.line })
hl('SnacksPickerMatch', { fg = c.keyword, bold = true })
hl('SnacksPickerDir', { fg = c.comment })
hl('SnacksPickerFile', { fg = c.fg })
hl('SnacksDashboardHeader', { fg = c.violet })
hl('SnacksDashboardKey', { fg = c.preproc })
hl('SnacksDashboardDesc', { fg = c.fg })
hl('SnacksDashboardIcon', { fg = c.ident })
hl('BlinkCmpMenu', { fg = c.fg, bg = c.surface })
hl('BlinkCmpMenuBorder', { fg = c.line, bg = c.surface })
hl('BlinkCmpMenuSelection', { bg = c.visual })
hl('BlinkCmpLabelMatch', { fg = c.gold, bold = true })
hl('BlinkCmpKind', { fg = c.type })
hl('BlinkCmpDoc', { fg = c.fg, bg = c.surface })
hl('BlinkCmpDocBorder', { fg = c.line, bg = c.surface })
hl('TroubleNormal', { fg = c.fg, bg = c.bg })
hl('NoiceCmdlinePopupBorder', { fg = c.line })
hl('NoiceCmdlineIcon', { fg = c.keyword })
hl('MiniIconsAzure', { fg = c.type })
hl('MiniIconsBlue', { fg = c.type })
hl('MiniIconsCyan', { fg = c.cyan })
hl('MiniIconsGreen', { fg = c.string })
hl('MiniIconsGrey', { fg = c.comment })
hl('MiniIconsOrange', { fg = c.keyword })
hl('MiniIconsPurple', { fg = c.special })
hl('MiniIconsRed', { fg = c.red })
hl('MiniIconsYellow', { fg = c.preproc })

-- mini.statusline mode blocks (otherwise they borrow the faint diff tints)
hl('MiniStatuslineModeNormal', { fg = c.bg, bg = c.violet, bold = true })
hl('MiniStatuslineModeInsert', { fg = c.bg, bg = c.string, bold = true })
hl('MiniStatuslineModeVisual', { fg = c.bg, bg = c.gold, bold = true })
hl('MiniStatuslineModeReplace', { fg = c.bg, bg = c.red, bold = true })
hl('MiniStatuslineModeCommand', { fg = c.bg, bg = c.rose, bold = true })
hl('MiniStatuslineModeOther', { fg = c.bg, bg = c.cyan, bold = true })
hl('MiniStatuslineDevinfo', { fg = c.fg, bg = c.raised })
hl('MiniStatuslineFilename', { fg = c.comment, bg = c.surface })
hl('MiniStatuslineFileinfo', { fg = c.fg, bg = c.raised })
hl('MiniStatuslineInactive', { fg = c.line, bg = c.surface })

-- :terminal uses the same 16 slots as kitty
for i, color in ipairs(ansi) do
  vim.g['terminal_color_' .. (i - 1)] = color
end
