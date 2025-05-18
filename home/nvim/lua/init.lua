require("lazy").setup("lazy_plugins")
vim.diagnostic.config({ virtual_text = false })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
