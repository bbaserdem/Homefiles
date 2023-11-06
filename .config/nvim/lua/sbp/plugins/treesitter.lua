-------------------------------------------------
-- name : Treesitter
-- url  : https://github.com/nvim-treesitter/nvim-treesitter
---------------------------------------------------
-- Treesitter is a parser generator and parser library tool.
-- It collects the syntax tree of code and displays it
local M = {
    "nvim-treesitter/nvim-treesitter",
    --version="0.9.0",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    event = "BufReadPost",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-treesitter/nvim-treesitter-context",
            config = true,
            keys = {
                { "<leader>uc", ":TSContextToggle<CR>", desc = "Toggle TSContext" },
                {
                    "[c",
                    ":lua require('treesitter-context').go_to_context()<cr>",
                    silent = true,
                    desc = "Go to context",
                },
            },
        },
        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
    },
    opts = {
        ensure_installed = {
            "bash",
            "bibtex",
            "c",
            "comment",
            "cpp",
            "css",
            "csv",
            "cuda",
            "diff",
            "dockerfile",
            "gitignore",
            "gitcommit",
            "git_rebase",
            "json",
            "jq",
            "latex",
            "lua",
            "markdown",
            "markdown_inline",
            "matlab",
            "nix",
            "python",
            "sql",
            "sxhkdrc",
            "vim",
            "xml",
            "yaml",
            "yuck",
        },
        context_commentstring = { -- nvim-ts-context-commentstring
            enable = true,
        },
        autotag = { -- nvim-ts-autotag
            enable = true
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                -- init_selection = "<c-space>",
                -- node_incremental = "<c-space>",
                -- scope_incremental = "<c-s>",
                -- node_decremental = "<c-backspace>",
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            -- lint_events = { "BufWrite", "CursorHold" },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = false,
            keybindings = {
                toggle_query_editor = "o",
                toggle_hl_groups = "i",
                toggle_injected_languages = "t",
                toggle_anonymous_nodes = "a",
                toggle_language_display = "I",
                focus_language = "f",
                unfocus_language = "F",
                update = "R",
                goto_node = "<cr>",
                show_help = "?",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}

return { M }
