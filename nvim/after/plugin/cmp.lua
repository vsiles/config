-- completion configuration

local cmp = require('cmp')

-- cmp.register_source('nix-cmp', require('nix-cmp'))

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

    -- ["<Tab>"] = cmp.mapping(function(fallback)
    --     if cmp.visible() then
    --       cmp.select_next_item()
    --     elseif luasnip.expand_or_jumpable() then
    --       luasnip.expand_or_jump()
    --     elseif has_words_before() then
    --       cmp.complete()
    --     else
    --       fallback()
    --     end
    --   end, { "i", "s" }),
    --   ["<S-Tab>"] = cmp.mapping(function(fallback)
    --     if cmp.visible() then
    --       cmp.select_prev_item()
    --     elseif luasnip.jumpable(-1) then
    --       luasnip.jump(-1)
    --     else
    --       fallback()
    --     end
    --   end, { "i", "s" }),
    --{
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'path' },
      { name = 'buffer' },
    }),
    experimental = {
      ghost_text = true,
    },
})

-- cmp.setup.filetype('nix', {
--     sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       { name = 'nix-cmp' }
--   }, {
--       { name = 'path' },
--       { name = 'buffer' },
--     }),
--     experimental = {
--       ghost_text = true,
--     },
-- })

-- Enable completing paths in :
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})
