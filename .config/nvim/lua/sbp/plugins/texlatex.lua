-------------------------------------------------
-- name : VimTex
-- url  : https://github.com/lervag/vimtex
-------------------------------------------------
-- Latex integration

local M = {
    { "lervag/vimtex",
        ft = {
            "latex",
            "tex",
            "bib",
        },
        cmd = "VimtexInverseSearch",
        init = function()
            vim.g.vimtex_mappings_enabled = 0
            vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_compiler_progname = 'nvr'
            vim.g.vimtex_quickfix_ignore_filters = {
                'Underfull',
                'Overfull',
                'Float too large',
                'Package siunitx Warning',
            }
        end,
    },
}

return M
