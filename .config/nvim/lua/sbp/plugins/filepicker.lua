-------------------------------------------------
-- name : nvim-tree
-- url  : https://github.com/nvim-tree/nvim-tree.lua
-------------------------------------------------
-- Nvim-tree is a file browser menu
local wk = require("which-key")

local M = {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
}

function M.config()
    require("nvim-tree").setup({
        -- Don't disable netrw, but hijack the file browser
        disable_netrw = false,
        hijack_netrw = true,
        -- General options
        sort_by = "case_sensitive",
        view = {
            relativenumber = true,
            width = function()
                return math.floor(vim.opt.columns:get() * 0.2)
            end,
        },
        renderer = {
            highlight_opened_files = "all",
            highlight_modified = "all",
            group_empty = true,
        },
        update_focused_file = {
            enable = true,
            debounce_delay = 15,
            update_root = false,
            ignore_list = {},
        },
        filters = {
            dotfiles = true,
        },
    })
    -- Open file when we create one
    local api = require("nvim-tree.api")
    api.events.subscribe(api.events.Event.FileCreated, function(file)
        vim.cmd("edit " .. file.fname)
    end)
end

wk.register({
    -- Navigation mode
    e = {
        function()
            require("nvim-tree.api").tree.focus()
        end,
        "Enter file (e)xplorer",
    },
    E = {
        function()
            require("nvim-tree.api").tree.toggle()
        end,
        "Toggle file (E)xplorer visibility",
    },
    ["<C-e>"] = {
        function()
            require("nvim-tree.api").tree.toggle({
                find_file = true,
                focus = true,
            })
        end,
        "Find current buffer in file (e)xplorer",
    },
    ["<A-e>"] = {
        function()
            require("nvim-tree.api").tree.collapse_all(true)
        end,
        "Collapse unneeded folders in file (e)xplorer",
    },
}, {
    mode = "n",
    prefix = "<leader>n",
})

return M
