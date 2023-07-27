-- load plugins
local require_module = function(mod)
	local user_dir = vim.g.user_dir or 'user'
	require(user_dir.. '.'.. mod)
end

-- auto install lazy plugin
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    vim.g.github_url.. "folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { 'folke/which-key.nvim', lazy = false },

  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require_module('plugins.lualine')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require_module('plugins.nvim-treesitter')
    end
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end
  },

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require_module('plugins.telescope')
    end
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- CMP
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'f3fora/cmp-spell' },-- spell check
  { 'saadparwaiz1/cmp_luasnip' },

  -- neovim bultin function help
  { 'folke/neodev.nvim' },

  -- snippet engine and snippet collections
  { 'L3MON4D3/LuaSnip' }, -- snippets engine written in lua
  { 'rafamadriz/friendly-snippets' }, -- a bunch of snippets to use

  -- comment
  {
    'numToStr/Comment.nvim',
    config = function()
      require 'Comment'.setup()
    end
  },

  -- align text
  { 'godlygeek/tabular' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
}

local opts = {
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { "-8" }, -- show commits from the last 3 days
    timeout = 120, -- kill processes that take more than 2 minutes
    url_format = vim.g.github_url.. "%s.git",
    -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
    -- then set the below to false. This should work, but is NOT supported and will
    -- increase downloads a lot.
    filter = true,
  }
}

require("lazy").setup(plugins, opts)

-- which key


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- require('nvim-treesitter.configs').setup {
--   -- Add languages to be installed here that you want installed for treesitter
--   ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'cmake' },
--
--   -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
--   auto_install = false,
--
--   highlight = { enable = true },
--   indent = { enable = true },
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = '<c-space>',
--       node_incremental = '<c-space>',
--       scope_incremental = '<c-s>',
--       node_decremental = '<M-space>',
--     },
--   },
--   textobjects = {
--     select = {
--       enable = true,
--       lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--       keymaps = {
--         -- You can use the capture groups defined in textobjects.scm
--         ['aa'] = '@parameter.outer',
--         ['ia'] = '@parameter.inner',
--         ['af'] = '@function.outer',
--         ['if'] = '@function.inner',
--         ['ac'] = '@class.outer',
--         ['ic'] = '@class.inner',
--       },
--     },
--     move = {
--       enable = true,
--       set_jumps = true, -- whether to set jumps in the jumplist
--       goto_next_start = {
--         [']m'] = '@function.outer',
--         [']]'] = '@class.outer',
--       },
--       goto_next_end = {
--         [']M'] = '@function.outer',
--         [']['] = '@class.outer',
--       },
--       goto_previous_start = {
--         ['[m'] = '@function.outer',
--         ['[['] = '@class.outer',
--       },
--       goto_previous_end = {
--         ['[M'] = '@function.outer',
--         ['[]'] = '@class.outer',
--       },
--     },
--     swap = {
--       enable = true,
--       swap_next = {
--         ['<leader>a'] = '@parameter.inner',
--       },
--       swap_previous = {
--         ['<leader>A'] = '@parameter.inner',
--       },
--     },
--   },
-- }
--

-- for diagnostics
local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

vim.diagnostic.config(config)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})

