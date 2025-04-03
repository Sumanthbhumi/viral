local map = vim.keymap.set

map("i", "<C-J>", "<Esc>", { noremap = true })
map("v", "<C-J>", "<Esc>", { noremap = true })
map("n", "<C-J>", "<Esc>", { noremap = true })
map("t", "<C-J>", "<Esc>", { noremap = true })

map("i", "<c-bs>", "<C-W>", { noremap = true, silent = true })
map("i", "<C-h>", "<C-W>", { noremap = true, silent = true })

map("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true }) -- Navigate to the next buffer
map("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true }) -- Navigate to the previous buffer
map("n", "x", "_x", { noremap = true, silent = true })

map("v", "<Leader>q", "<Cmd>confirm q<CR>", { silent = true, desc = "Exit Neovim" })

map("i", "<A-l>", "<Right>", { noremap = true })
map("i", "<A-h>", "<Left>", { noremap = true })
map("i", "<A-k>", "<Up>", { noremap = true })
map("i", "<A-j>", "<Down>", { noremap = true })

map("t", "<C-j>", "<C-\\><C-n><CR>", { noremap = true, silent = true })

local function set_keymap_for_modes(modes, key1, key2)
  for _, mode in ipairs(modes) do
    vim.api.nvim_set_keymap(mode, key1, key2, { noremap = true })
    vim.api.nvim_set_keymap(mode, key2, key1, { noremap = true })
  end
end

-- Define the modes
local all_modes = { "n", "v", "x", "s", "o", "i", "c" }

-- Set Z and % mappings
set_keymap_for_modes(all_modes, "Z", "%")
set_keymap_for_modes(all_modes, "<C-bs>", "<C-w>")

map(
  "n",
  "<C-f>",
  function()
    require("snacks").picker.files {
      hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
    }
  end,
  { desc = "Find File" }
)
-- map("n", "<C-b>", ":Telescope file_browser<CR>", { desc = "File Browser" })

map("n", "H", "^", { noremap = true })
map("v", "H", "^", { noremap = true })
map("n", "L", "$", { noremap = true })
map("v", "L", "$h", { noremap = true })

map("n", "x", '"_x', { noremap = true, silent = true })
map({ "n", "v" }, "G", "Gzz", { noremap = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    map(
      "n",
      "<CR>",
      function() require("nvim-treesitter.textobjects.move").goto_next_start "@parameter.inner" end,
      { noremap = true, silent = true }
    )

    map(
      "n",
      "<BS>",
      function() require("nvim-treesitter.textobjects.move").goto_previous_start "@parameter.inner" end,
      { noremap = true, silent = true }
    )
  end,
})
