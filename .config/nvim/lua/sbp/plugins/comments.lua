-------------------------------------------------
-- name : Comment.nvim
-- url  : https://github.com/numToStr/Comment.nvim
---------------------------------------------------
-- Comment out blocks of text
local wk = require("which-key")

local M = {
    "numToStr/Comment.nvim",
    opts = {
        mappings = false,
    },
}

--[[
wk.register({
    c = {
        function()
        end,
        "
    },
}, {
    mode = "n",
    prefix = "<leader>e",
})
--]]

return M
