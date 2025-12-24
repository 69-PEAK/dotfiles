-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/color-scheme.lua
-- ============================================================================
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
        integrations = {
          neotree = true,
          lualine = true,
          treesitter = true,
          native_lsp = { enabled = true },
        },
      })
      -- vim.cmd.colorscheme("catppuccin-mocha") -- to force a flavor on load
    end,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    lazy = false,
    config = function()
      require("tokyonight").setup({
        style = "night", -- "storm", "moon", "night", "day"
        transparent = false,
        terminal_colors = true,
        styles = {
          sidebars = "dark", -- "dark", "transparent", "normal"
          floats   = "dark", -- "dark", "transparent", "normal"
        },
      })
      -- vim.cmd.colorscheme("tokyonight-night") -- to force a style on load
    end,
  },
}
