--------------------------------------------------------
-- Plugins
--------------------------------------------------------
-- Small plugins get imported here
return{
    -- Close buffer without closing the window
    { "famiu/bufdelete.nvim", },
    -- Lock buffer to window to prevent some deactivations
    { "stevearc/stickybuf.nvim", },
    --[[ Source code bar
    { "Bekaboo/dropbar.nvim",
        lazy = false,
    },
    --]]
    -- URL browser
    -- Indentation tracker
    { "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            scope = {
                enabled = true,
                -- char = "a",
                show_start = true,
                show_end = true,
                injected_languages = true,
            },
        },
        lazy = false,
    },
    -- Scrollbar
    { "petertriho/nvim-scrollbar",
        lazy = false,
    },
    -- Tmux integration
    { "aserowy/tmux.nvim",
        lazy = false,
    },
}
