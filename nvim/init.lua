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
    -- theme plugins
    -- { "atelierbram/vim-colors_atelier-schemes", lazy = "true" },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "chriskempson/base16-vim",

    -- language services
    { "dense-analysis/ale", lazy = true },
    "neovim/nvim-lspconfig",
    "rust-lang/rust.vim",
    { "hrsh7th/cmp-nvim-lsp", branch = "main"},
    { "hrsh7th/cmp-buffer", branch = "main"},
    { "hrsh7th/cmp-path", branch = "main"},
    { "hrsh7th/nvim-cmp", branch = "main"},
    "ray-x/lsp_signature.nvim",
    "simrat39/rust-tools.nvim",

    -- required by nvim-cmp
    { "hrsh7th/cmp-vsnip", branch = "main" },
    "hrsh7th/vim-vsnip",

    -- misc. tooling
    { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
    "junegunn/fzf.vim",
    { "nvim-tree/nvim-tree.lua",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    "tpope/vim-commentary",
    "mhinz/vim-crates",

    -- SCM
    "ludovicchabant/vim-lawrencium",
    "tpope/vim-fugitive",
    "airblade/vim-rooter",
})

-----------------------------------------------------------------------------
-- Python madness
-----------------------------------------------------------------------------
vim.g.python3_host_prog='/usr/bin/python3'


-----------------------------------------------------------------------------
-- Theme configuration
-----------------------------------------------------------------------------
-- fix hover borders & coloring
vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

-- vim.cmd [[colorscheme wombat256mod]]
-- vim.cmd.colorscheme "Atelier_SavannaDark"
-- vim.cmd.colorscheme "Atelier_SulphurpoolDark"
--
vim.opt.background = 'dark'
vim.opt.termguicolors = true
vim.cmd.colorscheme "base16-default-dark"
-- vim.cmd [[highlight Comment cterm=italic gui=italic]]

-- Make comments more prominent -- they are important.
local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
vim.api.nvim_set_hl(0, 'Comment', bools)

-- Make it clearly visible which argument we're at.
local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter',
  { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })


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

-----------------------------------------------------------------------------
-- lsp
-----------------------------------------------------------------------------
-- local lspconfig = require('lspconfig')
local rt = require("rust-tools")

local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
      -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
      { name = 'nvim_lsp' },
    }, {
      { name = 'path' },
      { name = 'buffer' },
    }),
    experimental = {
      ghost_text = true,
    },
})

-- Enable completing paths in :
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

  -- None of this semantics tokens business.
  -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
  client.server_capabilities.semanticTokensProvider = nil

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
    },
  })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

rt.setup({
    tools = {
        inlay_hints = {
            only_current_line = true,
        }
    },
    server = {
        on_attach = on_attach,
        -- flags = {
        --   debounce_text_changes = 150,
        -- },

        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                completion = {
                    postfix = {
                        enable = false,
                    },
                },
            },
        },
        capabilities = capabilities,
    },
})


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
      border = "single",
  }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)


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
vim.g.ale_linters = { python = {} , rust = {'analyzer'} }
-- vim.g.ale_linters = { python = {} }
vim.g.ale_rust_analyzer_executable = '/data/users/vsiles/my-rust/rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer'

-- rust
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0
-- vim.g.rust_clip_command = 'xclip -selection clipboard'
vim.cmd [[autocmd BufRead Cargo.toml call crates#toggle()]]
