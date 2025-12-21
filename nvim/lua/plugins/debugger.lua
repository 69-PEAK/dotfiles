-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/debugger.lua
-- ============================================================================
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui", -- UI for debugging
		"nvim-neotest/nvim-nio", -- Required by dap-ui
		"theHamsta/nvim-dap-virtual-text", -- Show variable values inline
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim", -- Auto-install debuggers via Mason

		-- Language-specific helpers
		"mfussenegger/nvim-dap-python", -- Adds test_method(), test_class() for Python
	},
	config = function()
		local dap_ok, dap = pcall(require, "dap")
		if not dap_ok then
			return
		end

		local dapui_ok, dapui = pcall(require, "dapui")
		if not dapui_ok then
			return
		end

		-- Setup dap-ui
		dapui.setup({
			icons = {
				expanded = "▾",
				collapsed = "▸",
				current_frame = "▸",
			},
			controls = {
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "↻",
					terminate = "",
				},
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 10,
					position = "bottom",
				},
			},
		})

		-- Setup virtual text
		local virtual_text_ok, virtual_text = pcall(require, "nvim-dap-virtual-text")
		if virtual_text_ok then
			virtual_text.setup()
		end

		-- Automatically open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Setup Mason DAP (auto-installs debuggers)
		local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
		if mason_dap_ok then
			mason_dap.setup({
				ensure_installed = {
					"python", -- Python (debugpy)
					"codelldb", -- C/C++/Rust
					"javadbg", -- Java (or use "java-debug-adapter")
					"js", -- JavaScript/TypeScript
				},
				automatic_installation = true,
				handlers = {
					function(config)
						mason_dap.default_setup(config)
					end,
				},
			})
		end

		-- Python debugging setup
		local dap_python_ok, dap_python = pcall(require, "dap-python")
		if dap_python_ok then
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dap_python.setup(mason_path)
		end

		-- Other Language-specific debugging (handled by mason-nvim-dap)

		-- Custom signs for breakpoints
		vim.fn.sign_define("DapBreakpoint", {
			text = "",
			texthl = "DiagnosticError",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapBreakpointCondition", {
			text = "",
			texthl = "DiagnosticWarn",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapBreakpointRejected", {
			text = "",
			texthl = "DiagnosticHint",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapStopped", {
			text = "▶",
			texthl = "DiagnosticInfo",
			linehl = "Visual",
			numhl = "",
		})

		-- Keymaps for debugging
		local opts = { silent = true }

		-- Start/Continue debugging
		vim.keymap.set("n", "<F5>", dap.continue, opts)

		-- Step over/into/out
		vim.keymap.set("n", "<F10>", dap.step_over, opts)
		vim.keymap.set("n", "<F11>", dap.step_into, opts)
		vim.keymap.set("n", "<F12>", dap.step_out, opts)

		-- Toggle breakpoint
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, opts)

		-- Conditional breakpoint
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, opts)

		-- Log point
		vim.keymap.set("n", "<leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, opts)

		-- Open REPL
		vim.keymap.set("n", "<leader>dr", dap.repl.open, opts)

		-- Run last debug session
		vim.keymap.set("n", "<leader>dl", dap.run_last, opts)

		-- Terminate debug session
		vim.keymap.set("n", "<leader>dt", dap.terminate, opts)

		-- Toggle DAP UI
		vim.keymap.set("n", "<leader>du", dapui.toggle, opts)

		-- Evaluate expression
		vim.keymap.set({ "n", "v" }, "<leader>de", function()
			dapui.eval()
		end, opts)

		-- Python-specific keymaps
		vim.keymap.set("n", "<leader>dpt", function()
			if dap_python_ok then
				dap_python.test_method()
			end
		end, { desc = "Debug Python test method" })

		vim.keymap.set("n", "<leader>dpc", function()
			if dap_python_ok then
				dap_python.test_class()
			end
		end, { desc = "Debug Python test class" })
	end,
}
