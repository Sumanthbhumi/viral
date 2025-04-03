local lsp_icons = {
  Namespace = "󰌗",
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰆧",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈚",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
  Table = "",
  Object = "󰅩",
  Tag = "",
  Array = "[]",
  Boolean = "",
  Number = "",
  Null = "󰟢",
  Supermaven = "",
  String = "󰉿",
  Calendar = "",
  Watch = "󰥔",
  Package = "",
  Copilot = "",
  Codeium = "",
  TabNine = "",
  BladeNav = "",
}
local function get_kind_icon(ctx)
  local icon = lsp_icons[ctx.kind] or "" -- Fallback to empty string if not found
  return { text = icon .. ctx.icon_gap, highlight = ctx.kind_hl }
end

return {
  "Saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  opts_extend = { "sources.default", "cmdline.sources", "term.sources" },
  opts = {
    enabled = function()
      local astro = require "astrocore"
      local dap_prompt = astro.is_available "cmp-dap" -- add interoperability with cmp-dap
        and vim.tbl_contains({ "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype)
      if vim.bo.buftype == "prompt" and not dap_prompt then return false end
      return vim.F.if_nil(vim.b.completion, astro.config.features.cmp)
    end,
    -- remember to enable your providers here
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    keymap = {
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-N>"] = { "select_next", "show" },
      ["<C-P>"] = { "select_prev", "show" },
      ["<C-J>"] = { "fallback" }, -- "select_next",
      -- ["<C-K>"] = { "select_prev", "fallback" },
      ["<C-U>"] = { "scroll_documentation_up", "fallback" },
      ["<C-D>"] = { "scroll_documentation_down", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      list = { selection = { preselect = true, auto_insert = true } },
      menu = {
        -- auto_show = function(ctx) return ctx.mode ~= "cmdline" end,
        auto_show = function(ctx) -- to prevent python completion when i press ':'
          -- Disable auto-completion when pressing ":" in Python files
          if vim.bo.filetype == "python" and vim.fn.col "." > 1 then
            local prev_char = vim.fn.getline("."):sub(vim.fn.col "." - 1, vim.fn.col "." - 1)
            if prev_char == ":" then return false end
          end
          return ctx.mode ~= "cmdline"
        end,
        border = "none",

        scrollbar = false,
        -- winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
        draw = {
          -- align_to = "cursor",
          treesitter = { "lsp" },
          gap = 1, -- column gap
          padding = 2, -- left and right
          components = {
            kind_icon = {
              text = function(ctx) return get_kind_icon(ctx).text end,
              highlight = function(ctx) return get_kind_icon(ctx).highlight end,
            },
          },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 2 } },
        },
      },
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "single",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
    },
    signature = {
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  specs = {
    {
      "AstroNvim/astrolsp",
      optional = true,
      opts = function(_, opts)
        opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities)

        -- disable AstroLSP signature help if `blink.cmp` is providing it
        local blink_opts = require("astrocore").plugin_opts "blink.cmp"
        if vim.tbl_get(blink_opts, "signature", "enabled") == true then
          if not opts.features then opts.features = {} end
          opts.features.signature_help = false
        end
      end,
    },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>uc"] =
          { function() require("astrocore.toggles").buffer_cmp() end, desc = "Toggle autocompletion (buffer)" }
        maps.n["<Leader>uC"] =
          { function() require("astrocore.toggles").cmp() end, desc = "Toggle autocompletion (global)" }
      end,
    },
  },
}
