-----------------------------------------------------------------------------
-- Plugin tuning
-----------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-----------------------------------------------------------------------------
-- Leap
-----------------------------------------------------------------------------
local leap = require('leap')
leap.create_default_mappings()
leap.opts.special_keys.prev_target = '<bs>'
leap.opts.special_keys.prev_group = '<bs>'
require('leap.user').set_repeat_keys('<cr>', '<bs>')

-----------------------------------------------------------------------------
-- Float Term bindings
-----------------------------------------------------------------------------
-- vim.api.nvim_set_keymap('n', '<leader>cn', ':FloatermNew<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>ct', '<Esc>:FloatermToggle<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>ck', '<Esc>:FloatermKill<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('t', '<leader>ct', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('t', '<leader>ck', '<C-\\><C-n>:FloatermKill<CR>', { noremap = true, silent = true })

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

if not (vim.fn.has('win32') or vim.fn.has('win64')) then
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
end


-- ale
vim.g.ale_use_neovim_diagnostics_api = 1
vim.g.ale_linters = { python = {} , rust = {'analyzer'} }
-- TODO: check that
-- vim.g.ale_rust_analyzer_executable = '/Users/vincent.siles/.cargo/bin/rust-analyzer'

-- rust
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0
-- vim.g.rust_clip_command = 'xclip -selection clipboard'
vim.cmd [[autocmd BufRead Cargo.toml call crates#toggle()]]

-- diffview
require('diffview').setup({
    view = {
        merge_tool = {
            layout = "diff4_mixed",
        }
    },
})
