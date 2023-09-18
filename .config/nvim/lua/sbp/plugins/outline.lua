-------------------------------------------------
-- Outline generator
-- name : Aerial
-- url  : https://github.com/simrat39/stevearc/aerial.nvim
-------------------------------------------------
-- Generate a list of symbors in the document.
-- Symbols outline uses the LSP, and is more tree-like
-- Aerial uses treesitter to do this
local wk = require("which-key")

local M = {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        backends = {
            "lsp",
	        "treesitter",
	        "markdown",
	        "man"
        },
        layout = {
	        max_width = { 40, 0.2 },
	        min_width = 20,
        },
    },
}

wk.register({
    o = {
        function()
            require("aerial").toggle()
        end,
        "Show symbols outline",
    },
}, {
    -- UI monipulation
    mode = "n",
    prefix = "<leader>u",
})

return M
