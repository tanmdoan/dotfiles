-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "th", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "tl", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("n", "<C-p>", function()
  require("fzf-lua").files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>W", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>X", "<cmd>x<cr>", { desc = "Save and close" })
vim.keymap.set("n", "<leader>Q", "<cmd>close<cr>", { desc = "Close pane" })

for _, lhs in ipairs({ "<A-j>", "<A-k>" }) do
  for _, mode in ipairs({ "n", "i", "v" }) do
    pcall(vim.keymap.del, mode, lhs)
  end
end

vim.keymap.set("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Resize pane up" })
vim.keymap.set("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Resize pane down" })
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Resize pane left" })
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Resize pane right" })
vim.keymap.set("n", "<A-=>", "<C-w>=", { desc = "Reset pane sizes" })
