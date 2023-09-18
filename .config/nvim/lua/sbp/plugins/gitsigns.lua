-------------------------------------------------
-- name : Git Signs
-- url  : https://github.com/lewis6991/gitsigns.nvim
---------------------------------------------------
-- Git decoration implementation
local wk = require("which-key")

M = {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add          = { text = '' },
            change       = { text = '' },
            delete       = { text = '' },
            topdelete    = { text = '' },
            changedelete = { text = '' },
            untracked    = { text = '' },
        },
        signcolumn = true,
        watch_gitdir = {
            follow_files = true,
        },
    },
    lazy = false,
}

return M
