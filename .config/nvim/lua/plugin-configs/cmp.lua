----------------------
--- Autocompletion ---
----------------------
--Preload
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local devicons = require('nvim-web-devicons')

-- Export these
M = {}

-- Check if there is a word before this
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(
        0,
        line - 1,
        line,
        true
    )[1]:sub(col, col):match('%s') == nil
end
M.has_words_before = has_words_before

local format_style = function(entry, vim_item)
    if vim.tbl_contains({ 'path' }, entry.source.name) then
        local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
        if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
        end
    end
    return lspkind.cmp_format({ with_text = false })(entry, vim_item)
end
M.format_style = format_style

cmp.setup({
    -- Enable when not in comment block
    enabled = true,
    -- Sources for completion
    sources = cmp.config.sources({
        { priority = 6, name = 'luasnip' },
        { priority = 7, name = 'nvim_lua' },
        { priority = 8, name = 'nvim_lsp' },
        { priority = 4, name = 'nvim_lsp_signature_help' },
        { priority = 2, name = 'tmux' },
        { priority = 6, name = 'treesitter' },
        { priority = 4, name = 'path' },
        { priority = 5, name = 'buffer' },
        { priority = 3, name = 'buffer-lines' },
        --{ name = 'omni' },
    }, {
        { priority = 3, name = 'nerdfont',  option = { insert = true, } },
        { priority = 3, name = 'emoji',     option = { insert = true, } },
        { priority = 5, name = 'greek',     option = { insert = true, } },
        { priority = 1, name = 'digraphs' },
    }),
    -- Menu type
    view = {
        entries = {
            name = 'custom',
            selection_order = 'near_cursor',
        },
    },
    -- Display
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return lspkind.cmp_format({ with_text = false })(entry, vim_item)
        end
    },
    -- Snippets
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else                                                        -- Do whatever
                fallback()
            end
        end, {"i", "s"}),
    },
    sorting = {
        comparators = {
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.order,
            cmp.config.compare.sort_text,
            cmp.config.compare.exact,
            cmp.config.compare.kind,
        },
    },
})

-- Enable for commit messages
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    })
})

-- Command line completion
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'cmp-cmdline-history' },
    }, {
        { name = 'path' },
        { name = 'buffer' },
    })
})


cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'nvim_lsp_document_symbol' }
    }, {
        { name = 'buffer' },
    })
})

return M
