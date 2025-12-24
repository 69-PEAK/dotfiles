-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/fzf-lua.lua
-- ============================================================================
return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			-- Window options
			winopts = {
				height = 0.60, -- window height: 0.0-1.0 (percentage) or >1 (lines)
				width = 0.75, -- window width: 0.0-1.0 (percentage) or >1 (columns)
				row = 0.5, -- vertical position: 0.0-1.0
				col = 0.5, -- horizontal position: 0.0-1.0
				border = "rounded", -- border style: single|double|rounded|solid|shadow|none
				preview = {
					layout = "flex", -- layout: flex adapts to window size automatically
					flip_columns = 120, -- switch to vertical when width < 120 cols
					horizontal = "right:50%", -- position: right:N%|left:N%
					vertical = "down:45%", -- vertical layout if window too narrow
					title = true, -- show preview title
					title_pos = "center", -- title position: left|center|right
					scrollbar = "float", -- scrollbar: float|border|none
					scrollchars = { "┃", "" }, -- scrollbar characters [thumb, track]
				},
			},

			-- Key mappings
			keymap = {
				builtin = {
					["<C-j>"] = "preview-page-down",
					["<C-k>"] = "preview-page-up",
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
					["<F1>"] = "toggle-help",
				},
				fzf = {
					["ctrl-q"] = "select-all+accept",
					["ctrl-h"] = "toggle-preview",
					["ctrl-l"] = "toggle-preview",
					["tab"] = "toggle+down",
					["shift-tab"] = "toggle+up",
					["ctrl-a"] = "toggle-all",
				},
			},

			-- fzf binary options
			fzf_opts = {
				["--layout"] = "reverse", -- layout: reverse|default
				["--info"] = "default", -- info style: default|inline|inline-right|hidden
				["--multi"] = "", -- enable multi-select mode
				["--no-separator"] = "", -- hide separator line
				["--border"] = "none", -- border: none|rounded|sharp|horizontal|vertical
			},

			-- Custom Catppuccin Mocha colors for fzf
			fzf_colors = {
				["fg"] = { "fg", "CursorLine" }, -- foreground text
				["bg"] = { "bg", "Normal" }, -- background
				["hl"] = { "fg", "Comment" }, -- highlighted match text
				["fg+"] = { "fg", "Normal" }, -- selected line foreground
				["bg+"] = { "bg", "CursorLine" }, -- selected line background
				["hl+"] = { "fg", "Statement" }, -- highlighted match in selected line
				["info"] = { "fg", "PreProc" }, -- info line (count)
				["prompt"] = { "fg", "Conditional" }, -- prompt character
				["pointer"] = { "fg", "Exception" }, -- cursor/pointer (▶)
				["marker"] = { "fg", "Keyword" }, -- multi-select marker (✓)
				["spinner"] = { "fg", "Label" }, -- loading spinner
				["header"] = { "fg", "Comment" }, -- header text
				["gutter"] = { "bg", "Normal" }, -- gutter background
			},

			-- Preview configuration
			previewers = {
				builtin = {
					treesitter = { enabled = false }, -- syntax highlight: true (slower) | false (faster)
				},
			},

			-- File search configuration
			files = {
				fd_opts = "--hidden --exclude=.git --type f", -- fd options: --hidden shows dotfiles
			},

			-- Grep search configuration
			grep = {
				rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
				-- rg options: --hidden (dotfiles) | --smart-case (case-insensitive unless uppercase) | -g '!pattern' (exclude)
			},
		})

		-- Register fzf-lua for vim.ui.select
		fzf.register_ui_select()

		local opts = { silent = true, noremap = true }

		-- Files
		vim.keymap.set("n", "<leader>ff", fzf.files, opts)
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, opts)
		vim.keymap.set("n", "<leader>fw", fzf.grep_cword, opts)
		vim.keymap.set("n", "<leader>fb", fzf.buffers, opts)
		vim.keymap.set("n", "<leader>fr", fzf.oldfiles, opts)
		vim.keymap.set("n", "<leader>fh", fzf.help_tags, opts)
		vim.keymap.set("n", "<leader>fc", fzf.command_history, opts)
		vim.keymap.set("n", "<leader>fs", fzf.search_history, opts)
		vim.keymap.set("n", "<leader>fk", fzf.keymaps, opts)
		vim.keymap.set("n", "<leader>fl", fzf.lines, opts)
		vim.keymap.set("n", "<leader>fp", fzf.resume, opts)
		vim.keymap.set("n", "<leader>fm", fzf.marks, opts)
		vim.keymap.set("n", "<leader>fR", fzf.registers, opts)

		-- Git
		vim.keymap.set("n", "<leader>gf", fzf.git_files, opts)
		vim.keymap.set("n", "<leader>gc", fzf.git_commits, opts)
		vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, opts)
		vim.keymap.set("n", "<leader>gs", fzf.git_status, opts)
		vim.keymap.set("n", "<leader>gb", fzf.git_branches, opts)

		-- LSP
		vim.keymap.set("n", "gr", fzf.lsp_references, opts)
		vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts)
		vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
		vim.keymap.set("n", "<leader>lsd", fzf.lsp_document_symbols, opts)
		vim.keymap.set("n", "<leader>lsw", fzf.lsp_workspace_symbols, opts)
		vim.keymap.set("n", "<leader>ld", fzf.diagnostics_workspace, opts)

		-- Treesitter
		vim.keymap.set("n", "<leader>ts", fzf.treesitter, opts)

		-- Quickfix navigation
		vim.keymap.set("n", "<C-n>", ":cnext<CR>", opts)
		vim.keymap.set("n", "<C-p>", ":cprev<CR>", opts)
		vim.keymap.set("n", "<leader>qo", ":copen<CR>", opts)
		vim.keymap.set("n", "<leader>qc", ":cclose<CR>", opts)

		---------------------- Dynamic Theme Switching  --------------------------------
		-- Path for saving theme selection
		local theme_file = vim.fn.stdpath("config") .. "/last_theme.txt"

		-- Helper: set and save colorscheme + lualine logic
		local function set_theme(name)
			if not name or #name == 0 then
				return
			end
			if pcall(vim.cmd, "colorscheme " .. name) then
				-- Set lualine theme depending on colorscheme
				local lualine_theme
				-- Dracula for catppuccin EXCEPT catppuccin-latte
				if (name == "catppuccin") or (name:match("^catppuccin%-") and name ~= "catppuccin-latte") then
					lualine_theme = "dracula"
				else
					lualine_theme = "auto"
				end
				require("lualine").setup({ options = { theme = lualine_theme } })
				local f = io.open(theme_file, "w")
				if f then
					f:write(name)
					f:close()
				end
			else
				vim.notify("Theme not found: " .. name, vim.log.levels.ERROR)
			end
		end

		-- Apply last theme on startup
		local f = io.open(theme_file, "r")
		if f then
			set_theme(f:read("*l"))
			f:close()
		end

		-- FZF color scheme picker
		vim.keymap.set("n", "<leader>ft", function()
			require("fzf-lua").colorschemes({
				actions = {
					["default"] = function(selected)
						set_theme(selected[1])
					end,
				},
			})
		end, { noremap = true, silent = true })
	end,
}
