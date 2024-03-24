return {
    -- theme plugins
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    {
        "chriskempson/base16-vim",
        priority = 1000,
        config = function ()
            -----------------------------------------------------------------------------
            -- Theme configuration
            -----------------------------------------------------------------------------
            -- fix hover borders & coloring
            -- vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
            -- vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

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
        end
    },
    -- note taking
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = true,
        opts = {
            highlight = {
                enable = true,
                disable = { "c", "rust" },
            },
            ensure_installed = { "c", "lua", "vim", "vimdoc", "nix", "rust", "python" },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "nvim-neorg/neorg",
        ft = "norg",
        cmd = "Neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                work = "~/notes/work",
                                home = "~/notes/home",
                            },
                            default_workspace = "work",
                        },
                    },
                    -- required :TSInstall norg_meta
                    ["core.summary"] = {},
                    ["core.completion"] = {
                        config = {
                            engine = "nvim-cmp",
                        },
                    },
                },
            }

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2
        end,
    },

    -- language services
    { "folke/neodev.nvim", opts = {} },
    { "dense-analysis/ale", lazy = true },
    "neovim/nvim-lspconfig",
    {"rust-lang/rust.vim", ft = "rust" },
    {
        "hrsh7th/nvim-cmp",
        branch = "main",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp", branch = "main"},
            { "hrsh7th/cmp-buffer", branch = "main"},
            { "hrsh7th/cmp-path", branch = "main"},
            { "hrsh7th/cmp-vsnip", branch = "main" },
            "hrsh7th/vim-vsnip",
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require("lsp_signature").setup(opts) end
    },
    -- {"simrat39/rust-tools.nvim", ft = "rust"},
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        ft = { 'rust' },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        }
    },
    "LnL7/vim-nix",

    -- misc. tooling
    -- { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
    "junegunn/fzf",
    "junegunn/fzf.vim",
    { "nvim-tree/nvim-tree.lua",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    { "stevearc/oil.nvim",
      opts = {},
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "tpope/vim-commentary",
    {"mhinz/vim-crates", ft = "toml"},
    -- { "voldikss/vim-floaterm", lazy = false },
    { "ggandor/leap.nvim",
      dependencies = { "tpope/vim-repeat" },
    },
    {"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
    -- SCM
    {"ludovicchabant/vim-lawrencium"},
    "tpope/vim-fugitive",
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            -- Only one of these is needed, not both.
            "ibhagwan/fzf-lua",              -- optional
        },
        opts = {
            integrations = {
                diffview = true
            }
        },
        config = true
    },
    "airblade/vim-rooter",
}
