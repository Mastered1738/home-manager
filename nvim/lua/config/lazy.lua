-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
  {
    "catppuccin/nvim", name = "catppuccin", priority = 1000
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    'nvim-telescope/telescope-ui-select.nvim'
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
    dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    }
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  },
  {
    'mhartington/formatter.nvim'
  },
}

local opts = {}

-- Setup lazy.nvim
require("lazy").setup(plugins, opts)

-- formatter nvim setup
local formatter = require('formatter')

formatter.setup({
  logging = true,
  filetype = {
    javascript = {
      require('formatter.filetypes.javascript').prettier,
    },
    typescript = {
      require('formatter.filetypes.typescript').prettier,
    },
    rust = {
      require('formatter.filetypes.rust').rustfmt,
    },
    svelte = {
      require('formatter.filetypes.svelte').prettier,
    },
    vue = {
      require('formatter.filetypes.vue').prettier,
    },
    json = {
      require('formatter.filetypes.json').prettier,
    },
    -- Optional: specify other filetypes here
  },
})
-- Optional: Bind the formatter to a keymap
vim.api.nvim_set_keymap('n', '<Leader>f', ':Format<CR>', { noremap = true, silent = true })

-- lsp-zero setup instead of mason because mason in NixOS will never work
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- none-ls setup, NOTE: none-ls requires you to name everything through null-ls instead of none-ls...weird but ok
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell,
  },
})

-- Neo-tree setup
require("neo-tree").setup({
  filesystem = {
    visible = true;
    hide_dotfiles = false;
    hide_gitignored = false;
    hide_hidden = false;
  }
})
vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal left<CR>', {})
vim.keymap.set('n', '<leader>nc', ':Neotree close<CR>', {})

-- treesitter setup
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = { "zig", "gcc", "cmake", "cpp", "lua", "javascript", "typescript", "go", "rust", "css", "scss", "svelte", "vue", "json", "html", "yaml", "vim", "toml", "php", "nix", "gitignore", "gitcommit", "git_config", "bash" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- telescope setup and telescope ui
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
}
require("telescope").load_extension("ui-select")

-- colorscheme setup
require("catppuccin").setup({
  flavour = "frappe",
  styles = {
    comments = { "italic" },
  }
})
vim.cmd.colorscheme "catppuccin"

-- lualine setup
require("lualine").setup()

-- After setting up nvim-lspconfig you may set up servers via lspconfig
require("lspconfig").lua_ls.setup {}
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").tsserver.setup {}
require("lspconfig").volar.setup {}
require("lspconfig").svelte.setup {}
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
-- ...
