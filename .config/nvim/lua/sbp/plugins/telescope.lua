-------------------------------------------------
-- name : Telescope
-- url  : https://github.com/nvim-telescope/telescope.nvim
---------------------------------------------------
-- Telescope is a fuzzy-finder menu for a variety of lists

local M = {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope.nvim",
    }
}

return M
