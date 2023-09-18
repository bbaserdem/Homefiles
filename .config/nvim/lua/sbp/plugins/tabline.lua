-------------------------------------------------
-- name : Barbar
-- url  : https://github.com/romgrk/barbar.nvim
---------------------------------------------------
-- Barbar shows tabs in tabline; and makes them clickable

local M = {
    "romgrk/barbar.nvim",
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {
        letters = "aoeuhtnsidbmqjkx;wcr,.pgyf'lAOEUHTNSIDBMQJKX:WCR<>PGYF\"L",
    },
    lazy = false,
}

return M
