local set = vim.api
local opt = vim.opt
local o = vim.o
local g = vim.g
local v = vim.api

-------------------------------------- options ------------------------------------------
opt.scrolloff = 5 -- Set scrolloff option
opt.swapfile = false --Swapfile
opt.list = true -- Show listchars
opt.fillchars = { eob = " " } -- show blank space

opt.cursorline = false
vim.cmd [[autocmd FileType * set formatoptions-=ro]] -- turn of commenting new line

set.nvim_set_hl(0, "ColorColumn", { bg = "#181826" })
set.nvim_create_autocmd("Filetype", {
  ---@diagnostic disable-next-line: undefined-global
  group = augroup,
  pattern = {
    "java",
    "javascript",
    "typescript",
    "lua",
    "python",
    "c",
    "cpp",
    "rust",
    "go",
    "javascriptreact",
    "typescriptreact",
  },
  command = "setlocal  colorcolumn=81",
})

local lspconfig = require "lspconfig"

-- Disable folding range for all LSP servers
local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.foldingRange = false

-- Setup all installed LSP servers
local servers = { "lua_ls", "pyright", "clangd", "rust_analyzer" } -- Add your servers here

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = default_capabilities,
  }
end

vim.diagnostic.config {
  jump = {
    float = true,
  },
  severity_sort = true,
  update_in_insert = false, -- false so diags are updated on InsertLeave
  virtual_text = { current_line = true },
}

vim.keymap.set("n", "<leader>k", function() -- turn <leader>k to open floating error
  vim.diagnostic.config { virtual_lines = { current_line = true }, virtual_text = false }
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
    callback = function()
      vim.diagnostic.config { virtual_lines = false, virtual_text = true }
      return true
    end,
  })
end)
