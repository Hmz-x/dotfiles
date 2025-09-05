-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    -- Use the wildcharm vim theme
    "vim/colorschemes",
    lazy = false,
    -- Run the actual 'wildcharm' colorscheme
    config = function()
      vim.cmd("colorscheme wildcharm")
    end,
  },
  -- Make sure LazyVim doesn't override
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "wildcharm" },
  },
}
