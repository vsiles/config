local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

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
