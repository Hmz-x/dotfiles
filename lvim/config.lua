-- Custom keybinding to insert '#' at the beginning of the first word and move down a line
lvim.keys.normal_mode["<C-c>"] = ":lua InsertHashAndMoveDown()<CR>"

function InsertHashAndMoveDown()
  -- Get the current cursor position
  local line_number = vim.fn.line(".")
  local current_line = vim.fn.getline(line_number)

  -- Enter insert mode, insert '#', and then exit insert mode
  vim.cmd("normal! ^i#")

  -- Move down one line
  vim.cmd("normal! j")
end

-- Use black hole register for deletions to disable copying of deleted characters
lvim.keys.normal_mode["d"] = '"_d'
lvim.keys.normal_mode["D"] = '"_D'
lvim.keys.normal_mode["c"] = '"_c'
lvim.keys.normal_mode["C"] = '"_C'
lvim.keys.normal_mode["x"] = '"_x'
lvim.keys.visual_mode["d"] = '"_d'
lvim.keys.visual_mode["D"] = '"_D'
lvim.keys.visual_mode["c"] = '"_c'
lvim.keys.visual_mode["C"] = '"_C'
lvim.keys.visual_mode["x"] = '"_x'
