return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    jump = {
      autojump = true,
    },
    label = {
      uppercase = false,
    },
    modes = {
      char = {
        jump_labels = false,
        multi_line = false,
        highlight = {
          backdrop = false,
          matches = function(matches)
            return vim.tbl_filter(function(match) return match.pos[1] == vim.fn.line "." end, matches)
          end,
        },
      },
    },
    -- Add custom highlight groups
    highlight = {
      groups = {
        match = "CustomFlashMatch",
        current = "CustomFlashCurrent",
        backdrop = "CustomFlashBackdrop",
        label = "CustomFlashLabel",
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)

    -- Define Catppuccin colors explicitly
    local catppuccin_colors = {
      blue = "#89B4FA",
      peach = "#FAB387",
      overlay0 = "#6C7086",
      green = "#A6E3A1",
    }

    -- Function to set custom highlights
    local function set_custom_highlights()
      vim.api.nvim_set_hl(0, "CustomFlashMatch", { fg = catppuccin_colors.blue })
      vim.api.nvim_set_hl(0, "CustomFlashCurrent", { fg = catppuccin_colors.peach })
      vim.api.nvim_set_hl(0, "CustomFlashBackdrop", { fg = catppuccin_colors.overlay0 })
      vim.api.nvim_set_hl(0, "CustomFlashLabel", { fg = catppuccin_colors.green, bold = true })
    end

    -- Set custom highlights immediately
    set_custom_highlights()

    -- Set up autocmd to reapply highlights after colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_custom_highlights,
    })

    -- Set up autocmd to reapply highlights after a short delay
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function() vim.defer_fn(set_custom_highlights, 100) end,
    })

    -- Custom function to wrap flash.jump() with marking behavior
    local function flash_jump_with_marks()
      vim.cmd "normal! mf"
      require("flash").jump()
      vim.defer_fn(function() vim.cmd "normal! mg" end, 10)
    end
    vim.keymap.set({ "n", "x", "o" }, "s", flash_jump_with_marks, { desc = "Flash with marks" })
  end,
  keys = {},
}
