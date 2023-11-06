------------------------------------------------
-- Git integration
---------------------------------------------------
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
local wk = require("which-key")
local gs = require("gitsigns")

function _lazygit_toggle()
    lazygit:toggle()
end

-- Put in keycodes for terminal launching and git actions
wk.register({
    g = {
        "Git",
        g = {
            function()
                _lazygit_toggle()
            end,
            "Launch lazygit",
        },
        s = {
            function()
                gs.stage_hunk()
            end,
            "Stage this hunk",
        },
        r = {
            function()
                gs.reset_hunk()
            end,
            "Reset this hunk",
        },
        S = {
            function()
                gs.stage_buffer()
            end,
            "Stage the entire buffer",
        },
        R = {
            function()
                gs.stage_buffer()
            end,
            "Reset this buffer",
        },
        u = {
            function()
                gs.undo_stage_hunk()
            end,
            "Undo staging",
        },
        p = {
            function()
                gs.preview_hunk()
            end,
            "Preview this hunk",
        },
        B = {
            function()
                gs.blame_line({full = true, })
            end,
            "Run blame on this line",
        },
        b = {
            function()
                gs.toggle_current_line_blame()
            end,
            "Toggle the blame on this line",
        },
        d = {
            function()
                gs.diffthis()
            end,
            "Show diff of this line",
        },
        D = {
            function()
                gs.diffthis()
            end,
            "Show diff of all the lines",
        },
        x = {
            function()
                gs.toggle_deleted()
            end,
            "Toggle deleted lines",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})
wk.register({
    g = {
        "Git",
        s = {
            function()
                gs.stage_hunk({
                    vim.fn.line('.'),
                    vim.fn.line('v'),
                })
            end,
            "Stage the selected hunk",
        },
        r = {
            function()
                gs.reset_hunk({
                    vim.fn.line('.'),
                    vim.fn.line('v'),
                })
            end,
            "Reset the selected hunk",
        },
    },
}, {
    mode = "x",
    prefix = "<leader>",
})
