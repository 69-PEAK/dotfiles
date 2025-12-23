-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/alpha.lua
-- ============================================================================

-- Disabled:  using snacks.nvim dashboard instead

return {
	"goolord/alpha-nvim",
	enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons", "ahmedkhalf/project.nvim" },
	config = function()
		require("project_nvim").setup({
			detection_methods = { "lsp", "pattern" },
			patterns = { ".git", "Makefile", "package.json", "pyproject.toml" },
		})

		vim.g.alpha_disable_autocmds = true
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		-- Neovim ASCII art
		dashboard.section.header.val = {
			[[   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
			[[   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
			[[   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
			[[   ██║╚██╗██║██╔══╝  ██║▄▄ ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
			[[   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
			[[   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
		}

		-- Custom color for header:
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#AF87FF" })
		vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#A9B7FF" })
		vim.api.nvim_set_hl(0, "AlphaButtonShortcut", { fg = "#A9B7FF", bold = true })
		vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#E85D9E", italic = true })

		dashboard.section.header.opts.hl = "AlphaHeader"

		-- Menu buttons
		dashboard.section.buttons.val = {
			dashboard.button("n", "󰝒 New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", " Find file", "<cmd>lua require('fzf-lua').files()<CR>"),
			dashboard.button("r", " Recent files", "<cmd>lua require('fzf-lua').oldfiles()<CR>"),
			dashboard.button(
				"p",
				"󰉓 Projects",
				"<cmd>lua local f=vim.fn.stdpath('data')..'/project_nvim/project_history'; local l={}; for s in io.lines(f) do table.insert(l,      s) end; require('fzf-lua').fzf_exec(l,{prompt='Projects> ', actions={['default']=function(sel) vim.cmd('cd '..sel[1]); vim.cmd('e .') end}})<CR>"
			),
			dashboard.button("s", " Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
			dashboard.button("u", "󰚰 Update plugins", ":Lazy sync <CR>"),
			dashboard.button("q", " Quit", ":qa<CR>"),
		}

		-- Apply button colors
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButton"
			button.opts.hl_shortcut = "AlphaButtonShortcut"
		end

		-- Footer with lazy stats
		dashboard.section.footer.val = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			return " Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
		end

		dashboard.section.footer.opts.hl = "AlphaFooter"

		-- Floating window layout
		local width = math.floor(vim.o.columns * 0.6)
		local height = math.floor(vim.o.lines * 0.6)
		local row = math.floor((vim.o.lines - height) / 4) -- vertical offset
		local col = math.floor((vim.o.columns - width) / 4) -- horizontal offset

		-- Layout
		dashboard.opts.layout = {
			{ type = "padding", val = 3 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 2 },
			dashboard.section.footer,
		}
		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)

		-- Auto-redraw stats after LazyVim started
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				if vim.bo.filetype == "alpha" then
					require("alpha").redraw()
				end
			end,
		})

		-- Hide cursor, tabline and statusline when dashboard is ready
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt.showtabline = 0
				vim.opt.laststatus = 0
				vim.opt.cursorline = false -- disable cursorline highlight
				vim.opt.cursorcolumn = false -- just in case
				vim.cmd("highlight Cursor blend=100") -- make cursor fully transparent
				vim.opt.guicursor =
					"n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/rCursor,sm:block-Cursor" -- optional: keep shape but invisible via blend
			end,
		})

		-- Restore everything when leaving the dashboard
		vim.api.nvim_create_autocmd({ "BufLeave", "VimLeavePre" }, {
			buffer = 0, -- only for the alpha buffer
			once = false,
			callback = function()
				if vim.bo.filetype == "alpha" then
					vim.opt.laststatus = 3
					vim.opt.showtabline = 0
					vim.opt.cursorline = true
					vim.cmd("highlight Cursor blend=0") -- restore normal cursor visibility
				end
			end,
		})
	end,
}
