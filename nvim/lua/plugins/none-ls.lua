-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/none-ls.lua
-- ============================================================================
-- none-ls.nvim: null-ls replacement
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"williamboman/mason.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local status_ok, null_ls = pcall(require, "null-ls")
		if not status_ok then
			return
		end

		null_ls.setup({
			sources = {
				-- Formatting
				null_ls.builtins.formatting.stylua, -- Lua
				null_ls.builtins.formatting.black, -- Python
				null_ls.builtins.formatting.isort, -- Python imports
				null_ls.builtins.formatting.prettier.with({ -- JS/TS/HTML/CSS/JSON
					extra_filetypes = { "markdown", "yaml" },
				}),
				null_ls.builtins.formatting.google_java_format, -- Java
				null_ls.builtins.formatting.clang_format, -- C/C++
			},

			-- Auto-format on save
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							if vim.g.auto_format then
								vim.lsp.buf.format({ bufnr = bufnr, async = false })
							end
						end,
					})
				end
			end,
		})

		-- Mason integration
		local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
		if mason_null_ls_ok then
			mason_null_ls.setup({
				ensure_installed = {
					"stylua",
					"black",
					"isort",
					"prettier",
					"google-java-format",
					"eslint_d",
					"clang-format",
				},
				automatic_installation = true,
			})
		end

		-- Manual format keymap
		vim.keymap.set({ "n", "v" }, "<leader>f", vim.lsp.buf.format, { desc = "Format file/range" })

		-- Toggle auto-format on save
		vim.g.auto_format = true
		vim.keymap.set("n", "<leader>uf", function()
			vim.g.auto_format = not vim.g.auto_format
			print("Auto-format on save: " .. tostring(vim.g.auto_format))
		end, { desc = "Toggle auto-format on save" })
	end,
}
