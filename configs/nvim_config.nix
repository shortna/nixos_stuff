{}:
let
  misc = ''
    local g = vim.g
    local opt = vim.opt

    -- basic stuff
    opt.syntax = "enable"
    opt.number = true
    opt.relativenumber = true

    opt.colorcolumn = "80"
    opt.wrap = false
    opt.cursorline = true
    opt.cursorlineopt = "both"
    opt.mouse = ""
    opt.hlsearch = true
    opt.incsearch = true
    opt.swapfile = false
    opt.hidden = true
    opt.termguicolors = true
    opt.wrapscan = false

    -- fold stuff
    opt.foldmethod = "expr"
    opt.foldexpr = "nvim_treesitter#foldexpr()"
    opt.foldenable = false

    -- indent stuff
    opt.expandtab = false
    opt.tabstop = 8
    opt.shiftwidth = 2
    opt.softtabstop = 2

    -- menu stuff
    opt.wildmenu = true
    opt.wildmode = 'full'

    -- do not let quckifix to spawn where it wants
    opt.switchbuf = "useopen"

    -- remove numbers in terminal
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function()
        opt.relativenumber = false
        opt.number = false
      end
    })

    -- vim doesnt like compound literals
    g.c_no_curly_error = true

    -- telescope man pages sections
    local builtin = require('telescope.builtin')
    local function man_pages()
      return builtin.man_pages({ sections = { "2", "3" } });
    end

    -- presistent undo
    opt.undofile = true

    -- lua is enough
    g.loaded_node_provider = 0
    g.loaded_perl_provider = 0
    g.loaded_ruby_provider = 0
    g.loaded_python3_provider = 0

    -- line
    g.airline_symbols_ascii = 1
    g.airline_section_z = ""

    vim.cmd("colorscheme catppuccin-latte")
  '';

  mappings = ''
    local g = vim.g
    g.mapleader = " "
    vim.keymap.set('n', '<Leader>ve', '<Cmd>Ex<CR>', { silent = true })
    vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>', { silent = true })
    vim.keymap.set('n', '<S-Tab>', '<Cmd>bprevious<CR>', { silent = true })
    vim.keymap.set('n', '<Leader>vbl', '<Cmd>ls<CR>', { silent = true })
    vim.keymap.set('t', '<S-Tab>', '<C-\\><C-n>', { nowait = true })

    vim.keymap.set('n', '<leader>tgs', builtin.grep_string, { desc = 'Grep string under cursor' })
    vim.keymap.set('n', '<leader>tgl', builtin.live_grep, { desc = 'Grep' })
    vim.keymap.set('n', '<leader>tfm', man_pages, { desc = 'Find Man' })
    vim.keymap.set('n', '<leader>tff', builtin.find_files, { desc = 'Find file' })
    vim.keymap.set('n', '<leader>tfb', builtin.buffers, { desc = 'Find buffer' })
    vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
  '';

  slime_repl = ''
    local g = vim.g
    g.slime_target = "neovim"
    g.slime_haskell_ghci_add_let = 0
    g.slime_no_mappings = 1

    vim.keymap.set('x', '<leader>rps', "<Plug>SlimeRegionSend")
    vim.keymap.set('n', '<leader>rpl', "<Plug>SlimeLineSend")
  '';

  lsp = ''
    -- LSP
    local cmp = require('cmp')
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- nvim-cmp setup
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = false })
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
      }),
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        -- clear all predefined mappings, like 'K' for hover
        vim.cmd("mapclear <buffer>")
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end

        if client.supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(true);
        end

        -- Mappings.
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set({ 'n', 'v' }, '<Leader>lf', function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>lca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<Leader>lrn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>le', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<Leader>lpe', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<Leader>lne', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<Leader>lq', vim.diagnostic.setloclist, opts)
      end,
    })
  '';

  lsp_servers = ''
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lspconfig.clangd.setup({
      cmd = { "clangd", },
      filetypes = { "c", "cpp" },
      capabilities = capabilities,
    })

    lspconfig.rust_analyzer.setup{
      settings = {
	['rust-analyzer'] = {
	  diagnostics = {
	    enable = false;
	  }
	}
      }
    }

    lspconfig.hls.setup({
      filetypes = { 'haskell', 'lhaskell', 'cabal' },
      cmd = { "haskell-language-server-wrapper", "--lsp" },
      capabilities = capabilities,
      settings = {
        haskell = {
          plugin = {
            rename = { config = { crossModule = true }}
          }
        }
      }
    })

    lspconfig.nixd.setup({
      cmd = { "nixd" },
      settings = {
        nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> { }",
          },
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    })

    lspconfig.lua_ls.setup({
      cmd = { "lua-language-server" },
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
            }
          }
        })
      end,
      settings = {
        Lua = {}
      },
      capabilities = capabilities,
    })

  '';

  treesitter = ''
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  '';

  dap = ''
    -- dap c, c++, rust
    local dap = require('dap')
    dap.adapters.lldb = {
      type = 'executable',
      command = '/home/box/.nix-profile/bin/lldb-dap',
      name = 'lldb'
    }

    dap.configurations.cpp = {
      {
	name = 'Launch',
	type = 'lldb',
	request = 'launch',
	program = function()
	  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
	end,
	cwd = "''${workspaceFolder}",
	stopOnEntry = false,
	args = function()
	  local args_string = vim.fn.input('Arguments: ')
	  return vim.split(args_string, " +")
	end;
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- dap haskell
    dap.adapters.haskell = {
      type = 'executable';
      command = 'haskell-debug-adapter';
    }
    dap.configurations.haskell = {
      {
	type = 'haskell',
	request = 'launch',
	name = 'Debug',
	workspace = "''${workspaceFolder}",
	startup = "''${file}",
	stopOnEntry = true,
	logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
	logLevel = 'WARNING',
	ghciEnv = vim.empty_dict(),
	ghciPrompt = "λ: ",
	-- Adjust the prompt to the prompt you see when you invoke the stack ghci command below 
	ghciInitialPrompt = "> ",
	ghciCmd= "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
      },
    }

    -- dap mappings
    vim.keymap.set('n', '<Leader>dc', function() require('dap').continue() end)
    vim.keymap.set('n', '<Leader>dso', function() require('dap').step_over() end)
    vim.keymap.set('n', '<Leader>dsi', function() require('dap').step_into() end)
    vim.keymap.set('n', '<Leader>dsou', function() require('dap').step_out() end)
    vim.keymap.set('n', '<Leader>dtb', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>dsb', function() require('dap').set_breakpoint() end)
    vim.keymap.set('n', '<Leader>dlp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
    vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end)
  '';
in
{
  config = misc + mappings + slime_repl + lsp + lsp_servers + treesitter + dap;
}
