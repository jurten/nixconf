{ pkgs, ... }: {

  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    withRuby      = false;
    viAlias       = true;
    vimAlias      = true;
    withNodeJs    = true;
    withPython3   = true;

    # ── Plugins (managed by nix, no packer/lazy needed) ──────────────────────
    plugins = with pkgs.vimPlugins; [
      # Deps
      plenary-nvim
      popup-nvim
      nvim-web-devicons

      # Colorscheme
      tokyonight-nvim

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp_luasnip
      luasnip
      friendly-snippets

      # LSP
      nvim-lspconfig
      lsp_signature-nvim
      nvim-navic
      fidget-nvim
      vim-illuminate

      # Formatting & linting (replaces null-ls which is archived)
      conform-nvim
      nvim-lint

      # Treesitter
      (nvim-treesitter.withPlugins (p: nvim-treesitter.allGrammars))
      nvim-ts-context-commentstring
      nvim-ts-autotag
      rainbow-delimiters-nvim

      # Telescope
      telescope-nvim

      # File tree
      nvim-tree-lua

      # UI
      bufferline-nvim
      lualine-nvim
      alpha-nvim
      indent-blankline-nvim
      nvim-colorizer-lua
      todo-comments-nvim

      # Editor
      nvim-autopairs
      comment-nvim
      nvim-surround
      vim-matchup
      numb-nvim
      zen-mode-nvim

      # Git
      gitsigns-nvim

      # Terminal
      toggleterm-nvim

      # Navigation
      project-nvim
      which-key-nvim

      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-nio           # required by nvim-dap-ui v4

      # Claude AI integration
      codecompanion-nvim
    ];

    # ── LSP servers & tools in neovim's PATH (replaces mason) ────────────────
    extraPackages = with pkgs; [
      # LSP servers
      pyright                       # Python
      lua-language-server           # Lua
      typescript-language-server    # JS/TS
      marksman                      # Markdown
      clang-tools                   # C/C++ (clangd)
      texlab                        # LaTeX
      nil                           # Nix (fast)
      nixd                          # Nix (feature-rich, option completion)
      bash-language-server          # Bash

      # Formatters
      black                         # Python
      stylua                        # Lua
      prettierd                     # JS/TS/HTML/CSS/JSON/Markdown (fast)
      alejandra                     # Nix
      shfmt                         # Shell

      # Linters
      shellcheck                    # Shell
      eslint_d                      # JS/TS (fast daemon)

      # Java LSP (used in ftplugin/java.lua)
      jdt-language-server
    ];

    # init.lua — loads all user modules; plugins are already in rtp via nix
    initLua = ''
      require "user.options"
      require "user.keymaps"
      require "user.colorscheme"
      require "user.cmp"
      require "user.lsp"
      require "user.conform"
      require "user.telescope"
      require "user.treesitter"
      require "user.autopairs"
      require "user.comment"
      require "user.gitsigns"
      require "user.nvim-tree"
      require "user.bufferline"
      require "user.lualine"
      require "user.toggleterm"
      require "user.project"
      require "user.indentline"
      require "user.alpha"
      require "user.whichkey"
      require "user.autocommands"
      require "user.colorizer"
      require "user.illuminate"
      require "user.navic"
      require "user.todo-comments"
      require "user.fidget"
      require "user.matchup"
      require "user.surround"
      require "user.true-zen"
      require "user.numb"
      require "user.dap"
      require "user.icons"
      require "user.functions"
      require "user.codecompanion"
    '';
  };

  # ── Lua config files ────────────────────────────────────────────────────────

  xdg.configFile."nvim/lua/user/options.lua".text = ''
    -- Ported directly from jurten/jurten-cfg; no changes needed
    local options = {
      backup         = false,
      title          = true,
      clipboard      = "unnamedplus",
      cmdheight      = 1,
      completeopt    = { "menuone", "noselect" },
      conceallevel   = 0,
      fileencoding   = "utf-8",
      hlsearch       = true,
      ignorecase     = true,
      mouse          = "a",
      pumheight      = 10,
      showmode       = false,
      showtabline    = 2,
      smartcase      = true,
      smartindent    = true,
      splitbelow     = true,
      splitright     = true,
      swapfile       = false,
      termguicolors  = true,
      timeoutlen     = 300,
      undofile       = true,
      updatetime     = 300,
      writebackup    = false,
      expandtab      = true,
      shiftwidth     = 4,
      tabstop        = 4,
      cursorline     = true,
      number         = true,
      relativenumber = true,
      numberwidth    = 4,
      signcolumn     = "yes",
      wrap           = false,
      scrolloff      = 8,
      sidescrolloff  = 8,
    }

    vim.opt.shortmess:append "c"

    for k, v in pairs(options) do
      vim.opt[k] = v
    end

    vim.cmd "set whichwrap+=<,>,[,],h,l"
    vim.cmd [[set iskeyword+=-]]
    vim.cmd [[set formatoptions-=cro]]
  '';

  xdg.configFile."nvim/lua/user/keymaps.lua".text = ''
    local opts      = { noremap = true, silent = true }
    local keymap    = vim.keymap.set

    vim.g.mapleader      = " "
    vim.g.maplocalleader = " "

    -- Better window navigation
    keymap("n", "<C-h>", "<C-w>h", opts)
    keymap("n", "<C-j>", "<C-w>j", opts)
    keymap("n", "<C-k>", "<C-w>k", opts)
    keymap("n", "<C-l>", "<C-w>l", opts)

    -- Resize windows
    keymap("n", "<C-Up>",    ":resize +2<CR>",          opts)
    keymap("n", "<C-Down>",  ":resize -2<CR>",          opts)
    keymap("n", "<C-Left>",  ":vertical resize -2<CR>", opts)
    keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

    -- Navigate buffers
    keymap("n", "<S-l>", ":bnext<CR>",     opts)
    keymap("n", "<S-h>", ":bprevious<CR>", opts)

    -- Move lines
    keymap("n", "<A-j>", ":m .+1<CR>==",  opts)
    keymap("n", "<A-k>", ":m .-2<CR>==",  opts)

    -- Insert mode escape
    keymap("i", "jk", "<ESC>", opts)

    -- Visual mode
    keymap("v", "<", "<gv",   opts)
    keymap("v", ">", ">gv",   opts)
    keymap("v", "<A-j>", ":m .+1<CR>==", opts)
    keymap("v", "<A-k>", ":m .-2<CR>==", opts)
    keymap("v", "p", '"_dP',  opts)

    -- Visual block
    keymap("x", "J",    ":move '>+1<CR>gv-gv", opts)
    keymap("x", "K",    ":move '<-2<CR>gv-gv", opts)
    keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
    keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

    -- CodeCompanion (Claude) — quick access
    keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>",    opts)
    keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>",    opts)
    keymap("n", "<C-c>", "<cmd>CodeCompanionChat Toggle<cr>", opts)
    keymap("v", "<C-c>", "<cmd>CodeCompanionChat Toggle<cr>", opts)
    -- Inline: visually select code then <leader>ci → ask Claude to refactor/explain
    keymap("v", "<leader>ci", "<cmd>CodeCompanion<cr>", opts)
  '';

  xdg.configFile."nvim/lua/user/colorscheme.lua".text = ''
    -- Tokyo Night — matches jurten's original config from jurten-cfg
    require("tokyonight").setup({
      style          = "night",   -- night | storm | day | moon
      light_style    = "day",
      transparent    = false,
      terminal_colors = true,
      styles = {
        comments   = { italic = true },
        keywords   = { italic = true },
        functions  = {},
        variables  = {},
        sidebars   = "dark",
        floats     = "dark",
      },
      dim_inactive = true,
      lualine_bold = true,
    })

    vim.cmd.colorscheme "tokyonight"
  '';

  xdg.configFile."nvim/lua/user/icons.lua".text = ''
    -- Nerd Font icons used across LSP, cmp, lualine, etc.
    local M = {}

    M.kind = {
      Class         = " ",  Color         = " ", Constant      = " ",
      Constructor   = " ",  Enum          = " ", EnumMember    = " ",
      Event         = " ",  Field         = " ", File          = " ",
      Folder        = " ",  Function      = "󰊕 ", Interface     = " ",
      Keyword       = " ",  Method        = "󰊕 ", Module        = " ",
      Operator      = " ",  Property      = " ", Reference     = " ",
      Snippet       = " ",  Struct        = " ", Text          = " ",
      TypeParameter = " ",  Unit          = " ", Value         = " ",
      Variable      = " ",
    }

    M.diagnostics = {
      Error   = " ", Warn  = " ",
      Hint    = "󰌵 ", Info  = " ",
    }

    M.git = {
      added    = " ", changed  = " ", removed  = " ",
      renamed  = "󰁕 ", untracked = " ", ignored  = " ", unstaged = "󰄱 ",
      staged   = " ", conflict  = " ",
    }

    M.ui = {
      ArrowCircleDown  = " ", BoldArrowDown = " ", BoldArrowLeft = " ",
      BoldArrowRight   = " ", BoldArrowUp   = " ", BoldClose     = " ",
      BoldDividerLeft  = " ", BoldDividerRight = " ", BoldLineLeft = "▎",
      BookMark         = " ", BoxChecked    = " ", Bug           = " ",
      Calendular       = " ", Check         = " ", ChevronRight  = "",
      Circle           = " ", Close         = "󰅖 ", CloudDownload = " ",
      Code             = " ", Comment       = " ", Dashboard     = " ",
      DividerLeft      = " ", DividerRight  = " ", DoubleChevronRight = "»",
      Ellipsis         = " ", EmptyFolder   = " ", EmptyFolderOpen = " ",
      File             = " ", FileSymlink   = " ", Files         = " ",
      FindFile         = "󰈞 ", FindText      = "󰊄 ", Fire          = " ",
      Folder           = "󰉋 ", FolderOpen    = " ", FolderSymlink = " ",
      Forward          = " ", Gear          = " ", History       = " ",
      Lightbulb        = " ", LineLeft      = "▏", LineMiddle    = "│",
      List             = " ", Lock          = " ", NewFile       = " ",
      Note             = " ", Package       = " ", Pencil        = "󰏫 ",
      Plus             = " ", Project       = " ", Search        = " ",
      SignIn           = " ", SignOut       = " ", Tab           = "󰌒 ",
      Table            = " ", Target        = "󰀘 ", Telescope     = " ",
      Text             = " ", Tree          = " ", Triangle      = "󰐊 ",
      TriangleShortArrowRight = " ", Vim = " ", Wand = " ",
    }

    return M
  '';

  xdg.configFile."nvim/lua/user/cmp.lua".text = ''
    local cmp_ok, cmp     = pcall(require, "cmp")
    local snip_ok, luasnip = pcall(require, "luasnip")
    if not cmp_ok or not snip_ok then return end

    require("luasnip/loaders/from_vscode").lazy_load()
    require("luasnip").filetype_extend("typescript", { "javascript" })

    local icons = require("user.icons")

    local kind_icons = icons.kind

    local function has_words_before()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"]  = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip  = "[Snip]",
            buffer   = "[Buf]",
            path     = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },

      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 750  },
        { name = "buffer",   priority = 500  },
        { name = "path",     priority = 250  },
      }),

      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select   = false,
      },

      window = {
        completion    = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      experimental = {
        ghost_text = true,
      },
    })

    -- Cmdline completion
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline" } }
      ),
    })
  '';

  xdg.configFile."nvim/lua/user/lsp/handlers.lua".text = ''
    local M = {}

    M.capabilities = require("cmp_nvim_lsp").default_capabilities()

    M.setup = function()
      local icons = require("user.icons")

      local signs = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warn  },
        { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint  },
        { name = "DiagnosticSignInfo",  text = icons.diagnostics.Info  },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      vim.diagnostic.config({
        virtual_text  = false,   -- use fidget / inline instead
        signs         = { active = signs },
        update_in_insert = false,
        underline     = true,
        severity_sort = true,
        float = {
          focusable = false,
          style     = "minimal",
          border    = "rounded",
          source    = "always",
          header    = "",
          prefix    = "",
        },
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = "rounded" }
      )
    end

    M.on_attach = function(client, bufnr)
      -- Navic breadcrumbs
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end

      -- Illuminate (highlight word under cursor via LSP)
      require("illuminate").on_attach(client)

      local opts = { noremap = true, silent = true, buffer = bufnr }
      local keymap = vim.keymap.set

      keymap("n", "gD",        vim.lsp.buf.declaration,                          opts)
      keymap("n", "gd",        vim.lsp.buf.definition,                           opts)
      keymap("n", "K",         vim.lsp.buf.hover,                                opts)
      keymap("n", "gi",        vim.lsp.buf.implementation,                       opts)
      keymap("n", "<C-k>",     vim.lsp.buf.signature_help,                       opts)
      keymap("n", "gr",        vim.lsp.buf.references,                           opts)
      keymap("n", "gl",        vim.diagnostic.open_float,                        opts)
      keymap("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, opts)
      keymap("n", "<leader>li", "<cmd>LspInfo<cr>",                              opts)
      keymap("n", "<leader>la", vim.lsp.buf.code_action,                         opts)
      keymap("n", "<leader>lj", vim.diagnostic.goto_next,                        opts)
      keymap("n", "<leader>lk", vim.diagnostic.goto_prev,                        opts)
      keymap("n", "<leader>lr", vim.lsp.buf.rename,                              opts)

      -- Disable tsserver formatting (prettier handles it)
      if client.name == "ts_ls" then
        client.server_capabilities.documentFormattingProvider = false
      end
    end

    return M
  '';

  xdg.configFile."nvim/lua/user/lsp/servers.lua".text = ''
    -- Servers installed via nix extraPackages — no mason needed
    -- nvim-lspconfig still provides server defaults (cmd, filetypes, root_dir)
    -- but we use the native vim.lsp.config/enable API (Neovim 0.11+)
    local handlers = require("user.lsp.handlers")

    local servers = {
      pyright = {},

      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },

      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayEnumMemberValueHints            = true,
              includeInlayFunctionLikeReturnTypeHints     = true,
              includeInlayFunctionParameterTypeHints      = true,
              includeInlayParameterNameHints              = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints    = true,
              includeInlayVariableTypeHints               = true,
            },
          },
        },
      },

      nixd      = {},
      nil_ls    = {},
      marksman  = {},
      clangd    = {},
      texlab    = {},
      bashls    = {},
    }

    for server, opts in pairs(servers) do
      opts.on_attach    = handlers.on_attach
      opts.capabilities = handlers.capabilities
      vim.lsp.config(server, opts)
    end

    vim.lsp.enable(vim.tbl_keys(servers))
  '';

  xdg.configFile."nvim/lua/user/lsp/lsp-signature.lua".text = ''
    local ok, sig = pcall(require, "lsp_signature")
    if not ok then return end

    sig.setup({
      bind            = true,
      floating_window = false,
      virtual_text    = true,
      hint_enable     = false,
      hint_prefix     = "󰌵 ",
      handler_opts    = { border = "rounded" },
      max_width       = 120,
    })
  '';

  xdg.configFile."nvim/lua/user/lsp/init.lua".text = ''
    local ok = pcall(require, "lspconfig")
    if not ok then return end

    require("user.lsp.handlers").setup()
    require("user.lsp.lsp-signature")
    require("user.lsp.servers")
  '';

  xdg.configFile."nvim/lua/user/conform.lua".text = ''
    -- Replaces null-ls (archived) for formatting
    -- Linting is handled by nvim-lint below
    local ok, conform = pcall(require, "conform")
    if not ok then return end

    conform.setup({
      formatters_by_ft = {
        python     = { "black" },
        lua        = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        vue        = { "prettierd" },
        html       = { "prettierd" },
        css        = { "prettierd" },
        json       = { "prettierd" },
        markdown   = { "prettierd" },
        nix        = { "alejandra" },
        sh         = { "shfmt" },
        bash       = { "shfmt" },
      },
      format_on_save = {
        timeout_ms   = 500,
        lsp_fallback = true,
      },
    })

    -- nvim-lint for diagnostics
    local lint_ok, lint = pcall(require, "lint")
    if not lint_ok then return end

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      sh         = { "shellcheck" },
      bash       = { "shellcheck" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  '';

  xdg.configFile."nvim/lua/user/codecompanion.lua".text = ''
    local ok, cc = pcall(require, "codecompanion")
    if not ok then return end

    cc.setup({
      -- Uses the Databricks-hosted Claude endpoint (same creds as Claude Code CLI)
      adapters = {
        databricks = function()
          return require("codecompanion.adapters").extend("anthropic", {
            name = "databricks",
            env  = {
              -- Reads the same token Claude Code uses
              api_key  = "ANTHROPIC_AUTH_TOKEN",
            },
            url  = "https://lovelytics-internal.cloud.databricks.com/serving-endpoints/anthropic/v1/messages",
            schema = {
              model = {
                default = "databricks-claude-sonnet-4-6",
              },
            },
          })
        end,
      },

      strategies = {
        chat   = { adapter = "databricks" },
        inline = { adapter = "databricks" },
        agent  = { adapter = "databricks" },
      },

      display = {
        chat = {
          window = {
            layout   = "vertical",
            width    = 0.35,
            position = "right",
            border   = "rounded",
          },
          show_settings = true,
        },
        inline = {
          layout = "buffer",
        },
        diff = {
          provider = "mini_diff",
        },
      },

      opts = {
        log_level    = "ERROR",
        language     = "English",
        system_prompt = [[
You are an expert software engineer helping with code in Neovim.
Be concise. Prefer showing code over explaining it.
When refactoring, preserve the existing style and conventions.
        ]],
      },
    })

    -- Expand 'cc' into 'CodeCompanion' in command mode
    vim.cmd([[cab cc CodeCompanion]])
  '';

  xdg.configFile."nvim/lua/user/telescope.lua".text = ''
    local ok, telescope = pcall(require, "telescope")
    if not ok then return end

    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix   = " ",
        selection_caret = " ",
        path_display    = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules", "__pycache__" },

        mappings = {
          i = {
            ["<C-n>"]   = actions.cycle_history_next,
            ["<C-p>"]   = actions.cycle_history_prev,
            ["<C-j>"]   = actions.move_selection_next,
            ["<C-k>"]   = actions.move_selection_previous,
            ["<C-c>"]   = actions.close,
            ["<Down>"]  = actions.move_selection_next,
            ["<Up>"]    = actions.move_selection_previous,
            ["<CR>"]    = actions.select_default,
            ["<C-x>"]   = actions.select_horizontal,
            ["<C-v>"]   = actions.select_vertical,
            ["<C-t>"]   = actions.select_tab,
            ["<C-u>"]   = actions.preview_scrolling_up,
            ["<C-d>"]   = actions.preview_scrolling_down,
            ["<PageUp>"]   = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"]   = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"]   = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"]   = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"]   = actions.complete_tag,
            ["<C-/>"]   = actions.which_key,
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"]  = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"]     = actions.move_selection_next,
            ["k"]     = actions.move_selection_previous,
            ["H"]     = actions.move_to_top,
            ["M"]     = actions.move_to_middle,
            ["L"]     = actions.move_to_bottom,
            ["<Down>"]    = actions.move_selection_next,
            ["<Up>"]      = actions.move_selection_previous,
            ["gg"]    = actions.move_to_top,
            ["G"]     = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"]   = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"]     = actions.which_key,
          },
        },
      },
    })
  '';

  xdg.configFile."nvim/lua/user/treesitter.lua".text = ''
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    configs.setup({
      -- Grammars are installed via nix (nvim-treesitter.withAllGrammars), not here
      auto_install     = false,
      sync_install     = false,
      highlight        = {
        enable                            = true,
        additional_vim_regex_highlighting = false,
      },
      indent           = { enable = true, disable = { "yaml" } },
      autopairs        = { enable = true },
      autotag          = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
    })

    -- Rainbow delimiters (replaces archived nvim-ts-rainbow)
    local rd_ok, rd = pcall(require, "rainbow-delimiters")
    if rd_ok then
      vim.g.rainbow_delimiters = {
        strategy = { [""] = rd.strategy["global"] },
        query    = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end
  '';

  xdg.configFile."nvim/lua/user/autopairs.lua".text = ''
    local ok, npairs = pcall(require, "nvim-autopairs")
    if not ok then return end

    npairs.setup({
      check_ts        = true,
      ts_config       = { lua = { "string", "source" }, javascript = { "string", "template_string" } },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map          = "<M-e>",
        chars        = { "{", "[", "(", '"', "'" },
        pattern      = [=[[%'%"%>%]%)%}%,]]=],
        end_key      = "$",
        keys         = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma  = true,
        highlight    = "PmenuSel",
        highlight_grey = "LineNr",
      },
    })

    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end
  '';

  xdg.configFile."nvim/lua/user/comment.lua".text = ''
    local ok, comment = pcall(require, "Comment")
    if not ok then return end

    comment.setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  '';

  xdg.configFile."nvim/lua/user/gitsigns.lua".text = ''
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then return end

    gitsigns.setup({
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 800,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "]c", gs.next_hunk,  opts)
        vim.keymap.set("n", "[c", gs.prev_hunk,  opts)
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk,  opts)
        vim.keymap.set("n", "<leader>gb", gs.blame_line,    opts)
        vim.keymap.set("n", "<leader>gr", gs.reset_hunk,    opts)
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk,    opts)
        vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, opts)
      end,
    })
  '';

  xdg.configFile."nvim/lua/user/nvim-tree.lua".text = ''
    local ok, nvimtree = pcall(require, "nvim-tree")
    if not ok then return end

    vim.g.loaded_netrw       = 1
    vim.g.loaded_netrwPlugin = 1

    local function on_attach(bufnr)
      local api  = require("nvim-tree.api")
      local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      -- custom: l = open, h = close dir, v = vsplit
      vim.keymap.set("n", "l", api.node.open.edit,                opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close,    opts("Close Directory"))
      vim.keymap.set("n", "v", api.node.open.vertical,            opts("Open Vertical"))
    end

    nvimtree.setup({
      on_attach   = on_attach,
      hijack_netrw = true,
      sync_root_with_cwd = true,
      respect_buf_cwd    = true,
      update_focused_file = { enable = true, update_root = true },
      renderer = {
        root_folder_label = false,
        highlight_git      = true,
        icons = {
          show = { git = true, file = true, folder = true, folder_arrow = true },
          glyphs = {
            default  = "",
            symlink  = "",
            bookmark = "󰆤",
            folder = {
              arrow_closed = "",
              arrow_open   = "",
              default      = "",
              open         = "",
              empty        = "",
              empty_open   = "",
              symlink      = "",
              symlink_open = "",
            },
            git = {
              unstaged  = "✗",
              staged    = "✓",
              unmerged  = "",
              renamed   = "➜",
              untracked = "★",
              deleted   = "",
              ignored   = "◌",
            },
          },
        },
      },
      filters   = { dotfiles = false },
      git       = { enable = true, ignore = false },
      actions   = {
        open_file = {
          window_picker = { enable = false },
        },
      },
    })
  '';

  xdg.configFile."nvim/lua/user/bufferline.lua".text = ''
    local ok, bufferline = pcall(require, "bufferline")
    if not ok then return end

    bufferline.setup({
      options = {
        mode                 = "buffers",
        numbers              = "none",
        close_command        = "Bdelete! %d",
        right_mouse_command  = "Bdelete! %d",
        left_mouse_command   = "buffer %d",
        middle_mouse_command = nil,
        indicator            = { icon = "▎", style = "icon" },
        buffer_close_icon    = "󰅖",
        close_icon           = "",
        left_trunc_marker    = "",
        right_trunc_marker   = "",
        max_name_length      = 30,
        max_prefix_length    = 30,
        tab_size             = 21,
        diagnostics          = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", padding = 1,
            text_align = "left", separator = true }
        },
        show_buffer_icons        = true,
        show_buffer_close_icons  = true,
        show_close_icon          = true,
        show_tab_indicators      = true,
        persist_buffer_sort      = true,
        separator_style          = "slant",
        enforce_regular_tabs     = true,
        always_show_bufferline   = true,
      },
    })
  '';

  xdg.configFile."nvim/lua/user/lualine.lua".text = ''
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    -- Tokyo Night palette
    local c = require("tokyonight.colors").setup()

    local conditions = {
      buffer_not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
      hide_in_width    = function() return vim.fn.winwidth(0) > 80 end,
    }

    lualine.setup({
      options = {
        theme                = "tokyonight",
        globalstatus         = true,
        disabled_filetypes   = { statusline = { "alpha", "dashboard" } },
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics",
            sources  = { "nvim_diagnostic" },
            symbols  = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            colored  = true,
          },
          { function() return "%=" end },
          { "filename", path = 1, shorting_target = 40, color = { fg = c.fg } },
        },
        lualine_x = {
          {
            -- Active LSP server name
            function()
              local msg    = "No LSP"
              local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then return msg end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon  = " LSP:",
            color = { fg = c.comment },
            cond  = conditions.hide_in_width,
          },
          { "filetype", colored = true },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "nvim-tree", "toggleterm", "quickfix" },
    })
  '';

  xdg.configFile."nvim/lua/user/toggleterm.lua".text = ''
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then return end

    toggleterm.setup({
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping     = [[<c-\>]],
      hide_numbers     = true,
      shade_terminals  = true,
      shading_factor   = 2,
      start_in_insert  = true,
      insert_go_back   = false,
      persist_size     = true,
      direction        = "float",
      close_on_exit    = true,
      shell            = vim.o.shell,
      float_opts       = {
        border      = "curved",
        winblend    = 0,
        highlights  = { border = "Normal", background = "Normal" },
      },
    })

    -- Named terminals
    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
    local node    = Terminal:new({ cmd = "node",    hidden = true })
    local btop    = Terminal:new({ cmd = "btop",    hidden = true })
    local python  = Terminal:new({ cmd = "python3", hidden = true })

    function _LAZYGIT_TOGGLE() lazygit:toggle() end
    function _NODE_TOGGLE()    node:toggle()    end
    function _BTOP_TOGGLE()    btop:toggle()    end
    function _PYTHON_TOGGLE()  python:toggle()  end
  '';

  xdg.configFile."nvim/lua/user/project.lua".text = ''
    local ok, project = pcall(require, "project_nvim")
    if not ok then return end

    project.setup({
      active                   = true,
      on_config_done           = nil,
      manual_mode              = false,
      detection_methods        = { "pattern" },
      patterns                 = { ".git", "Makefile", "package.json", "pyproject.toml", "flake.nix" },
      ignore_lsp               = {},
      show_hidden              = false,
      silent_chdir             = true,
      scope_chdir              = "global",
    })

    local ok2, telescope = pcall(require, "telescope")
    if ok2 then
      telescope.load_extension("projects")
    end
  '';

  xdg.configFile."nvim/lua/user/indentline.lua".text = ''
    local ok, ibl = pcall(require, "ibl")
    if not ok then return end

    ibl.setup({
      indent  = { char = "│", tab_char = "│" },
      scope   = { enabled = true, show_start = true },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "NvimTree", "Trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
      },
    })
  '';

  xdg.configFile."nvim/lua/user/alpha.lua".text = ''
    local ok, alpha = pcall(require, "alpha")
    if not ok then return end

    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                                        ",
      "       ██╗██╗   ██╗██████╗ ████████╗███████╗███╗   ██╗ ",
      "       ██║██║   ██║██╔══██╗╚══██╔══╝██╔════╝████╗  ██║ ",
      "       ██║██║   ██║██████╔╝   ██║   █████╗  ██╔██╗ ██║ ",
      "  ██   ██║██║   ██║██╔══██╗   ██║   ██╔══╝  ██║╚██╗██║ ",
      "  ╚█████╔╝╚██████╔╝██║  ██║   ██║   ███████╗██║ ╚████║ ",
      "   ╚════╝  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝ ",
      "                                                        ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file",     ":Telescope find_files<CR>"),
      dashboard.button("n", "  New file",       ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", "  Recent files",  ":Telescope oldfiles<CR>"),
      dashboard.button("t", "󰊄  Find text",     ":Telescope live_grep<CR>"),
      dashboard.button("p", "  Projects",       ":Telescope projects<CR>"),
      dashboard.button("c", "  Claude Chat",   ":CodeCompanionChat<CR>"),
      dashboard.button("q", "  Quit",          ":qa<CR>"),
    }

    dashboard.section.footer.val = "  jurten-cfg — catppuccin mocha"

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  '';

  xdg.configFile."nvim/lua/user/whichkey.lua".text = ''
    local ok, wk = pcall(require, "which-key")
    if not ok then return end

    wk.setup({
      plugins = {
        marks        = true,
        registers    = true,
        spelling     = { enabled = true, suggestions = 20 },
        presets = {
          operators    = false,
          motions      = false,
          text_objects = false,
          windows      = false,
          nav          = false,
          z            = true,
          g            = true,
        },
      },
      win    = { border = "rounded", padding = { 2, 2 } },
      layout = { align = "center" },
    })

    -- which-key v3 API
    wk.add({
      -- Buffers
      { "<leader>b",  group = "Buffers" },
      { "<leader>bj", "<cmd>BufferLinePick<cr>",              desc = "Jump to buffer" },
      { "<leader>bf", "<cmd>Telescope buffers<cr>",           desc = "Find buffer" },
      { "<leader>bw", "<cmd>BufferLineCloseOther<cr>",        desc = "Close others" },
      { "<leader>bd", "<cmd>Bdelete<cr>",                     desc = "Delete buffer" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",         desc = "Close left" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>",        desc = "Close right" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",         desc = "Pin buffer" },

      -- File
      { "<leader>e",  "<cmd>NvimTreeToggle<cr>",              desc = "Explorer" },
      { "<leader>f",  "<cmd>Telescope find_files<cr>",        desc = "Find files" },
      { "<leader>F",  "<cmd>Telescope live_grep<cr>",         desc = "Find text" },
      { "<leader>h",  "<cmd>nohlsearch<cr>",                  desc = "Clear highlights" },
      { "<leader>w",  "<cmd>w!<CR>",                          desc = "Save" },
      { "<leader>q",  "<cmd>q!<CR>",                          desc = "Quit" },
      { "<leader>c",  "<cmd>Bdelete!<CR>",                    desc = "Close buffer" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find" },

      -- Search
      { "<leader>s",  group = "Search" },
      { "<leader>sb", "<cmd>Telescope git_branches<cr>",      desc = "Branches" },
      { "<leader>sc", "<cmd>Telescope colorscheme<cr>",       desc = "Colorscheme" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",         desc = "Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",           desc = "Keymaps" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>",         desc = "Man pages" },
      { "<leader>sr", "<cmd>Telescope oldfiles<cr>",          desc = "Recent files" },
      { "<leader>sR", "<cmd>Telescope registers<cr>",         desc = "Registers" },
      { "<leader>st", "<cmd>Telescope live_grep<cr>",         desc = "Find text" },
      { "<leader>sp", "<cmd>Telescope projects<cr>",          desc = "Projects" },

      -- Git
      { "<leader>g",  group = "Git" },
      { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>",       desc = "Lazygit" },
      { "<leader>gj", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next hunk" },
      { "<leader>gk", "<cmd>lua require('gitsigns').prev_hunk()<cr>", desc = "Prev hunk" },
      { "<leader>gb", "<cmd>lua require('gitsigns').blame_line()<cr>", desc = "Blame" },
      { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", desc = "Preview hunk" },
      { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", desc = "Reset hunk" },
      { "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", desc = "Stage hunk" },
      { "<leader>gd", "<cmd>Telescope git_status<cr>",        desc = "Diff" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",       desc = "Commits" },

      -- LSP
      { "<leader>l",  group = "LSP" },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
      { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>lD", "<cmd>Telescope diagnostics<cr>",       desc = "All diagnostics" },
      { "<leader>lf", "<cmd>lua require('conform').format({ async=true })<cr>", desc = "Format" },
      { "<leader>li", "<cmd>LspInfo<cr>",                     desc = "LSP info" },
      { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next diagnostic" },
      { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev diagnostic" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",    desc = "Rename" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },

      -- Terminal
      { "<leader>t",  group = "Terminal" },
      { "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>",       desc = "Lazygit" },
      { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>",           desc = "Node" },
      { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>",         desc = "Python" },
      { "<leader>tb", "<cmd>lua _BTOP_TOGGLE()<CR>",           desc = "Btop" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",  desc = "Float" },
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",   desc = "Vertical" },

      -- Claude AI (CodeCompanion)
      { "<leader>a",  group = "Claude AI" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",    desc = "Chat toggle" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",        desc = "Action palette" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>",           desc = "New chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>",               desc = "Inline assist",  mode = "v" },
      { "<leader>ae", "<cmd>CodeCompanion /explain<cr>",      desc = "Explain code",   mode = "v" },
      { "<leader>ar", "<cmd>CodeCompanion /refactor<cr>",     desc = "Refactor code",  mode = "v" },
      { "<leader>at", "<cmd>CodeCompanion /tests<cr>",        desc = "Write tests",    mode = "v" },

      -- Debug (DAP)
      { "<leader>d",  group = "Debug" },
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>",  desc = "Breakpoint" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<cr>",           desc = "Continue" },
      { "<leader>di", "<cmd>lua require('dap').step_into()<cr>",          desc = "Step into" },
      { "<leader>do", "<cmd>lua require('dap').step_over()<cr>",          desc = "Step over" },
      { "<leader>dO", "<cmd>lua require('dap').step_out()<cr>",           desc = "Step out" },
      { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>",        desc = "REPL" },
      { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>",           desc = "UI" },

      -- Zen mode
      { "<leader>z",  "<cmd>ZenMode<cr>",                     desc = "Zen mode" },
    })
  '';

  xdg.configFile."nvim/lua/user/autocommands.lua".text = ''
    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd

    -- General settings
    local general = augroup("_general_settings", {})

    autocmd("FileType", {
      group   = general,
      pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
      command = "nnoremap <silent> <buffer> q :close<CR>",
    })

    autocmd("TextYankPost", {
      group    = general,
      callback = function() vim.highlight.on_yank { higroup = "Search", timeout = 200 } end,
    })

    autocmd("BufWinEnter", {
      group   = general,
      command = "set formatoptions-=cro",
    })

    autocmd("FileType", {
      group   = general,
      pattern = { "gitcommit", "markdown" },
      callback = function()
        vim.opt_local.wrap  = true
        vim.opt_local.spell = true
      end,
    })

    -- Auto-resize splits when vim is resized
    autocmd("VimResized", {
      group    = general,
      callback = function() vim.cmd("tabdo wincmd =") end,
    })

    -- Alpha: hide tabline/statusline
    local alpha_group = augroup("_alpha", {})
    autocmd("FileType", {
      group   = alpha_group,
      pattern = "alpha",
      callback = function()
        vim.cmd("set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2")
        vim.cmd("set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3")
      end,
    })

    -- Per-filetype indentation
    autocmd("FileType", {
      group   = general,
      pattern = { "typescript", "javascript", "vue", "html", "css", "json" },
      callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop    = 2
      end,
    })

    -- Open nvim-tree on start (when not opening a file directly)
    autocmd("VimEnter", {
      group = general,
      callback = function(data)
        local real_file  = vim.fn.filereadable(data.file) == 1
        local no_name    = data.file == "" and vim.bo[data.buf].buftype == ""
        local ignored_ft = { "gitcommit", "gitrebase", "NvimTree", "alpha" }
        local ft         = vim.bo[data.buf].filetype
        if vim.tbl_contains(ignored_ft, ft) then return end
        if real_file or no_name then
          require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
        end
      end,
    })
  '';

  xdg.configFile."nvim/lua/user/colorizer.lua".text = ''
    local ok, colorizer = pcall(require, "colorizer")
    if not ok then return end

    colorizer.setup({ "*" }, {
      RGB      = true,
      RRGGBB   = true,
      names    = true,
      RRGGBBAA = false,
      rgb_fn   = false,
      hsl_fn   = false,
      css      = false,
      css_fn   = false,
      mode     = "background",
    })
  '';

  xdg.configFile."nvim/lua/user/illuminate.lua".text = ''
    local ok, illuminate = pcall(require, "illuminate")
    if not ok then return end

    illuminate.configure({
      providers        = { "lsp", "treesitter", "regex" },
      delay            = 200,
      filetypes_denylist = { "alpha", "NvimTree", "TelescopePrompt" },
      under_cursor     = true,
    })

    vim.keymap.set("n", "<a-n>", function() illuminate.goto_next_reference(true) end,  { desc = "Next reference" })
    vim.keymap.set("n", "<a-p>", function() illuminate.goto_prev_reference(true) end,  { desc = "Prev reference" })
  '';

  xdg.configFile."nvim/lua/user/navic.lua".text = ''
    local ok, navic = pcall(require, "nvim-navic")
    if not ok then return end

    local icons = require("user.icons")

    navic.setup({
      icons = icons.kind,
      highlight    = true,
      separator    = " ❯ ",
      depth_limit  = 0,
      depth_limit_indicator = "..",
    })
  '';

  xdg.configFile."nvim/lua/user/todo-comments.lua".text = ''
    local ok, todo = pcall(require, "todo-comments")
    if not ok then return end

    local icons = require("user.icons")

    todo.setup({
      signs      = true,
      sign_priority = 8,
      keywords = {
        FIX  = { icon = icons.ui.Bug,         color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = icons.ui.Check,        color = "info"  },
        HACK = { icon = icons.ui.Fire,         color = "warning"  },
        WARN = { icon = icons.diagnostics.Warn, color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.ui.Dashboard,    alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.ui.Note,         color = "hint",    alt = { "INFO" } },
      },
      search = {
        command = "rg",
        args    = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
        pattern = [[\b(KEYWORDS):]],
      },
    })
  '';

  xdg.configFile."nvim/lua/user/fidget.lua".text = ''
    -- fidget v2 API (breaking change from v1)
    local ok, fidget = pcall(require, "fidget")
    if not ok then return end

    fidget.setup({
      progress = {
        display = {
          render_limit = 8,
          done_ttl     = 3,
        },
      },
      notification = {
        window = {
          winblend    = 0,
          border      = "none",
          zindex      = 45,
          max_width   = 0,
          max_height  = 0,
          x_padding   = 1,
          y_padding   = 0,
          align       = "bottom",
          relative    = "editor",
        },
      },
    })
  '';

  xdg.configFile."nvim/lua/user/matchup.lua".text = ''
    vim.g.matchup_matchparen_offscreen = { method = nil }
    vim.g.matchup_matchpref            = { html = { nolists = 1 } }
  '';

  xdg.configFile."nvim/lua/user/surround.lua".text = ''
    local ok, surround = pcall(require, "nvim-surround")
    if not ok then return end

    surround.setup({
      keymaps = {
        insert          = "<C-g>s",
        insert_line     = "<C-g>S",
        normal          = "ys",
        normal_cur      = "yss",
        normal_line     = "yS",
        normal_cur_line = "ySS",
        visual          = "S",
        visual_line     = "gS",
        delete          = "ds",
        change          = "cs",
        change_line     = "cS",
      },
    })

    -- Surround word with quotes: <leader>'
    vim.keymap.set("n", "<leader>'", "ysiw'", { remap = true, desc = "Surround word with '" })
  '';

  xdg.configFile."nvim/lua/user/true-zen.lua".text = ''
    local ok, zen = pcall(require, "zen-mode")
    if not ok then return end

    zen.setup({
      window = {
        backdrop  = 0.90,
        width     = 120,
        height    = 1,
        options   = {
          signcolumn   = "no",
          number       = false,
          relativenumber = false,
          cursorline   = false,
          cursorcolumn = false,
          foldcolumn   = "0",
          list         = false,
        },
      },
      plugins = {
        options    = { enabled = true, ruler = false, showcmd = false },
        twilight   = { enabled = false },
        gitsigns   = { enabled = false },
        tmux       = { enabled = false },
        kitty      = { enabled = true, font = "+2" },
      },
    })
  '';

  xdg.configFile."nvim/lua/user/numb.lua".text = ''
    local ok, numb = pcall(require, "numb")
    if not ok then return end

    numb.setup({ show_numbers = true, show_cursorline = true, hide_relativenumbers = true })
  '';

  xdg.configFile."nvim/lua/user/dap.lua".text = ''
    local dap_ok,    dap    = pcall(require, "dap")
    local dapui_ok,  dapui  = pcall(require, "dapui")
    local dvt_ok,    dvt    = pcall(require, "nvim-dap-virtual-text")
    if not dap_ok or not dapui_ok then return end

    if dvt_ok then dvt.setup() end

    -- Python
    dap.adapters.python = {
      type    = "executable",
      command = "python3",
      args    = { "-m", "debugpy.adapter" },
    }
    dap.configurations.python = {
      {
        type     = "python",
        request  = "launch",
        name     = "Launch file",
        program  = "''${file}",
        pythonPath = function() return "python3" end,
      },
    }

    -- DAP UI layout
    dapui.setup({
      icons    = { expanded = "", collapsed = "", current_frame = "" },
      layouts  = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size     = 40,
          position = "right",
        },
        {
          elements = { "repl", "console" },
          size     = 0.25,
          position = "bottom",
        },
      },
      floating = { border = "rounded" },
    })

    -- Auto-open/close dap-ui
    dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open()  end
    dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
  '';

  xdg.configFile."nvim/lua/user/functions.lua".text = ''
    local M = {}

    M.toggle_option = function(option)
      local value = not vim.api.nvim_get_option_value(option, {})
      vim.opt[option] = value
      vim.notify(option .. " set to " .. tostring(value))
    end

    M.smart_quit = function()
      local bufnr     = vim.api.nvim_get_current_buf()
      local buf_windows = vim.call("win_findbuf", bufnr)
      local modified    = vim.api.nvim_get_option_value("modified", { buf = bufnr })
      if modified and #buf_windows == 1 then
        vim.ui.input({
          prompt = "You have unsaved changes. Quit anyway? (y/n) ",
        }, function(input)
          if input == "y" then vim.cmd("q!") end
        end)
      else
        vim.cmd("q!")
      end
    end

    return M
  '';

  # ── ftplugins (ported from jurten-cfg) ────────────────────────────────────
  xdg.configFile."nvim/ftplugin/java.lua".text = ''
    local jdtls_ok, jdtls = pcall(require, "jdtls")
    if not jdtls_ok then return end

    local home      = os.getenv("HOME")
    local workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    local config = {
      cmd = {
        "jdt-language-server",
        "-data", workspace,
      },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
        },
      },
    }

    jdtls.start_or_attach(config)
  '';

  xdg.configFile."nvim/ftplugin/plaintex.lua".text = ''
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", "<leader>Lc", "<cmd>TexlabBuild<cr>",   opts)
    vim.keymap.set("n", "<leader>Lo", "<cmd>TexlabForward<cr>", opts)
  '';
}
