-------------------------------------------------
-- Markdown behavior
---------------------------------------------------
-- Custom functionality
local wk = require("which-key")
local buf = vim.api.nvim_get_current_buf()

-- Do syntax highlighting for infinite distance
vim.api.nvim_create_autocmd(
    "FileType",
    {
        group = vim.api.nvim_create_augroup(
            "MarkdownHighlight",
            { clear = true, }
        ),
        pattern = { "markdown", },
        command = "syntax sync fromstart",
    }
)

-- Register keybinds
wk.register({
    f = {
        name = "Markdown actions",
        p = {
            "<cmd>Glow<CR>",
            "(P)review markdown text",
        },
        buffer = buf,
    },
}, {
    mode = "n",
    prefix = "<leader>",
})
