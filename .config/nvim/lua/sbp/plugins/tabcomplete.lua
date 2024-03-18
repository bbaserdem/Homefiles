-------------------------------------------------
-- Tab (Auto)complete
-- name : Nvim cmp
-- url  : https://github.com/hrsh7th/nvim-cmp
-- name : LuaSnip
-- url  : https://github.com/L3MON4D3/LuaSnip
---------------------------------------------------
-- cmp is an autocomplete manager, brings multiple suggestions together.
-- There are many extensions to give it completion sources
-- It is loaded automatically at startup.

-- Function to check if there is text before cursor
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
	    {
            "L3MON4D3/LuaSnip",
            dependencies = { "rafamadriz/friendly-snippets" },
	        opts = {},
	        build = "make install_jsregexp",
	    },
	    "saadparwaiz1/cmp_luasnip",
	    "hrsh7th/cmp-buffer",
	    "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
	    "hrsh7th/cmp-nvim-lsp-signature-help",
        "kdheepak/cmp-latex-symbols",
        "chrisgrieser/cmp-nerdfont",
    },
    opts = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        --  vim.opt.runtimepath:append("~/github/lsp_signature.nvim")

        return {
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = cmp.config.sources({
                -- { name = "nvim_lsp_signature_help" }, --
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
                { name = "latex_symbols" },
                { name = "nerdfont" },
            }),
            mapping = {
                ["<Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                    { "i", "s", }
                ),
                ["<S-Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                    { "i", "s", }
                ),
            },
        }
    end,
}
