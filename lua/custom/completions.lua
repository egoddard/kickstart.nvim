vim.opt.completeopt = { 'menu,menuone,noselect' }
vim.opt.shortmess:append 'c'
-- See `:help cmp`

local lspkind = require 'lspkind'
lspkind.init {}

local cmp = require 'cmp'

cmp.setup {
  sources = {
    { name = 'copilot', group_index = 1, priority = 100 },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },

  mapping = cmp.mapping.preset.insert {
    -- Select the [n]ext item
    ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    -- Select the [p]revious item
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },

    -- Scroll the documentation window [b]ack / [f]orward
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- Accept ([y]es) the completion.
    --  This will auto-import if your LSP supports it.
    --  This will expand snippets if the LSP sent a snippet.
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),

    -- If you prefer more traditional completion keymaps,
    -- you can uncomment the following lines
    --['<CR>'] = cmp.mapping.confirm { select = true },
    --['<Tab>'] = cmp.mapping.select_next_item(),
    --['<S-Tab>'] = cmp.mapping.select_prev_item(),
    -- Manually trigger a completion from nvim-cmp.
    --  Generally you don't need this, because nvim-cmp will display
    --  completions whenever it has completion options available.
    ['<C-Space>'] = cmp.mapping.complete {},

    -- Think of <c-l> as moving to the right of your snippet expansion.
    --  So if you have a snippet that's like:
    --  function $name($args)
    --    $body
    --  end
    --
    -- <c-l> will move you to the right of each of the expansion locations.
    -- <c-h> is similar, except moving you backwards.
    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
}

-- Setup vim-dadbod
cmp.setup.filetype({ 'sql' }, {
  sources = {
    { name = 'copilot', group_index = 1, priority = 100 },
    { name = 'vim-dadbod-completion' },
    { name = 'buffer' },
  },
})

local ls = require 'luasnip'
ls.config.set_config {
  history = false,
  updateevents = 'TextChanged, TextChangedI',
}

-- See https://youtu.be/22mrSjknDHI?t=196 for example of how to configure snippets when ready
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/custom/snippets/*.lua', true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
