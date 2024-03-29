-- | |        | (___ | |__) | | (___     ___ _ ____     _____ _ __ ___
-- | |         \___ \|    ___/     \___ \ / _ \ '__\ \ / / _ \ '__/ __|
-- | |____ ____) | |             ____) |    __/ |     \ V /    __/ |    \__ \
-- |______|_____/|_|            |_____/ \___|_|        \_/ \___|_|    |___/
--

-- LSP server installer, that also sets the servers up
local installer_ok, installer = pcall(require, 'nvim-lsp-installer')
if not installer_ok then
    print('Nvim-lsp-installer could not run\n' .. installer .. '\n')
end
local loader_ok, loader = pcall(require, 'lspconfig')
if not loader_ok then
    error('Nvim-lspconfig could not run\n' .. loader .. '\n')
end
M = {}

local local_servers = {
    -- Cmake
    'cmake',
    -- JSON
    'jsonls',
    -- Markdown
    'prosemd_lsp',
    -- Spellcheck
    'ltex',
}
M.default_servers = local_servers

--[[------------------------------------------------------------------------]]--
--[[-------------------------- DIAGNOSTYC CONFIGS --------------------------]]--
--[[------------------------------------------------------------------------]]--

--[[.....Gutter signs for diagnostic prompts................................]]--
local signs = {
    Error     =     "",
    Warn        =     "",
    Hint        =     "ﯦ",
    Info        =     "",
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

--[[.....Diagnostics prompt configuration...................................]]--
vim.diagnostic.config({
    underline = true,
    virtual_text = {
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
        source = "if_many",
    },
    signs = true,
    update_in_insert = false,
    float = {
        source = 'always',
        scope = 'cursor',
        border = 'single',
        header = '',
        prefix = ' ',
    },
    severity_sort = true,
})

--[[.....LSP Installer settings.............................................]]--
installer.setup({
    automatic_installation = true,
    ensure_installed = local_servers,
    max_concurrent_installers = 2,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})
--[[------------------------------------------------------------------------]]--
--[[----------------------- COMMON CONFIGURATION ---------------------------]]--
--[[------------------------------------------------------------------------]]--
--[[.....Buffer-local options to apply on attach............................]]--
local common_on_attach = function (client, bufnr)
    vim.api.nvim_create_autocmd( 'CursorHold', {
        group = vim.api.nvim_create_augroup(
            'LspDiagnosticsOnHover',
            { clear = true, }
        ),
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = {
                    --'BufLeave',
                    'CursorMoved',
                    --'InsertEnter',
                    --'FocusLost',
                },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(opts)
        end
    })
end
M.on_attach = common_on_attach

-- Get capabilities
local common_capabilities = vim.lsp.protocol.make_client_capabilities()
-- Add nvim-cmp
local cmp_lsp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_lsp_ok then
    common_capabilities = cmp_lsp.default_capabilities(common_capabilities)
    common_capabilities.textDocument.completion.completionItem.snippetSupport = true
end

M.capabilities = common_capabilities

--[[------------------------------------------------------------------------]]--
--[[--------------------- LOCAL SERVER APPLICATION -------------------------]]--
--[[------------------------------------------------------------------------]]--
-- LTeX; spellchecker
loader.ltex.setup({
    on_attach = common_on_attach,
    capabilities = common_capabilities,
    filetypes = {
        'tex',
        'bib',
        'gitcommit',
        'markdown',
        'org',
        'rst',
        'rnoweb',
    },
})
-- TexLab; latex LSP
loader.texlab.setup({
    on_attach = common_on_attach,
    capabilities = common_capabilities,
})
-- Lua
--local runtime_path = vim.split(package.path, ';')
--table.insert(runtime_path, "lua/?.lua")
--table.insert(runtime_path, "lua/?/init.lua")
loader.lua_ls.setup {
    on_attach = common_on_attach,
    capabilities = common_capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                --path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
        autostart = true,
    },
}

--return M
