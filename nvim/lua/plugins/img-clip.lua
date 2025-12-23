-- ============================================================================
-- FILE: ~/.config/nvim/lua/plugins/img-clip.lua
-- ============================================================================

return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",

  opts = {
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = {
        insert_mode = true,
      },
      use_absolute_path = false,
      dir_path = "assets/images",
      file_name = "%Y-%m-%d-%H-%M-%S",
      process_cmd = "",
      formats = { "png", "jpg", "jpeg", "gif", "webp", "avif" },
    },

    filetypes = {
      markdown = {
        url_encode_path = true,
        template = "![$CURSOR]($FILE_PATH)",
        drag_and_drop = {
          download_images = false,
        },

        -- Custom directory:  saves to ./assets/images/
        dir_path = function()
          local current_file = vim.api.nvim_buf_get_name(0)
          local current_dir = vim.fn.fnamemodify(current_file, ":h")
          local img_dir = current_dir .. "/assets/images"
          vim.fn.mkdir(img_dir, "p")
          return img_dir
        end,

        -- Custom filename: markdown-filename_YYYY-MM-DD-HH-MM-SS.png
        file_name = function()
          local current_file = vim.fn.expand("%:t:r")
          local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
          return current_file .. "_" .. timestamp
        end,
      },
    },
  },

  keys = {

    -- Paste image from clipboard
    { "<leader>v", "<cmd>PasteImage<cr>", desc = "Paste Image from Clipboard" },

    -- Open image under cursor in Preview.app
    {
      "<leader>io",
      function()
        local file = vim.fn.expand("<cfile>")
        if
          file:match("%.png$")
          or file:match("%.jpg$")
          or file:match("%.jpeg$")
          or file:match("%.gif$")
          or file:match("%.webp$")
          or file:match("%.avif$")
        then
          vim.cmd("silent ! open " .. vim.fn.shellescape(file))
        else
          vim.notify("Not an image file", vim.log.levels.WARN)
        end
      end,
      desc = "Open Image in Preview.app",
    },

    -- Show image in Finder
    {
      "<leader>if",
      function()
        local file = vim.fn.expand("<cfile>")
        if
          file:match("%.png$")
          or file:match("%.jpg$")
          or file:match("%.jpeg$")
          or file:match("%.gif$")
          or file:match("%.webp$")
          or file:match("%.avif$")
        then
          vim.cmd("silent ! open -R " .. vim.fn.shellescape(file))
        else
          vim.notify("Not an image file", vim.log.levels.WARN)
        end
      end,
      desc = "Show Image in Finder",
    },

    -- Preview Markdown file in web browser
    {
  "<leader>mp",
  function()
    local file = vim.fn.expand("%:p")
    if file:match("%.md$") or file:match("%.markdown$") then
      local html_file = vim.fn.tempname() .. ".html"
      local cmd = "pandoc " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(html_file) .. " && open " .. vim.fn.shellescape(html_file)
      vim.cmd("silent !" .. cmd)
    else
      vim.notify("Not a Markdown file", vim.log.levels.WARN)
    end
  end,
  desc = "Preview Markdown in Browser",
},

    -- Convert image format and resize
    {
      "<leader>ic",
      function()
        local file = vim.fn.expand("<cfile>")

        if
          not (
            file:match("%.png$")
            or file:match("%.jpg$")
            or file:match("%.jpeg$")
            or file:match("%.gif$")
            or file:match("%.webp$")
            or file:match("%.avif$")
          )
        then
          vim.notify("Not an image file", vim.log.levels.WARN)
          return
        end

        local format = vim.fn.input("Convert to format (png/jpg/webp): ")
        if format == "" then
          return
        end

        local width = vim.fn.input("Resize width (leave empty to keep original): ")
        local output = vim.fn.fnamemodify(file, ":r") .. "_converted." .. format
        local cmd = "magick " .. vim.fn.shellescape(file)

        if width ~= "" then
          cmd = cmd .. " -resize " .. width
        end

        cmd = cmd .. " " .. vim.fn.shellescape(output)
        vim.fn.system(cmd)

        if vim.v.shell_error == 0 then
          vim.notify("Converted:  " .. output, vim.log.levels.INFO)
        else
          vim.notify("Conversion failed", vim.log.levels.ERROR)
        end
      end,
      desc = "Convert Image Format/Size",
    },
  },
}