# https://github.com/jemaw/nixvim-config/blob/main/config/plugins/lsp.nix
# https://gitlab.helsing-dev.ai/omar.essaid/nixified-dotfiles/-/blob/helsing/home/editors/nixvim/lsp.nix?ref_type=heads
{ config, pkgs, ... }:
{
    programs.nixvim = {
        plugins = {
            lsp = {
                enable = true;
                onAttach =
                  # lua
                  ''
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
                  '';
                keymaps = {
                    diagnostic = {
                        "<space>e" = "open_float";
                        "[d" = "goto_prev";
                        "]d" = "goto_next";
                        "<space>q" = "setloclist";
                    };
                    lspBuf = {
                        "gd" = "definition";
                        "gD" = "declaration";
                        "K" = "hover";
                        "gi" = "implementation";
                        "<C-k>" = "signature_help";
                        "<space>r" = "rename";
                        "gr" = "references";
                        "<space>f" = "format";
                        "space>a" = "code_action";
                    };
                };
                servers = {
                    bashls.enable = true;
                    pylsp = {
                        enable = true;
                        settings = {
                            configurationSources = "flake8";
                            plugins = {
                                pycodestyle.enabled = false;
                                mccabe.enabled = false;
                                pyflakes.enabled = false;
                                mypy.enabled = true;
                                black = {
                                    enabled = true;
                                    lineLength = 120;
                                };
                                isort.enabled = true;
                                flake8 = {
                                    enabled = true;
                                    maxLineLength = 120;
                                };
                            };
                        };
                    };
                    nil-ls = {
                        enable = true;
                        settings.formatting.command = [ "nixpkgs-fmt" ];
                    };
                    lua-ls = {
                        enable = true;
                        settings.completion.callSnippet = "Replace";
                    };
                    tsserver.enable = false;
                };
            };
            lspkind.enable = true;
            rustaceanvim.enable = true;
        };
        extraConfigLuaPost = 
          # lua
          ''
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
          '';
    };
}

# TODO:
# -- vim.lsp.start({
# --     cmd = { '/Users/vincent.siles/Documents/2024-03-nix-training/my-nix-lsp/target/debug/my-nix-lsp' },
# --   root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
# -- })
#
# -- Terraform lsp
# lspconfig.terraformls.setup{}
#
# vim.api.nvim_create_autocmd({"BufWritePre"}, {
#   pattern = {"*.tf", "*.tfvars"},
#   callback = function()
#     vim.lsp.buf.format()
#   end,
# })
