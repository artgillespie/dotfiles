-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Zellij doesn't advertise OSC 52 support to neovim, so auto-detection fails.
-- Force OSC 52 clipboard so yanking works over SSH through zellij.
-- See: https://github.com/zellij-org/zellij/issues/3951
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = function()
      return {}
    end,
    ["*"] = function()
      return {}
    end,
  },
}

-- LazyVim clears clipboard in SSH sessions; restore unnamedplus so normal yanks
-- target the OSC52 clipboard provider above.
vim.opt.clipboard = "unnamedplus"
