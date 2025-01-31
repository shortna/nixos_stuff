{
  config = ''
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
    vim.wo.foldmethod = 'manual'

    -- indent stuff
    opt.expandtab = true
    opt.shiftwidth = 2
    opt.tabstop = 2
    opt.softtabstop = 2
    opt.cindent = true
    opt.cinoptions = "1s"

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

    -- mappings
    g.mapleader = " "

    vim.keymap.set('n', '<Leader>e', '<Cmd>Ex<CR>', { nowait = true, silent = true })
    vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>', { nowait = true, silent = true })
    vim.keymap.set('n', '<S-Tab>', '<Cmd>bprevious<CR>', { nowait = true, silent = true })
    vim.keymap.set('n', '<Leader>l', '<Cmd>ls<CR>', { nowait = true, silent = true })
    vim.keymap.set('t', '<S-Tab>', '<C-\\><C-n>', { nowait = true })

    local builtin = require('telescope.builtin')
    local function man_pages()
      return builtin.man_pages({ sections = { "2", "3" } });
    end

    vim.keymap.set('n', '<leader>gs', builtin.grep_string, { desc = 'Grep string under cursor' })
    vim.keymap.set('n', '<leader>gl', builtin.live_grep, { desc = 'Grep' })
    vim.keymap.set('n', '<leader>fm', man_pages, { desc = 'Find Man' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find file' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffer' })
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

    -- presistent undo
    opt.undofile = true

    -- lua is enough
    g.loaded_node_provider = 0
    g.loaded_perl_provider = 0
    g.loaded_ruby_provider = 0
    g.loaded_python3_provider = 0

    -- repl
    g.slime_target = "neovim"
    g.slime_haskell_ghci_add_let = 0
    g.slime_no_mappings = 1

    vim.keymap.set('x', '<leader>ps', "<Plug>SlimeRegionSend")
    vim.keymap.set('n', '<leader>pl', "<Plug>SlimeLineSend")

    g.airline_symbols_ascii = 1
    g.airline_section_z = ""

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
        vim.keymap.set({ 'n', 'v' }, '<Leader>F', function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<Leader>d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<Leader>h', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<Leader>s', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<Leader>r', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>f', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<Leader>pe', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<Leader>ne', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
      end,
    })

    lspconfig.clangd.setup({
      cmd = { "clangd", },
      filetypes = { "c", "cpp" },
      capabilities = capabilities,
    })

    lspconfig.hls.setup({
      filetypes = { 'haskell', 'lhaskell', 'cabal' },
      cmd = { "haskell-language-server-wrapper", "--lsp" },
      capabilities = capabilities,
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

    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })

    vim.cmd("colorscheme catppuccin-latte")
  '';
}
