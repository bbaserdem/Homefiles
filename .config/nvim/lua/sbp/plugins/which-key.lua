-------------------------------------------------
-- name : Which Key
-- url  : https://github.com/folke/which-key.nvim
---------------------------------------------------
-- Which Key is a popup message that explains keybinds recursively
-- All keybinds are using which-key

return {
    "folke/which-key.nvim",
    keys = { { "<leader>" } },
    opts = {
        -- Shows a list of marks on ' and `
        marks = true,
        -- Show WhichKey at z= to select spelling suggestions
        spelling = {
            enabled = true,
            suggestions = 5,
        },
        window = {
            border = "rounded",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 1, 2, 1, 2 },
        },
        icons = {
            breadcrumb = "",
            separator = "",
            group = "",
        },
    },
}
