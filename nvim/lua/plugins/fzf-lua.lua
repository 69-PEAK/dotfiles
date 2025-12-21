-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/fzf-lua.lua
-- ============================================================================
return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- For nice icons (optional but recommended)
	config = function()
		local fzf = require("fzf-lua")
		
      -- UI Setup
		fzf.setup("telescope", { 
			winopts = {
				height = 0.80,
				width = 0.87,
				row = 0.35,
				col = 0.50,
				border = "rounded",
				preview = {
					layout = "horizontal", -- Always horizontal (preview on right)
					horizontal = "right:55%", -- ~55% preview width (matches your old Telescope)
					title = true,
					scrollbar = "float",
					scrollchars = { "┃", "" }, -- Nice scrollbar look
				},
			},
			keymap = {
				builtin = {
					["<C-j>"] = "preview-page-down",
					["<C-k>"] = "preview-page-up",
				},
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
			previewers = {
				builtin = {
					treesitter = { enable = false }, -- Keeps it fast
				},
			},
			files = {
				fd_opts = "--hidden --exclude=.git --type f",
			},
			grep = {
				rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
			},
		})

		-- Register fzf-lua as the handler for vim.ui.select (replaces telescope-ui-select)
		fzf.register_ui_select()

		local opts = { silent = true, noremap = true }

		-- Files
		vim.keymap.set("n", "<leader>ff", fzf.files, opts)

		-- Live grep (search in files)
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, opts)

		-- Grep word under cursor
		vim.keymap.set("n", "<leader>fw", fzf.grep_cword, opts)

		-- Buffers
		vim.keymap.set("n", "<leader>fb", fzf.buffers, opts)

		-- Recent files
		vim.keymap.set("n", "<leader>fr", fzf.oldfiles, opts)

		-- Help tags
		vim.keymap.set("n", "<leader>fh", fzf.help_tags, opts)

		-- Command history
		vim.keymap.set("n", "<leader>fc", fzf.command_history, opts)

		-- Search history
		vim.keymap.set("n", "<leader>fs", fzf.search_history, opts)

		-- Keymaps
		vim.keymap.set("n", "<leader>fk", fzf.keymaps, opts)

		-- Current buffer fuzzy find
		vim.keymap.set("n", "<leader>fl", fzf.lines, opts)

		-- Resume last picker
		vim.keymap.set("n", "<leader>fp", fzf.resume, opts)

		-- Marks
		vim.keymap.set("n", "<leader>fm", fzf.marks, opts)

		-- Registers
		vim.keymap.set("n", "<leader>fR", fzf.registers, opts)

		-- Colorschemes
		vim.keymap.set("n", "<leader>ft", fzf.colorschemes, opts)

		-- Git files
		vim.keymap.set("n", "<leader>gf", fzf.git_files, opts)

		-- Git commits
		vim.keymap.set("n", "<leader>gc", fzf.git_commits, opts)

		-- Git buffer commits
		vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, opts)

		-- Git status
		vim.keymap.set("n", "<leader>gs", fzf.git_status, opts)

		-- Git branches
		vim.keymap.set("n", "<leader>gb", fzf.git_branches, opts)

		-- LSP references
		vim.keymap.set("n", "gr", fzf.lsp_references, opts)

		-- LSP type definitions
		vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts)

		-- LSP implementations
		vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)

		-- LSP document symbols
		vim.keymap.set("n", "<leader>lsd", fzf.lsp_document_symbols, opts)

		-- LSP workspace symbols
		vim.keymap.set("n", "<leader>lsw", fzf.lsp_workspace_symbols, opts)

		-- LSP diagnostics
		vim.keymap.set("n", "<leader>ld", fzf.diagnostics_workspace, opts)

		-- Treesitter symbols
		vim.keymap.set("n", "<leader>ts", fzf.treesitter, opts)
	end,
}
