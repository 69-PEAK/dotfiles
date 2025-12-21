-- ============================================================================
-- FILE: ~/.config/nvim/lua/vim-options.lua
-- ============================================================================
-- Basic settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Close floating windows with q (safe for macros)
vim.keymap.set("n", "q", function()
	if vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).relative ~= "" then
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
	end
end, { desc = "Close floating window", silent = true })

-- Smart <Esc>: close floats, quickfix, clear highlights
vim.keymap.set("n", "<Esc>", function()
	local win = vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win)

	if cfg.relative and cfg.relative ~= "" then
		vim.api.nvim_win_close(win, false)
		return
	end

	-- Close quickfix or location list if open
	if vim.bo.filetype == "qf" or vim.fn.getwininfo(win)[1].loclist == 1 then
		vim.cmd("cclose | lclose")
		return
	end

	-- Clear search highlights
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
end, { desc = "Smart Esc: close float/qf or clear hlsearch", silent = true })

-- Options
vim.opt.cmdheight = 0
vim.opt.equalalways = false
