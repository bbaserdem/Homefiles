-------------------------------------------------
-- name : Toggleterm
-- url  : https://github.com/akinsho/toggleterm.nvim
---------------------------------------------------
-- Toggleterm is an improvement on nvim's terminal implementation
local wk = require("which-key")

local M = {
    "akinsho/toggleterm.nvim",
    opts = {
        open_mapping = false,
        start_in_insert = true,
        insert_mappings = false,
        terminal_mappings = true,
        direction = "float",
        close_on_exit = true,
    },
    lazy = false,
}

wk.register({
    ["<Tab>"] = {
        function()
            require("toggleterm").toggle()
        end,
        "Launch terminal",
    },
}, {
    mode = "n",
    prefix = "<leader>",
})
wk.register({
    ["<Esc>"] = {
        function()
            require("toggleterm").toggle()
        end,
        "Launch terminal",
    },
}, {
    mode = "t",
})

return M
