------------------
-- Color Themes --
------------------
local M = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            integrations = {
                aerial = true,
                alpha = false,
                barbar = true,
                cmp = true,
                dashboard = true,
                dropbar = { enabled = true, },
                gitsigns = true,
                mason = true,
                notify = true,
                nvimtree = true,
                treesitter = true,
                treesitter_context = true,
                symbols_outline = true,
                telescope = { enabled = true, },
                lsp_trouble = true,
                which_key = true,
            },
        },
        config = function(plugin)
            require("catppuccin").setup(plugin.opts)
            vim.cmd("colorscheme catppuccin")
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        opts = {
            options = {
                transparent = true,
                styles = {  -- Style to be applied to different syntax groups
                    -- comments = 'NONE',
                    -- functions = 'NONE',
                    -- keywords = 'NONE',
                    -- variables = 'NONE',
                    conditionals = 'italic',
                    constants = 'bold',
                    -- numbers = 'NONE',
                    -- operators = 'NONE',
                    -- strings = 'NONE',
                    -- types = 'NONE',
                },          -- Value is any valid `:help attr-list`
                darken = {
                    floats = true,
                },
            }
        },
        config = function(plugin)
            require("github-theme").setup(plugin.opts)
        end,
    },
    {
        "rose-pine/neovim",
        lazy = false,
        name = "rose-pine",
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {
            transparent = true,
        },
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        opts = { transparent = true },
    },
}

return M
