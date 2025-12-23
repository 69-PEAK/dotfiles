-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/catppuccin.lua
-- ============================================================================
return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",

			integrations = {
				neotree = true,
				lualine = true,
				treesitter = true,
				native_lsp = {
					enabled = true,
				},
			},
		})

		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
