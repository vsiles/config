-- sources for lua dev
-- https://luals.github.io/#install
-- https://github.com/LuaLS/lua-language-server
-- https://www.chiarulli.me/Neovim/28-neovim-lua-development/

-- nvim options
require "options"
-- vim.lsp.set_log_level("debug")
require "plugins"

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
-- Helper functions (Not in used at the moment)
-----------------------------------------------------------------------------

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
