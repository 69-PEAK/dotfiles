-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/image.lua
-- ============================================================================

return {
	"3rd/image.nvim",

	config = function()
		require("image").setup({
			backend = "kitty", -- Ghostty supports kitty protocol

			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = true, -- Only show image under cursor (hover effect)
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = true, -- Hover effect in neorg too
					filetypes = { "norg" },
				},
			},
			-- comment these two if you want to use percentage-based size:
			max_width = 20, -- number of chars (~columns) for width
			max_height = 10, -- number of rows for height
			--	max_width_window_percentage = 20, -- % of nvim window width
			-- max_height_window_percentage = 20,

			-- Auto-render images when cursor hovers
			window_overlap_clear_enabled = true, -- Clear images when windows overlap
			window_overlap_clear_ft_ignore = { "neo-tree", "NvimTree", "TelescopePrompt", "cmp_menu", "cmp_docs", "" },

			editor_only_render_when_focused = true, -- Only render in focused window
			tmux_show_only_in_active_window = true, -- Tmux support

			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})
	end,
}
