-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- set the shell to /usr/bin/zsh
vim.opt.shell = "zsh"

vim.opt.cursorline = false

-- disable snacks animation, because they sometimes cause text rendering issues (bleeding) in devcontainers
vim.g.snacks_animate = true
