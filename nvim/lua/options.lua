-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-----------------------------------------------------------------------------
-- Python madness
-----------------------------------------------------------------------------
vim.g.python3_host_prog='/Users/vincent.siles/.nix-profile/bin/python3'

-----------------------------------------------------------------------------
-- nvim tuning
-----------------------------------------------------------------------------
-- In windows, we want unix file support anyway
vim.opt.fileformats = {'unix', 'dos'}

-- Not sure I need this, but keeping it around just in case
-- vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

vim.g.maplocalleader = " "

vim.opt.inccommand = 'nosplit' -- 'split' opens a live window for off-screen occurrences
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.cino = vim.opt.cino + '(0'
vim.opt.textwidth = 78

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = '+1,+21' -- " relative (to textwidth) columns to highlight "

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Tab completion behavior
vim.opt.wildmode = {'longest' , 'list', 'full' }
vim.opt.wildmenu = true

vim.opt.switchbuf = vim.opt.switchbuf + 'usetab' + 'newtab'

-- I don't like tabs
vim.cmd([[
    syn match tab display "\t"
    hi link tab Error
]])

vim.opt.number = true
-- vim.opt.relativenumber = true

-- Better completion
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.opt.completeopt = 'menuone,noinsert,noselect'
-- Better display for messages
vim.opt.cmdheight = 2
-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime = 300

-- Permanent undo
local undodir = vim.fn.stdpath('data') .. '/undodir'
vim.fn.mkdir(undodir, 'p')
vim.opt.undodir = undodir
vim.opt.undofile = true

-- centering jump and search commands
vim.api.nvim_set_keymap('n', 'n', 'nzz', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '*', '*zz', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '#', '#zz', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'g*', 'g*zz', { silent = true, noremap = true })
-- TODO: learn how to do this for gd in the lsp config too
