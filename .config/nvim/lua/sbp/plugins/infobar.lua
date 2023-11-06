-------------------------------------------------
-- name : nvim-lualine
-- url  : https://github.com/nvim-lualine/lualine.nvim
-------------------------------------------------
local M = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "catppuccin/nvim",
        "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
}

function M.config()
    local my_filename = require("lualine.components.filename"):extend()
    my_filename.apply_icon = require("lualine.components.filetype").apply_icon
    my_filename.colored = true

    local filename_with_path = {
        my_filename,
        path = 1,
        symbols = {
            modified = " ",
            readonly = "",
            unnamed  = " ",
        },
    }

    require("lualine").setup({
        options = {
            theme = "catppuccin",
            icons_enabled = true,
            -- globalstatus = true, -- to have just one lualine, the inactive_* won't work
            component_separators = {
                left = '',
                right = '',
            },
            section_separators = {
                left = '',
                right = '',
            },
        },
        sections = {
            lualine_a = {'mode'},
            -- Switch to vim-fugitive
            -- lualine_b = { {'FugitiveHead', icon = ''}, },
            -- lualine_b = { {'b:gitsigns_head', icon = ''}, },
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = { filename_with_path },
            lualine_x = {'lazy', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = { "filename" },
            lualine_c = { filename_with_path },
            lualine_y = {
                {
                    "datetime",
                    style = "default", -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
                },
            },
        },
        extensions = {
            "aerial",
            "fugitive",
            "lazy",
            "nvim-tree",
            "quickfix",
            "symbols-outline",
            "trouble",
        },
    })
end

return M
