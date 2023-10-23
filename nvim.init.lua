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
    { "atelierbram/vim-colors_atelier-schemes", lazy = "true" },
    "tpope/vim-commentary",
})

-----------------------------------------------------------------------------
-- Python madness
-----------------------------------------------------------------------------
vim.g.python3_host_prog='/usr/bin/python3'


-----------------------------------------------------------------------------
-- Theme configuration
-----------------------------------------------------------------------------

vim.opt.background = 'dark'
-- colorscheme wombat256mod
-- vim.cmd [[colorscheme Atelier_EstuaryDark]]
-- vim.cmd [[colorscheme Atelier_DuneDark]]
vim.cmd [[colorscheme Atelier_SulphurpoolDark]]

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
