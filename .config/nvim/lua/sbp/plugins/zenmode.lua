-------------------------------------------------
-- name : True Zen
-- url  : https://github.com/pocco81/true-zen.nvim
---------------------------------------------------
-- Zen mode related things that enable good options
local wk = require("which-key")

local M = {
    {
        "pocco81/true-zen.nvim",
        opts = {
            integrations = {
                lualine = true,
            },
        },
    }, {
        "folke/twilight.nvim",
    },
}

-- Select mode keybinds
wk.register({
    -- Zen mode - narrow text
    n = {
        function()
            local first = vim.fn.line('v')
            local last = vim.fn.line('.')
            require('true-zen').narrow(first, last)
        end,
        "Narrow view mode: (n)arrow",
    },
}, {
    mode = "x",
    -- UI manipulation
    prefix = "<leader>u",
})
wk.register({
    -- Zen mode - narrow text
    a = {
        function()
            require("true-zen").ataraxis()
        end,
        "Toggle zen mode: (a)taraxis",
    },
    m = {
        function()
            require('true-zen').minimalist()
        end,
        "Toggle minimalist zen mode: (m)inimalist",
    },
    f = {
        function()
            require('true-zen').focus()
        end,
        "Focus the current window: (f)ocus",
    },
    n = {
        function()
            local first = 0
            local last = vim.api.nvim_buf_line_count(0)
            require("true-zen").narrow(first, last)
        end,
        "Narrow view mode: (n)arrow",
    },
    d = {
        function()
            require("twilight").toggle()
        end,
        "Twilight: (d)im inactive code",
    },
}, {
    mode = "n",
    -- UI manipulation
    prefix = "<leader>u",
})

return M
