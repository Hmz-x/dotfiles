-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.cmd.colorscheme("wildcharm")
vim.opt.relativenumber = false
vim.opt.number = true
-- Disable automatic comment continuation on new line
vim.opt.formatoptions:remove({ "c", "r", "o" })
