return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  ---@type CatppuccinOptions
  opts = {
    custom_highlights = function(colors)
      return {
        TabLineSel = { bg = colors.pink },
        CmpBorder = { fg = colors.surface2 },
        CmpWhite = { fg = "#ffffff" },
        Pmenu = { bg = "#191828" },
        CmpPmenu = { bg = "#191828" },
        PmenuSel = { bg = colors.green, fg = "#000000", bold = true },
        -- Blink.cmp Completion Menu styling
        BlinkCmpMenu = { bg = colors.pink, fg = colors.text },
        BlinkCmpMenuBorder = { fg = colors.surface2 },
        BlinkCmpMenuSelection = { bg = colors.surface1, fg = colors.text },
        -- Scrollbar styling
        BlinkCmpScrollBarThumb = { bg = colors.overlay1 },
        BlinkCmpScrollBarGutter = { bg = colors.overlay0 },
        -- Labels
        BlinkCmpLabel = { fg = colors.text },
        BlinkCmpLabelDeprecated = { fg = colors.maroon, strikethrough = true },
        BlinkCmpLabelMatch = { fg = colors.blue, bold = true },
        BlinkCmpLabelDetail = { fg = colors.subtext1 },
        BlinkCmpLabelDescription = { fg = colors.subtext0 },
        -- Kind (icon/text)
        BlinkCmpKind = { fg = colors.lavender },
        -- Source label
        BlinkCmpSource = { fg = colors.overlay2 },
        -- Ghost Text (preview)
        BlinkCmpGhostText = { fg = colors.overlay1, italic = true },
        -- Documentation window
        BlinkCmpDoc = { bg = colors.pink, fg = colors.text },
        BlinkCmpDocBorder = { fg = colors.surface2 },
        BlinkCmpDocSeparator = { fg = colors.surface1 },
        BlinkCmpDocCursorLine = { bg = colors.surface1 },
        -- Signature help window
        BlinkCmpSignatureHelp = { bg = colors.mantle, fg = colors.text },
        BlinkCmpSignatureHelpBorder = { fg = colors.surface2 },
        BlinkCmpSignatureHelpActiveParameter = { fg = colors.blue, bold = true },
      }
    end,
  },
  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        return require("astrocore").extend_tbl(opts, {
          highlights = require("catppuccin.groups.integrations.bufferline").get(),
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      optional = true,
      opts = {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      },
    },
  },
}
