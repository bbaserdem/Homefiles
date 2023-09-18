-------------------------------------------------
-- name : Telescope
-- url  : https://github.com/nvim-telescope/telescope.nvim
---------------------------------------------------
-- Telescope is a fuzzy-finder menu for a variety of lists
local wk = require("which-key")

local M = {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope.nvim",
        "stevearc/aerial.nvim",
        "rcarriga/nvim-notify",
    }
}

function M.config(_, opts)
    -- Load needed extentions
    -- require("telescope").load_extension("notify")
    -- Load options
    require("telescope").setup(opts)
end

wk.register({
    -- UI functions
    u = {
        c = {
            function()
                require("telescope.builtin").colorscheme()
            end,
            "Show and pick (c)olorschemes",
        },
    },
    --[[ System functions
    s = {
        n = {
            require("telescope").extensions.notify.notify,
            "Show history of (n)otifications.",
        },
    },
    --]]
    -- Navigation
    n = {
        o = {
            function()
                require("telescope.builtin").find_files()
            end,
            "Search and (o)pen a new file",
        },
        s = {
            function()
                require('telescope.builtin').live_grep()
            end,
            "Live (s)earch the current buffer",
        },
        S = {
            require("telescope").extensions.aerial.aerial,
            "(S)earch the symbols in current buffer",
        },
        b = {
            function()
                require('telescope.builtin').buffers()
            end,
            "Show and pick (b)uffer",
        },
        t = {
            function()
                require('telescope.builtin').tags()
            end,
            "Show and pick (t)ags",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",

})

return M
