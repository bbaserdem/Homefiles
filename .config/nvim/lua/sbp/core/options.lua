-- Global behavior options

local options = {
    ------------------------------
    ---- Indentation  options ----
    ------------------------------
    expandtab = true,   -- convert tabs to spaces when writing
    smartindent = true, -- make indenting smarter again
    shiftwidth = 4,     -- the number of spaces inserted for each indentation
    tabstop = 4,        -- a tab is shown as 4 spaces
    softtabstop = 4,    -- how many spaces inserted when tab is placed
    autoindent = true,  -- lines inherit the indentation of previous lines.
    breakindent = true, -- enable break indent when wrapping line

    ------------------------------
    ------- Search options -------
    ------------------------------
    ignorecase = true,  -- ignore case in search patterns
    hlsearch = true,    -- highlight all matches on previous search pattern
    smartcase = true,   -- switch to case sensitive if we use uppercase letters smart case
    incsearch = true,   -- incremental search that shows partial matches.

    ------------------------------
    ---- Performance  options ----
    ------------------------------
    lazyredraw = false, -- Don’t update screen during macro and script execution
    updatetime = 300,   -- faster completion (4000ms default)
    timeoutlen = 500,   -- time to wait for a mapped sequence to complete (in milliseconds)

    ------------------------------
    --- Text rendering options ---
    ------------------------------
    scrolloff = 5,      -- minimal number of screen lines to keep above and below the cursor
    sidescrolloff = 8,  -- minimal number of screen columns either side of cursor if wrap is `false`
    wrap = true,        -- display lines as one long line
    linebreak = true,   -- companion to wrap, don't split words
    guifont = "JetBrains Mono", -- the font used in graphical neovim applications
    syntax = "enable",  -- Enable syntax highlighting
    list = false,       -- Render whitespace characters in mute
    whichwrap = "bs<>[]",   -- which nav keys are allowed to travel to prev/next line
    numberwidth = 4,    -- set number column width to 2 {default 4}
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    conceallevel = 0,   -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file

    ------------------------------
    --------- UI options ---------
    ------------------------------
    cmdheight = 2,      -- more space in the neovim command line for displaying messages
    pumheight = 10,     -- pop up menu height
    showtabline = 2,    -- always show tabs
    mouse = "a",        -- allow the mouse to be used in neovim
    number = true,      -- set numbered lines
    relativenumber = true,  -- set relative numbered lines
    title = false,      -- the file currently being edited
    showmode = false,   -- we don't need to see things like -- INSERT -- anymore
    termguicolors = true,   -- set term gui colors (most terminals support this)
    showmatch = true,   -- Show matching brackets when text indicator is over them
    mat = 2,            -- How many tenths of a second to blink when matching brackets
    cursorline = false,     -- highlight the current line
    cursorcolumn = false,   -- highlight the current column

    ------------------------------
    -- Split options
    ------------------------------
    splitbelow = true,  -- force all horizontal splits to go below current window
    splitright = true,  -- force all vertical splits to go to the right of current window

    ------------------------------
    -- Miscellaneous options
    ----------------------------
    swapfile = true,    -- creates a swapfile
    undofile = true,    -- enable persistent undo
    -- undodir=$HOME/.local/state/nvim/undo
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    spell = false,

    ------------------------------
    -- Other options
    ------------------------------
    backup = false, -- creates a backup file
    -- clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    completeopt = "menuone,noselect", -- mostly just for cmp
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.wo.number = true
vim.wo.colorcolumn = '80'
