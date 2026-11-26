-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- set the shell to /usr/bin/zsh
vim.opt.shell = "zsh"

vim.opt.cursorline = false

-- disable snacks animation, because they sometimes cause text rendering issues (bleeding) in devcontainers
vim.g.snacks_animate = true

-- Use pyrefly (https://pyrefly.org) as the default Python language server.
vim.g.lazyvim_python_lsp = "pyrefly"

-- disable termsync in tuios sessions as it sometimes causes screen flickering
if vim.env.TUIOS_SESSION ~= nil or vim.env.TERM_PROGRAM == "tuios" then
  vim.opt.termsync = false
end
