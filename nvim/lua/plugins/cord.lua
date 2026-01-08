-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/cord.lua 
-- ============================================================================

return {
	"vyfor/cord.nvim",
	build = "./build || .\\build",
	event = "VeryLazy",
	opts = {
		usercmds = true,
		log_level = "error",
		timer = {
			interval = 1500,
			reset_on_idle = false,
			reset_on_change = false,
		},
		editor = {
			image = nil,
			client = "neovim",
			tooltip = "Neovim",
		},
		display = {
			show_time = true,
			show_repository = false,
			show_cursor_position = false,
			swap_fields = true,
			swap_icons = true,
			workspace_blacklist = {},
		},
		
		lsp = {
			show_problem_count = false,
			severity = 1,
			scope = "workspace",
		},
		idle = {
			enable = true,
			show_status = true,
			timeout = 300000,
			disable_on_focus = false,
			text = "💤",
			tooltip = "💤",
		},
		text = {
			viewing = "  ",
			editing = "  ",
			file_browser = "  ",
			plugin_manager = "  ",
			lsp_manager = "  ",
			vcs = "  ",
			workspace = "  ", 
		},
		buttons = {},
	},
}