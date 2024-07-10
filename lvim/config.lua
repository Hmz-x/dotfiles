-- Function to go to the front of the line, remove the first character, and move down a line
function RemoveFirstCharAndMoveDown()
  -- Go to the front of the line
  vim.cmd("normal! ^")

  -- Remove the first character
  vim.cmd("normal! x")

  -- Move down one line
  vim.cmd("normal! j")
end

-- Set keybinding for Ctrl-x to call the RemoveFirstCharAndMoveDown function
vim.api.nvim_set_keymap('n', '<C-x>', ':lua RemoveFirstCharAndMoveDown()<CR>', { noremap = true, silent = true })

-- Function to insert '#' at the beginning of the line and move down a line
function InsertHashAndMoveDown()
  -- Get the current cursor position
  local line_number = vim.fn.line(".")
  local current_line = vim.fn.getline(line_number)

  -- Enter insert mode, insert '#', and then exit insert mode
  vim.cmd("normal! ^i#")

  -- Move down one line
  vim.cmd("normal! j")
end

-- Set keybinding for Ctrl-c to call the InsertHashAndMoveDown function
vim.api.nvim_set_keymap('n', '<C-c>', ':lua InsertHashAndMoveDown()<CR>', { noremap = true, silent = true })

-- Use black hole register for deletions to disable copying of deleted characters
vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('n', 'D', '"_D', { noremap = true })
vim.api.nvim_set_keymap('n', 'c', '"_c', { noremap = true })
vim.api.nvim_set_keymap('n', 'C', '"_C', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('v', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('v', 'D', '"_D', { noremap = true })
vim.api.nvim_set_keymap('v', 'c', '"_c', { noremap = true })
vim.api.nvim_set_keymap('v', 'C', '"_C', { noremap = true })
vim.api.nvim_set_keymap('v', 'x', '"_x', { noremap = true })
