-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "Ö", "{", { desc = "Previous Paragraph" })
map("n", "Ä", "}", { desc = "Next Paragraph" })

map({ "n", "v" }, "ö", "[", { remap = true, desc = "Previous prefix" })
map({ "n", "v" }, "ä", "]", { remap = true, desc = "Next prefix" })

map("n", "<C-->", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<C-->", "<cmd>close<cr>", { desc = "Hide Terminal" })
