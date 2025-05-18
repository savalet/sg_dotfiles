local lsp = require("lsp-zero").preset({})
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = {
          "vim",
          "require"
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.diagnostic.config({
  virtual_text = true,       -- Affiche les warnings/erreurs inline
  signs = true,              -- Affiche les signes dans la colonne de gauche
  underline = true,          -- Souligne les lignes concernées
  update_in_insert = false,  -- N'affiche pas les diagnostics pendant l'insert
  severity_sort = true,      -- Trie les messages par sévérité
})

lspconfig.nil_ls.setup({})
lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--offset-encoding=utf-16",
    "--header-insertion=never",
    "--clang-tidy",
    "--cross-file-rename",
  }
})
lspconfig.pyright.setup({})

-- ↓ Epitech CS
local configs = require("lspconfig.configs")

if not configs.ecsls then
  configs.ecsls = {
    default_config = {
      root_dir = lspconfig.util.root_pattern(".git", "Makefile"),
      cmd = { "ecsls_run" },
      autostart = true,
      name = "ecsls",
      filetypes = { "c", "cpp", "make" },
    },
  }
end
lspconfig.ecsls.setup({})
-- ↓ Epitech HCS
if not configs.ehcsls then
  configs.ehcsls = {
    default_config = {
      root_dir = lspconfig.util.root_pattern(".git"),
      cmd = { "ehcsls_run" },
      autostart = true,
      name = "ehcsls",
      filetypes = { "haskell" },
    },
  }
end
lspconfig.ehcsls.setup({})
--

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "ga", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "gf", function() vim.diagnostic.open_float() end, opts)

  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

