-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      -- add more arguments for adding more treesitter parsers
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufRead",
    config = function()
      -- Set NvChad-inspired colors for treesitter context
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1E2030" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#89B4FA", bg = "#1E2030" })

      require("treesitter-context").setup {
        enable = true,
        max_lines = 4,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        zindex = 20,
      }
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>u("] = {
                function()
                  local bufnr = vim.api.nvim_get_current_buf()
                  require("rainbow-delimiters").toggle(bufnr)
                  require("astrocore").notify(
                    string.format(
                      "Buffer rainbow delimeters %s",
                      require("rainbow-delimiters").is_enabled(bufnr) and "on" or "off"
                    )
                  )
                end,
                desc = "Toggle rainbow delimeters (buffer)",
              },
            },
          },
        },
      },
    },
    specs = {
      {
        "tokyonight",
        optional = true,
        opts = { integrations = { rainbow_delimiters = true } },
      },
    },
    event = "User AstroFile",
    main = "rainbow-delimiters.setup",
    opts = {
      condition = function(bufnr)
        local buf_utils = require "astrocore.buffer"
        return buf_utils.is_valid(bufnr) and not buf_utils.is_large(bufnr)
      end,
    },
  },
}
