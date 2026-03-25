-- `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- https://www.nerdfonts.com
vim.g.have_nerd_font = true

-- General Settings - `:help vim.o`, `:help option-list`

-- vim.o.clipboard = 'unnamedplus   -- not using smart clipboard: `y/p` for buffers, `<l>y/<l>p` for system 
vim.o.confirm = true
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.scrolloff = 5
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.timeout = true
vim.o.timeoutlen = 2000
vim.o.undofile = true
vim.o.updatetime = 5000

-- Highlights
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.incsearch = true
vim.o.smartcase = true

-- Indentication
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- Special symbols
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', precedes = '<', extends = '>' }

-- Statusline
vim.o.laststatus = 2
vim.o.statusline = '%f %m%r%h%w %= [%{&fileformat}] %p%% %l:%c'


-- [[ Basic Autocommands ]]
--   `:help lua-guide-autocommands`

-- Highlight when yanking text - `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
    -- local copy_to_unnamedplus = require('vim.ui.clipboard.osc52').copy('+')
    -- copy_to_unnamedplus(vim.v.event.regcontents)
    -- local copy_to_unnamed = require('vim.ui.clipboard.osc52').copy('*')
    -- copy_to_unnamed(vim.v.event.regcontents)
  end,
})

-- [[ `lazy.nvim` plugin manager ]]
--   `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)


-- [[ Plugins ]]
--    `:Lazy`
require('lazy').setup({

  -- ['NMAC427/guess-indent.nvim']
  -- Detects tabstop and shiftwidth automatically
  {
    'NMAC427/guess-indent.nvim',
    opts = {
      override_editorconfig = true
    }
  },

  -- ['stevearc/oil.nvim']
  -- File explorer as a buffer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        -- columns = { "icon", "permissions", "size", "mtime" },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 4,
          max_width = 120,
          max_height = 40,
        },
        preview = {
          max_width = 0.7,      -- fraction of screen width
          min_width = { 60, 0.4 }, -- min 60 cols or 40% of screen
          border = "rounded",
          update_on_cursor_moved = true, -- live-update as you move through files
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
          ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
          ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
          ["<C-p>"] = "actions.preview",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["gh"] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
          ["gd"] = {
            desc = "Toggle detail view (permissions, size, mtime)",
            callback = function()
              local oil = require("oil")
              local config = require("oil.config")
              if #config.columns == 1 then
                oil.set_columns({ "icon", "permissions", "size", "mtime" })
              else
                oil.set_columns({ "icon" })
              end
            end,
          },
        },
        use_default_keymaps = false,
      })
    end,
  },

  -- ['lewis6991/gitsigns.nvim']
  -- Adds super handy git related signs to the gutter, as well as utils - `:help gitsigns`
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Viz of Git diff & history
  --   `:DiffviewFileHistory <path>`  -- history of a file or repo
  --   `:DiffviewOpen`                -- local modifications
  'sindrets/diffview.nvim',

  -- ['pwntester/octo.nvim']
  -- GitHub API plugin
  -- :Octo issue list
  -- :Octo https://github.com/pwntester/octo.nvim/issues/12
  -- :Octo https://github.com/pwntester/octo.nvim/pull/123
  -- <C-b> -- open in browser
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      picker = 'telescope',
      enable_builtin = true
    },
    keys = {
      {
        "<leader>ooi",
        "<CMD>Octo issue list<CR>",
        desc = "[I]ssues",
      },
      {
        "<leader>oop",
        "<CMD>Octo pr list<CR>",
        desc = "[PR]s",
      },
      -- {
      --   "<leader>oon",
      --   "<CMD>Octo notification list<CR>",
      --   desc = "[N]otifications",
      -- },
      {
        "<leader>oos",
        function()
          require("octo.utils").create_base_search_command { include_current_repo = true }
        end,
        desc = "[S]earch",
      },
    },
    config = function()
      require("octo").setup()
    end
  },


  -- ['folke/which-key.nvim']
  -- Useful plugin to show pending keybinds
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter' for proper interception
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds), independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>b', group = '[B]rowse' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>g', group = '[G]o' },
        { '<leader>h', group = '[H]elp' },
        { '<leader>o', group = '[O] Git' },
        { '<leader>oo', group = '[O]cto' },
        { '<leader>t', group = '[T]ools' },
      },
    },
  },

  -- ['nvim-telescope/telescope.nvim']
  -- Fuzzy Finder (files, lsp, etc) - `:help telescope`, `:Telescope help_tags`
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'nvim-telescope/telescope-file-browser.nvim' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              width = 0.9,
              height = 0.9,
              preview_width = 0.65
            }
          }
        },
        pickers = {
          find_files = {
            hidden = true
          },
          grep_string = {
            additional_args = function(_)
              return { "--hidden" }
            end
          },
          live_grep = {
            additional_args = function(_)
              return { "--hidden" }
            end
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          file_browser = {
            hijack_netrw = true,
          },
        },
      }

      require('telescope').load_extension('file_browser')
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = '[H]elp [T]ags' })
      vim.keymap.set('n', '<leader>hk', builtin.keymaps, { desc = '[H]elp [K]eymaps' })
      vim.keymap.set('n', '<leader>hs', builtin.builtin, { desc = '[H]elp Tele[S]cope' })
      vim.keymap.set('n', '<leader>sf', builtin.git_files, { desc = '[F]iles' })
      vim.keymap.set('n', '<leader>sF', builtin.find_files, { desc = 'All [F]iles' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[G]rep' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[R]esume' })
      vim.keymap.set('n', '<leader>gj', builtin.jumplist, { desc = '[J]umps' })
      vim.keymap.set('n', '<leader>oH', builtin.git_bcommits, { desc = 'File [H]istory'})
      -- vim.keymap.set('v', '<leader>oh', builtin.git_bcommits_range, { desc = '[B] file history for selection'})

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzy search' })

      -- vim.keymap.set('n', '<leader>s/', function()
      --   builtin.live_grep {
      --     grep_open_files = true,
      --     prompt_title = 'Live Grep in Open Files',
      --   }
      -- end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>bb', function()
        require("telescope").extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = vim.fn.expand("%:p:h"),
          respect_gitignore = true,
          hidden = true,
          grouped = true,
        })
      end, { desc = 'Fuzzy [B]rowser' })
    end,
  },

  -- ['folke/lazydev.nvim']
  -- Configures Lua LSP
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- ['neovim/nvim-lspconfig']
  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end

          map('<leader>tn', vim.lsp.buf.rename, 'Re[n]ame')
          map('<leader>gr', require('telescope.builtin').lsp_references, '[R]eferences')
          -- map('<leader>gR', vim.lsp.buf.references, '[R]eferences as quickfix')
          map('<leader>gi', require('telescope.builtin').lsp_implementations, '[I]mplementations')
          map('<leader>gd', require('telescope.builtin').lsp_definitions, '[D]efinition')
          map('<leader>gD', vim.lsp.buf.declaration, '[D]eclaration')
          map('<leader>gt', require('telescope.builtin').lsp_type_definitions, '[T]ype') -- TODO: do I need it? it's trivial for simple things, it's not too efective for overly-complicated types

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf }) -- inlay hints enabled by default
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Inlay [H]ints')
          end
        end,
      })

      -- `:help vim.diagnostic.Opts`
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = true, -- underline all diagnostic lines
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = false,   -- TODO: need to toy more with this one
        virtual_lines = { current_line = false }, -- toggled via <leader>tm
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- manually setting up some LSPs to prevent Mason fiddling with it
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--j=16',
            '--background-index',
            '--clang-tidy',
            '--pch-storage=memory',
            '--header-insertion=never',
            '--function-arg-placeholders=false',
            '--completion-style=bundled',
          },
        },
        -- pyright = {
        --   cmd = { 'pyright' },
        -- },
        --
        jdtls = {
        },
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- `:Mason` will handle these LSPs automatically
      local ensure_installed = {
        'lua_ls',
        'stylua',
        'jdtls',
        'pyright'
      }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      -- .. and configure automatically ..
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      -- .. and the remaining ones, we configure manually
      vim.lsp.config('clangd', servers['clangd'])
      vim.lsp.enable('clangd')
      --vim.lsp.config('pyright', servers['pyright'])
      --vim.lsp.enable('pyright')
    end,
  },


  -- ['saghen/blink.cmp']
  -- Autocompletion and some other nice things
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip', -- snippet engine
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        -- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        ['<C-h>'] = { "show", "show_documentation", "hide_documentation" },
        ['<CR>'] = { "accept", "fallback" },
        ['<Tab>'] = { "accept", "fallback", },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        nerd_font_variant = 'mono', -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250, treesitter_highlighting = true, window = { border = 'rounded'} },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lsp = { min_keyword_length = 2, score_offset = 0 },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },

      -- `:h blink-cmp-config-fuzzy`
      fuzzy = { implementation = 'lua' },
      -- Method signatures
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },


  -- [Color scheme]
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = true },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- ['kwkarlwang/bufjump.nvim']
  -- I prefer to jump <C-o>/<C-i> between files only, instead of default jumping through every previous position in file
  -- This plugin doesn't modify the jumplist, so <C-p> still allows to jump through every entry backwards
  {
    'kwkarlwang/bufjump.nvim',
    opts = {
      forward_key = '<C-i>',
      backward_key = '<C-o>',
    },
  },


  -- ['lewis6991/hover.nvim']
  -- Handy hint hover with 'K'
  {
    'lewis6991/hover.nvim',
    config = function()
      require('hover').config({
        providers = {
          'hover.providers.diagnostic',
          'hover.providers.lsp',
          'hover.providers.man',
          'hover.providers.gh',
          'hover.providers.gh_user',
          'hover.providers.dictionary',
          'hover.providers.fold_preview',
        },
        preview_opts = {
          border = 'rounded',
        },
        preview_window = false,
        title = true,
      })
    end,
  },

  -- ['folke/trouble.nvim']
  -- Handy diagnostics panel
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      auto_close = false,
      focus = true,
      win = {
        size = 0.3,
        position = 'bottom',
      },
      -- Every mode here represent different diagnostics I'd like to see using different strokes
      modes = {
        diagnostics = {},
        diagnostics_buffer = {
          mode = 'diagnostics',
          filter = { buf = 0 },
        },
        symbols = {
          focus = true,
          win = { position = 'right', size = 0.3 },
        },
        symbols_methods = {
          mode = 'lsp_document_symbols',
          focus = true,
          win = { position = 'right', size = 0.3 },
          filter = {
            any = {
              kind = {
                "Function",
                "Method",
                "Constructor",
              },
            },
          },
        },
        symbols_definitions = {
          mode = 'lsp_document_symbols',
          focus = true,
          win = { position = 'right', size = 0.3 },
          filter = {
            any = {
              kind = {
                "Class",
                "Struct",
                "Enum",
                "EnumMember",
                "Interface",
                "Module",
                "Namespace",
                "Package",
                "Field",
                "Property",
                "Variable",
                "Constant",
                "TypeParameter",
              },
            },
          },
        },
        diagnostics_preview = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'top',
            size = 0.6,
          },
        },
      },
    },
    cmd = { 'Trouble' },
  },

  { 'rafamadriz/friendly-snippets' },

  {
    'echasnovski/mini.nvim',
    config = function()
      -- gc/gcc - comment out blocks - super handy
      require('mini.comment').setup()
      require('mini.icons').setup()
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.config', -- Sets main module to use for opts
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true, -- auto install languages
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})


-- [Windows]
-- Resizing
vim.keymap.set('n', '<F9>', '<cmd>resize -2<CR>')           -- <F9>   makes height smaller
vim.keymap.set('n', '<F21>', '<cmd>vertical resize -2<CR>') -- <S-F9>  makes width smaller
vim.keymap.set('n', '<F10>', '<cmd>resize +2<CR>')          -- <F10>  makes height bigger
vim.keymap.set('n', '<F22>', '<cmd>vertical resize +2<CR>') -- <S-F10>  makes width bigger
vim.keymap.set('n', '<F11>', '<cmd>resize<CR>')             -- <F11>  maximizes height
vim.keymap.set('n', '<F23>', '<cmd>vertical resize<CR>')    -- <S-F11>  maximizes width
vim.keymap.set('n', '<F12>', '<C-w>w')                      -- <F12>  next split
-- Wrapping/Unwrapping
vim.o.wrap = false
vim.keymap.set('n', '<F4>', '<cmd>set wrap!<CR>')           -- <F4>   toggles fitting long lines by breaking them, or letting them go beyond the width
vim.o.breakindent = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')         -- drop highlighting of the current search

vim.keymap.set('n', '<F24>', '<cmd>LspClangdSwitchSourceHeader<CR>')  -- <S-F12>  Header/Source smart switch


-- [Git]
vim.keymap.set('n', '<leader>ob', '<cmd>Gitsigns blame<CR>', { desc = '[B]lame' })
vim.keymap.set('n', '<leader>od', '<cmd>DiffviewOpen<CR>', { desc = '[D]iff' })

-- Look up PRs for a given SHA and display results in a side split
local function find_pr_and_display(sha, diff_anchor)
  -- GitHub repo slug from remote URL
  local remote_url = vim.trim(vim.fn.system({'git', 'remote', 'get-url', 'origin'}))
  local repo = remote_url:match('github%.com[:/](.+)$'):gsub('%.git$', '')

  local function diff_link(pr_number)
    if not diff_anchor then return nil end
    return 'https://github.com/' .. repo .. '/pull/' .. pr_number .. '/files' .. diff_anchor
  end

  local function show(lines)
    vim.cmd('topleft vsplit')
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].modifiable = false
    vim.api.nvim_win_set_width(0, 80)
    -- <CR> opens the URL from the current line in the browser (works even if truncated)
    vim.keymap.set('n', '<CR>', function()
      local url = vim.api.nvim_get_current_line():match('https?://[%S]+')
      if url then vim.ui.open(url) else vim.notify('No URL on this line', vim.log.levels.WARN) end
    end, { buffer = buf, desc = 'Open URL in browser' })
  end

  -- async: search GitHub for PRs containing this commit
  vim.notify('Looking up PR for ' .. sha:sub(1, 10) .. '...')
  vim.system(
    {'gh', 'pr', 'list', '--search', sha, '--state', 'merged', '--json', 'number,url'},
    {text = true},
    function(result)
      vim.schedule(function()
        local output = { 'SHA: ' .. sha:sub(1, 10), sha, '' }
        local prs = vim.json.decode(result.stdout or '[]') or {}
        if #prs > 0 then
          table.insert(output, 'PRs:')
          for _, pr in ipairs(prs) do
            table.insert(output, '#' .. pr.number .. ' ' .. pr.url)
            local dl = diff_link(pr.number)
            if dl then table.insert(output, dl) end
            table.insert(output, '')
          end
        else
          table.insert(output, 'No PRs found.')
        end
        show(output)
      end)
    end
  )
end

-- Find PR for the current line via git blame
vim.keymap.set('n', '<leader>op', function()
  local line = vim.fn.line('.')
  local file = vim.fn.expand('%:p')
  local git_root = vim.trim(vim.fn.system({'git', 'rev-parse', '--show-toplevel'}))
  local rel_path = file:sub(#git_root + 2) -- path relative to repo root
  local blame = vim.fn.system({'git', 'blame', '-L', line..','..line, '--porcelain', file})
  local sha, orig_line = blame:match('^(%x+)%s+(%d+)') -- orig_line = line number at the time of commit
  if not sha or sha:match('^0+$') then
    vim.notify('No commit for this line', vim.log.levels.WARN)
    return
  end
  -- PR diff anchor: #diff-<sha256 of file path>R<original line> — jumps to the exact line in PR diff
  local diff_anchor = '#diff-' .. vim.fn.sha256(rel_path) .. 'R' .. orig_line
  find_pr_and_display(sha, diff_anchor)
end, { desc = 'Find [PR] for line' })

-- Find PR for the SHA under cursor
vim.keymap.set('n', '<leader>oP', function()
  local word = vim.fn.expand('<cword>')
  if not word:match('^%x+$') or #word < 7 then
    vim.notify('Word under cursor is not a valid SHA (need at least 7 hex chars)', vim.log.levels.WARN)
    return
  end
  find_pr_and_display(word, nil)
end, { desc = 'Find [PR] for SHA' })

-- <C-o>/<C-i>: jump between files (bufjump.nvim), skipping within-file positions
-- <C-p>: walk the full jumplist (original <C-o> behavior, including within-file)
vim.keymap.set('n', '<C-p>', '<C-o>', { desc = 'Jump back full', noremap = true })

-- Hover 'K' hint
vim.keymap.set('n', 'K', function() require('hover').open() end, { desc = 'Hover' })

-- [Clipboard]
-- y/d/p use vim registers only - internal to vim
-- <leader>y/p explicitly use system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = '+Copy' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = '+Copy line' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = '+Paste' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = '+Paste before' })

-- [Messages & Actions]

-- Toggle inline diagnostic messages (virtual_lines: shown below the offending line, full-width)
local virtual_lines_on = true
vim.keymap.set('n', '<leader>tm', function()
  virtual_lines_on = not virtual_lines_on
  vim.diagnostic.config({
    virtual_lines = virtual_lines_on and { current_line = false } or false,
  })
  vim.notify('Inline diagnostics: ' .. (virtual_lines_on and 'ON' or 'OFF'))
end, { desc = 'Inlay [M]essages' })

vim.keymap.set('n', '<leader>gM', '<CMD>Trouble diagnostics_buffer toggle<CR>', { desc = '[M]essages' })
vim.keymap.set('n', '<leader>gG', function()
  vim.cmd('tabnew')
  vim.cmd('Trouble diagnostics_preview')
end, { desc = '[G]lobal Messages' })

vim.keymap.set({ 'n', 'x' }, '<leader>gA', vim.lsp.buf.code_action, { desc = 'Line [A]ction' })

-- Quickfix / loclist via trouble (replaces :copen / :lopen)
-- vim.keymap.set('n', '<leader>gmq', '<CMD>Trouble qflist toggle<CR>', { desc = 'Trouble: [Q]uickfix list' })
-- vim.keymap.set('n', '<leader>gmL', '<CMD>Trouble loclist toggle<CR>', { desc = 'Trouble: [L]ocation list' })

-- [Symbols]
vim.keymap.set('n', '<leader>gA', '<CMD>Trouble symbols toggle<CR>', { desc = '[A] Symbols' })
vim.keymap.set('n', '<leader>gF', '<CMD>Trouble symbols_methods toggle<CR>', { desc = '[F]unctions' })
vim.keymap.set('n', '<leader>gV', '<CMD>Trouble symbols_definitions toggle<CR>', { desc = '[V]ariables' })


vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [File browser in splits]
vim.api.nvim_create_user_command('Splito', function()
  vim.cmd('split')
  require('oil').open(vim.fn.expand('%:p:h'))
end, { desc = 'H Split with File browser' })

vim.api.nvim_create_user_command('Vsplito', function()
  vim.cmd('vsplit')
  require('oil').open(vim.fn.expand('%:p:h'))
end, { desc = 'V Split with File browser' })

vim.api.nvim_create_user_command('Tsplito', function()
  local dir = vim.fn.expand('%:p:h')
  vim.cmd('tabnew')
  require('oil').open(dir)
end, { desc = 'Tab with File browser' })

vim.keymap.set('n', '<leader>bs', '<CMD>Splito<CR>', { desc = '[S]plit browser' })
vim.keymap.set('n', '<leader>bv', '<CMD>Vsplito<CR>', { desc = '[V]split browser' })
vim.keymap.set('n', '<leader>bt', '<CMD>Tsplito<CR>', { desc = '[T]ab browser' })
