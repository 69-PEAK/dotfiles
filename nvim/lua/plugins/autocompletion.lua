-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/autocompletion.lua
-- ============================================================================
return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp", -- LSP completion source
		"hrsh7th/cmp-nvim-lsp-signature-help", -- Signature help
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip", -- Snippet engine
		"saadparwaiz1/cmp_luasnip", -- Snippet completion source
	},
	config = function()
		-- Load VSCode-format snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		local status_ok, cmp = pcall(require, "cmp")
		if not status_ok then
			return
		end

		local luasnip_ok, luasnip = pcall(require, "luasnip")
		if not luasnip_ok then
			return
		end

		luasnip.config.set_config({
			ext_opts = {
				[require("luasnip.util.types").choiceNode] = {
					active = { virt_text = { { "●", "Special" } } },
				},
			},
		})

		-- Main completion setup
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP completions
				{ name = "nvim_lsp_signature_help" }, -- Shows signature for args
				{ name = "luasnip" }, -- Snippet completions
				{ name = "buffer" }, -- Buffer completions
				{ name = "path" }, -- Path completions
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			experimental = {
				ghost_text = true,
			},
		})

		-- Setup for command-line completion
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		-- Setup for search completion
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
	end,
}
