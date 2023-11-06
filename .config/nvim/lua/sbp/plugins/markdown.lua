-------------------------------------------------
-- name : Glow
-- url  : https://github.com/nvim-telescope/telescope.nvim
-- name : MkdnFlow
-- url  : https://github.com/jakewvincent/mkdnflow.nvim
---------------------------------------------------
-- Telescope is a fuzzy-finder menu for a variety of lists
-- Mkdnflow allows navigating to different files using markdown 
local wk = require("which-key")

local M = {
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd = "Glow"
    },
    {
        "jakewvincent/mkdnflow.nvim",
    },
}
return M
