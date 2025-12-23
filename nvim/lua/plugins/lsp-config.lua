-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/lsp-config.lua
-- ============================================================================
return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- mason-lspconfig.nvim
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls", -- Lua
				"pyright", -- Python
				"ruff", -- Add this for Python linting
				"ts_ls", -- TypeScript/JavaScript
				"eslint", -- TS/JS linting
				"clangd", -- C/C++ (diagnostics + clang-tidy)
				"jdtls", -- Java
				"html", -- HTML
				"cssls", -- CSS
			},
			automatic_installation = true,
		},
	},

	-- nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- === UI: Hover & Signature Help ===
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- === Diagnostic Float Config ===
			local function diagnostic_float_config()
				return {
					border = "rounded",
					header = "",
					prefix = "",
					scope = "cursor", -- Change to "line" or remove for buffer-wide
					focusable = true,
				}
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = diagnostic_float_config(),
			})

			-- === Capabilities (completiion support) ===
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
			end
			vim.lsp.config("*", { capabilities = capabilities })

			-- === Keymaps on LspAttach ===
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local bufmap = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end

					bufmap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					bufmap("n", "K", vim.lsp.buf.hover, "Hover")
					bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
					bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					bufmap("n", "<leader>d", vim.diagnostic.open_float, "Show Diagnostics")
				end,
			})

			-- === Server-specific Overrides ===

			-- Lua LSP (Neovim config)
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			-- clangd: Enable clang-tidy for C/C++ diagnostics
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy", -- Enable clang-tidy checks
					"--clang-tidy-checks=*", -- Enable all checks (customize via .clang-tidy file)
					"--all-scopes-completion",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
					"--cross-file-rename",
				},
			})
		end,
	},
}