-- Diagnostic keymaps
vim.keymap.set('n', '<c-K>', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<c-J>', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local function nmap(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    local options = { noremap = true, silent = true, desc = desc }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', keys, func, options)
  end

  -- client.resolved_capabilities.code_action = 
  nmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', '[R]e[n]ame')
  nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', '[C]ode [A]ction')

  nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', '[G]oto [D]efinition')
  nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', '[G]oto [I]mplementation')
  nmap('gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', '[G]oto [R]eferences')
  nmap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type [D]efinition')
  nmap('<leader>ds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', '[D]ocument [S]ymbols')
  nmap('<leader>ws', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover Documentation')
  nmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', '[G]oto [D]eclaration')
  nmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- rust_analyzer = {},

  gopls = {},
  pyright = {},
  html = { filetypes = { 'html', 'twig', 'hbs'} },
  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  cmake = {},
  jsonls = {},
  ccls = {
    init_options = {
      -- compilationDatabaseDirectory = "build",
      -- index = {
      --   threads = 0;
      -- },
      -- clang = {
      --   excludeArgs = { "-frounding-math"} ;
      -- },
      cache = {
        directory = '/tmp/ccls_cache'
      }
    },

    cmd = { 'ccls' },

    filetypes = { 'c', 'cc', 'cpp', 'objc', 'objcpp', 'cuda' },

    offset_encoding = 'utf-8',

    -- root_dir = root_pattern('compile_commands.json', '.ccls', '.git'),

    -- ccls does not support sending a null root directory
    single_file_support = false,
  }
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require 'mason'.setup {
  max_concurrent_installers = 10,
  github = { download_url_template = vim.g.github_url.. '%s/releases/download/%s/%s' }
}
-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  -- local servers = vim.tbl_keys(servers)
  ensure_installed = { "lua_ls", "cmake", "jsonls", "tsserver", "gopls", "pyright", "html" },
}

for server_name, _ in pairs(servers) do
  require('lspconfig')[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server_name],
    filetypes = (servers[server_name] or {}).filetypes,
  }
end

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function custom_format(entry, vim_item)
  local max_width = 0
  local kind_icons = {
		Namespace = "",
		Text = " ",
		Method = " ",
		Function = " ",
		Constructor = " ",
		Field = "ﰠ ",
		Variable = " ",
		Class = "ﴯ ",
		Interface = " ",
		Module = " ",
		Property = "ﰠ ",
		Unit = "塞 ",
		Value = " ",
		Enum = " ",
		Keyword = " ",
		Snippet = " ",
		Color = " ",
		File = " ",
		Reference = " ",
		Folder = " ",
		EnumMember = " ",
		Constant = " ",
		Struct = "פּ ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
		Table = "",
		Object = " ",
		Tag = "",
		Array = "[]",
		Boolean = " ",
		Number = " ",
		Null = "ﳠ",
		String = " ",
		Calendar = "",
		Watch = " ",
		Package = "",
	}
	local source_names = {
		nvim_lsp = '[LSP]',
		nvim_lua = '[API]',
		treesitter = '[TS]',
		emoji = '[Emoji]',
		path = '[Path]',
		calc = '[Calc]',
		cmp_tabnine = '[Tabnine]',
		vsnip = '[Snip]',
		luasnip = '[Snip]',
		buffer = '[Buffer]',
		spell = '[Spell]',
	}
	if max_width ~= 0 and #vim_item.abbr > max_width then
		vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
	end
	vim_item.kind = kind_icons[vim_item.kind] .. vim_item.kind
	vim_item.menu = source_names[entry.source.name]
	return vim_item
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
		-- The number of characters needed to trigger auto-completion.
		keyword_length = 1
		-- match pattern
		-- keyword_pattern : string
	},
  mapping = cmp.mapping.preset.insert {
    -- `i` = insert mode, `c` = command mode, `s` = select mode
    ['<C-h>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-l>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<C-e>'] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        luasnip.change_choice()
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-;>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    -- ["<C-e>"] = cmp.mapping {
      -- 	i = cmp.mapping.abort(),
      -- 	c = cmp.mapping.close(),
      -- },
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      -- ['<C-j>'] = cmp.mapping.confirm({ select = true }),
  },

  formatting = {
    format = custom_format
  },

  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'treesitter' },
    { name = 'buffer' },
    { name = 'path' },
    -- { name = 'spell' },
  }),
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -- view = {
  --   entries = 'native'
  -- },
  experimental = {
    ghost_text = false,
  },
}

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
  { { name = 'path' } },
  { { name = 'cmdline' } }
  )
})
