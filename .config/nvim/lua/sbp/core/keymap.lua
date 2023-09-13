------------------------------
-- Keymaps 
------------------------------
local wk = require("which-key")
-- The keymap uses Which Key as documentation
-- Modes available:
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

------------------------
-- Quick Keys
------------------------
-- These, when held should repeat action and don't use which-key

wk.register({
    -- Navigate windows
    ["<C-h>"] = { "<cmd>wincmd h<cr>",
        "Switch to left window split", },
    ["<C-l>"] = { "<cmd>wincmd l<cr>",
        "Switch to right window split", },
    ["<C-j>"] = { "<cmd>wincmd j<cr>",
        "Switch to bottom window split", },
    ["<C-k>"] = { "<cmd>wincmd k<cr>",
        "Switch to top window split", },
    -- Resize windows 
    ["<C-Left>"] = { "<cmd>vertical resize -2<cr>",
        "Move split bar left", },
    ["<C-Right>"] = { "<cmd>vertical resize +2<cr>",
        "Move split bar right", },
    ["<C-Down>"] = { "<cmd>resize +2<cr>",
        "Move split bar down", },
    ["<C-Up>"] = { "<cmd>resize -2<cr>",
        "Move split bar up", },
    -- Move buffers
    ["<C-n>"] = { "<cmd>bnext<cr>",
        "Switch to next buffer", },
    ["<C-p>"] = { "<cmd>bprevious<cr>",
        "Switch to previous buffer", },
    -- Move screen
    ["<C-d>"] = { "<C-d>zz",
        "Move half screen down", },
    ["<C-u>"] = { "<C-u>zz",
        "Move half screen up", },
    -- Move text on line or selection
    ["<A-j>"] = { "<cmd>m .+1<cr>==",
        "Move line one down", },
    ["<A-k>"] = { "<cmd>m .-2<cr>==",
        "Move line one up", },
}, {
    mode = "n",
    prefix = "",
})
-- Select mode
wk.register({
    -- Move text on line or selection
    ["<A-j>"] = { "<cmd>m '>+1<cr>gv=gv",
        "Move selection one down", },
    ["<A-k>"] = { "<cmd>m '<-2<cr>gv=gv",
        "Move selection one up", },
    -- Stay on indent
    ["<"] = { "<gv", "Indent in, but keep selection" },
    [">"] = { ">gv", "Indent out, but keep selection" },
    -- Searches for the current selection
    ["*"] = { ":<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>",
        "Search selection", },
    ["#"] = { ":<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>",
        "Search selection", },
}, {
    mode = "x",
    prefix = "",
})

-------------------------------------
-- Clipboard
-------------------------------------
wk.register({
    ["<C-v>"] = { "\"+p", "(Paste) Put from clipboard"},
}, {
    mode = "n",
    prefix = "<leader>",
})
wk.register({
    ["<C-c>"] = { "\"+y", "(Copy) Yank to clipboard"},
    ["<C-x>"] = { "\"+d", "(Cut) Delete to clipboard"},
    ["<C-v>"] = { "\"+p", "(Paste) Put from clipboard"},
}, {
    mode = "x",
    prefix = "<leader>",
})

-------------------------------------
-- Search and replace
-------------------------------------
wk.register({
    ["/"] = { ":%s///g<left><left><left>",
        "Search and replace" },
}, {
    mode = "n",
    prefix = "<leader>",
    silent = false,
})

-------------------------------------
-- Main keybinds
-------------------------------------
wk.register({
    -- UI manipulation
    u = { name = "UI functions",
        s = { "<cmd>setlocal spell!<cr>",
            "Toggle spellchecker", },
        p = { "<cmd>setlocal paste!<cr>",
            "Toggle paste mode", },
        ["/"] = { "<cmd>nohlsearch<cr>",
            "Turn of search highlighting",  },
        c = { function()
                require('telescope.builtin').colorscheme()
            end,
            "Show and pick (c)olorschemes", },
    },
    -- Navigation
    n = { name = "Navigation",
        q = { "<cmd>qa<CR>",
            "(q)uit NeoVIM", },
        Q = { "<cmd>qa!<CR>",
            "(Q)uit NeoVIM WITHOUT saving!", },
        w = { "<cmd>qa<CR>",
            "Save current buffer", },
        W = { "<cmd>qa!<CR>",
            "Save all buffers", },
        [","] = { "<cmd>vsplit<CR>",
            "Split window vertically", },
        ["."] = { "<cmd>vsplit<CR>",
            "Split window horizontally", },
        ["'"] = { "<cmd>tabnew<CR>",
            "Open a new tab", },
        x = { "<cmd>close<CR>",
            "Close current split window", },
        X = { "<cmd>tabclose<CR>",
            "Close current tab", },
        n = { "<cmd>enew<CR>",
            "Create (n)ew empty buffer", },
        o = { function()
                require('telescope.builtin').find_files()
            end,
            "Search and (o)pen a new file", },
        s = { function()
                require('telescope.builtin').live_grep()
            end,
            "Live (s)earch the current buffer", },
        b = { function()
                require('telescope.builtin').buffers()
            end,
            "Show and pick (b)uffer", },
        d = { function()
                require('bufdelete').bufdelete(0, false)
            end,
            "(d)elete this buffer", },
        D = { function()
                require('bufdelete').bufdelete(0, true)
            end,
            "(D)elete this buffer WITHOUT saving!", },
        t = { function()
                require('telescope.builtin').tags()
            end,
            "Show and pick (t)ags", },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})
