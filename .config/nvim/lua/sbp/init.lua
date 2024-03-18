-- Set leader key at earliest possible; for which-key
local keymap = vim.api.nvim_set_keymap
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load plugins
require("sbp.lazy-nvim")

-- Load utility stuff
require("sbp.util")

-- Load main options
require("sbp.core")
