require("neodev").setup({})

-----------------------------------------------------------------------------
-- lsp
-----------------------------------------------------------------------------
local lspconfig = require('lspconfig')

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

-- -- TODO: make that more lazy :D
-- local rt = require("rust-tools")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

--[[
local capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities(),
      -- File watching is disabled by default for neovim.
      -- See: https://github.com/neovim/neovim/pull/22405
      { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
    );
--]]

vim.g.rustaceanvim = {
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
}

-- rt.setup({
--     tools = {
--         inlay_hints = {
--             only_current_line = true,
--         }
--     },
--     server = {
--         on_attach = on_attach,
--         -- flags = {
--         --   debounce_text_changes = 150,
--         -- },

--         settings = {
--             ["rust-analyzer"] = {
--                 cargo = {
--                     allFeatures = true,
--                 },
--                 completion = {
--                     postfix = {
--                         enable = false,
--                     },
--                 },
--             },
--         },
--         capabilities = capabilities,
--     },
-- })

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

--[[
-- test opencl lsp
local opencl = require('lspconfig').opencl_ls
opencl.setup({
    cmd = { "/Users/vsiles/Downloads/opencl-language-server" },
    filetypes = { "opencl" },
}
)
--]]

-- Python lsp:
-- Install python-lsp-server (pylsp) via pipx:
--   pipx install python-lsp-server
-- Add some relevant plugins (black, mypy, isort, flake8) to the same pipx venv:
--   pipx inject python-lsp-server pylsp-mypy pyls-isort python-lsp-black flake8
lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = false,
        },
        mccabe = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
        mypy = {
          enabled = true,
        },
        black = {
          enabled = true,
        },
        isort = {
          enabled = true,
        },
        flake8 = {
          enabled = true,
        }
      },
      configurationSources = {
        "flake8",
        "mypy"
      },
    }
  }
}

-- Nix lsp
lspconfig.nil_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['nil'] = {
            formatting = {
                command = { "nixpkgs-fmt" },
            },
        },
    },
}
-- lspconfig.nixd.setup {}

-- lua lsp
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})
