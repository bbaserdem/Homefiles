-------------------------------------------------
-- name : Startup.Nvim
-- url  : https://github.com/startup-nvim/startup.nvim
-------------------------------------------------
-- Starting screen for neovim
local M = {
    "startup-nvim/startup.nvim",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim"
    },
    opts = {
        theme = "dashboard",
    },
}

return M
