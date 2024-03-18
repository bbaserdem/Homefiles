-------------------------------------------------
-- Markdown behavior
---------------------------------------------------
-- Custom functionality
local wk = require("which-key")
local buf = vim.api.nvim_get_current_buf()

-- Register keybinds
wk.register({
    ["<F5>"] = {
        "<cmd>VimtexCompile<CR>",
        "Build LaTeX file",
    },
    f = {
        name = "LaTeX actions",
        n = {
            "<cmd>VimtexView<CR>",
            "Forward search on pdf viewer",
        },
        x = {
            "<cmd>VimtexClean<CR>",
            "Clean the build files",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
    buffer = buf,
})
