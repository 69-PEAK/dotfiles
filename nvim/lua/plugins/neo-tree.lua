-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/neo-tree.lua
-- ============================================================================
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local status_ok, neotree = pcall(require, "neo-tree")
    if not status_ok then
      return
    end
    
    neotree.setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
          ".DS_Store",
          "thumbs.db",
        },
        never_show = {  -- Remains hidden even when pressing H in tree
          ".DS_Store",
        },
        follow_current_file = { enabled = true, },
        use_libuv_file_watcher = true,
      },

      window = {
        position = "left",
        width = 25,
        mappings = {
          ["<space>"] = "none",
          ["<C-f>"] = "none",
        },
       auto_resize = true,
      },
    }
  })
    
    -- Neo-tree keymaps
    vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", { silent = true })
    vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { silent = true })
  end,
}
