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
        dependencies = { "nvim-treesitter/nvim-treesitter", },
        opts = {
            space_char_blankline = " ",
            show_current_context = true,
            show_current_context_start = true,
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
