-------------------------------------------------
-- name : UrlView
-- url  : https://github.com/axieax/urlview.nvim
---------------------------------------------------
-- Extracts and exposes urls in a document
local wk = require("which-key")

local M = {
    "axieax/urlview.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        default_picker = "telescope",
    },
}

wk.register({
    -- Actions
    a = {
        u = {
            function()
                require("urlview").search()
            end,
            "Search for (u)rls",
        },
    },
    -- System
    s = {
        u = {
            function()
                require("urlview").search("lazy")
            end,
        "Get the (u)rls for plugins",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})

return M
