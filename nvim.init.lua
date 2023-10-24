-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "airblade/vim-rooter",
    -- { "atelierbram/vim-colors_atelier-schemes", lazy = "true" },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    "dense-analysis/ale",
    { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
    "junegunn/fzf.vim",
    "ludovicchabant/vim-lawrencium",
    { "nvim-tree/nvim-tree.lua",
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    "tpope/vim-commentary",
    "tpope/vim-fugitive",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "chriskempson/base16-vim",
})

-----------------------------------------------------------------------------
-- Python madness
-----------------------------------------------------------------------------
vim.g.python3_host_prog='/usr/bin/python3'


-----------------------------------------------------------------------------
-- Theme configuration
-----------------------------------------------------------------------------

-- vim.cmd [[colorscheme wombat256mod]]
-- vim.cmd.colorscheme "Atelier_SavannaDark"
-- vim.cmd.colorscheme "Atelier_SulphurpoolDark"
--
vim.opt.background = 'dark'
vim.opt.termguicolors = true
vim.cmd.colorscheme "base16-default-dark"


-- Airline
vim.opt.showmode = false
vim.opt.laststatus = 2
-- vim.g.airline_theme = 'badwolf'
vim.g.airline_theme = 'base16_gruvbox_dark_hard'
-- vim.g.airline_theme = 'base16_gruvbox_dark_soft'
-- vim.g.airline_theme = 'Atelier_SulphurpoolDark'

vim.g.airline_powerline_fonts = 1

if not vim.g.airline_symbols then
    vim.g.airline_symbols = {}
end
vim.opt.ttimeoutlen = 10
-----------------------------------------------------------------------------
-- Helper functions
-----------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- Function to check if an executable exists in a directory
local function doesExecutableExist(path, name)
  local executableFullPath = path .. name
  local file = io.open(executableFullPath, "r")
  if file then
    io.close(file)
    return true
  else
    return false
  end
end

-- Function to check if a directory exists
local function doesDirectoryExist(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory" or false
end

-----------------------------------------------------------------------------
-- nvim tuning
-----------------------------------------------------------------------------
-- Not sure I need this, but keeping it around just in case
-- vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'


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
vim.opt.relativenumber = true

-----------------------------------------------------------------------------
-- Plugin tuning
-----------------------------------------------------------------------------
-- nvim.tree
-- TODO: update `update_focused_file` and `diagnostics` ?
require("nvim-tree").setup()

-- fzf
-- vim.g.fzf_layout = { down = '~20%' }

-- vim-commentary
augroup('vim-commentary', { clear = true })

autocmd('FileType', {
	pattern = {'ocaml', 'coq'},
	group = 'vim-commentary',
	callback = function()
		vim.opt.commentstring = '(* %s *)'
	end,
})

-- ocaml / merlin
local opam_share_dir = vim.fn.system { 'opam', 'var', 'share' }
opam_share_dir = opam_share_dir:gsub("[\r\n]*$", "")
-- print(opam_share_dir)

local ocp_indent_path = opam_share_dir .. '/ocp-indent/vim'
local ocp_index_path = opam_share_dir .. '/ocp-index/vim'
local ocaml_merlin_path = opam_share_dir .. '/merlin/vim'

if doesDirectoryExist(ocp_indent_path) then
  vim.cmd('set runtimepath+=' .. ocp_indent_path)
end

if doesDirectoryExist(ocp_index_path) then
  vim.cmd('set runtimepath+=' .. ocp_index_path)
end

if doesDirectoryExist(ocaml_merlin_path) then
  vim.cmd('set runtimepath+=' .. ocaml_merlin_path)
end

-- Using Fred's ocp-indent
--   source "/home/vsiles/.vim/bundle/ocp-indent-vim/indent/ocaml.vim"

-- " Target is displayed in a new tab
-- let g:merlin_split_method = "tab"
vim.g.merlin_split_method = "tab"
-- let g:merlin_locate_preference = "ml"
vim.g.merlin_locate_preference = "ml"


-- ale
vim.g.ale_use_neovim_diagnostics_api = 1
-- vim.g.ale_linters = { 'python': [] , 'rust': ['analyzer'] }
vim.g.ale_linters = { python = {} }
-- let g:ale_rust_analyzer_executable = '/data/users/vsiles/my-rust/rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer'
