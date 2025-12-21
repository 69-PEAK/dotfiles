-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/telescope.lua
-- ============================================================================
return {
	"nvim-telescope/telescope.nvim",
	enabled = false,
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		-- Added for massive speed improvement: native FZF sorter written in C
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local status_ok, telescope = pcall(require, "telescope")
		if not status_ok then
			return
		end
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git/" },
				hidden = true,
				preview = {
					treesitter = false, -- Keeps previews fast by disabling Treesitter highlighting
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-s>"] = actions.select_horizontal,
					},
					n = {
						["q"] = actions.close,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				sorting_strategy = "ascending",
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "truncate" },

				-- Use the ultra-fast native FZF sorter instead of the default Lua one
				file_sorter = require("telescope.sorters").get_fzf_sorter,
				generic_sorter = require("telescope.sorters").get_fzf_sorter,
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
				},
				buffers = {
					sort_lastused = true,
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
						},
					},
				},
				live_grep = {
					additional_args = function()
						return { "--hidden" }
					end,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				-- fzf extension configuration – these options ensure it fully overrides the slower sorters
				fzf = {
					fuzzy = true, -- enable fuzzy matching
					override_generic_sorter = true, -- replace default generic sorter
					override_file_sorter = true, -- replace default file sorter
					case_mode = "smart_case", -- ignore case unless query has uppercase
				},
			},
		})

		-- Load extensions
		pcall(telescope.load_extension, "ui-select")
		pcall(telescope.load_extension, "fzf") -- Critical: loads the native FZF extension

		-- Telescope keymaps (unchanged)
		local builtin = require("telescope.builtin")
		local opts = { silent = true }

		-- Find Files
		vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)

		-- Live grep (search in files)
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)

		-- Grep word under cursor
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, opts)

		-- Buffers
		vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)

		-- Recent files
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, opts)

		-- Help tags
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)

		-- Command history
		vim.keymap.set("n", "<leader>fc", builtin.command_history, opts)

		-- Search history
		vim.keymap.set("n", "<leader>fs", builtin.search_history, opts)

		-- Keymaps
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, opts)

		-- Current buffer fuzzy find
		vim.keymap.set("n", "<leader>fl", builtin.current_buffer_fuzzy_find, opts)

		-- Vim options
		vim.keymap.set("n", "<leader>fo", builtin.vim_options, opts)

		-- Resume last picker
		vim.keymap.set("n", "<leader>fp", builtin.resume, opts)

		-- Marks
		vim.keymap.set("n", "<leader>fm", builtin.marks, opts)

		-- Registers
		vim.keymap.set("n", "<leader>fR", builtin.registers, opts)

		-- Colorschemes
		vim.keymap.set("n", "<leader>ft", builtin.colorscheme, opts)

		-- Git files
		vim.keymap.set("n", "<leader>gf", builtin.git_files, opts)

		-- Git commits
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, opts)

		-- Git buffer commits
		vim.keymap.set("n", "<leader>gC", builtin.git_bcommits, opts)

		-- Git status
		vim.keymap.set("n", "<leader>gs", builtin.git_status, opts)

		-- Git branches
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, opts)

		-- LSP references
		vim.keymap.set("n", "gr", builtin.lsp_references, opts)

		-- LSP type definitions
		vim.keymap.set("n", "gt", builtin.lsp_type_definitions, opts)

		-- LSP implementations
		vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)

		-- LSP document symbols
		vim.keymap.set("n", "<leader>lsd", builtin.lsp_document_symbols, opts)

		-- LSP workspace symbols
		vim.keymap.set("n", "<leader>lsw", builtin.lsp_workspace_symbols, opts)

		-- LSP diagnostics
		vim.keymap.set("n", "<leader>ld", builtin.diagnostics, opts)

		-- Treesitter symbols
		vim.keymap.set("n", "<leader>ts", builtin.treesitter, opts)
	end,
}
