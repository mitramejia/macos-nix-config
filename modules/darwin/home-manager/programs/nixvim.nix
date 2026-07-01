{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    enable = true;
    nixpkgs.source = inputs.nixpkgs;
    wrapRc = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 200;
      cursorline = true;
      spell = true;
      spelllang = ["en"];
      clipboard = "unnamedplus";
      timeoutlen = 500;
      scrolloff = 10;
      smartcase = true;
      incsearch = true;
      hlsearch = true;
      autoread = true;
      showmode = true;
      showcmd = true;
      guifont = "JetBrainsMono Nerd Font Mono:h14";
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
      };
    };

    plugins = {
      web-devicons.enable = true;
      lualine = {
        enable = true;
        settings = {
          options = {theme = "catppuccin";};
        };
      };
      bufferline.enable = true;
      indent-blankline.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;

      neo-tree = {
        enable = true;
        settings = {
          window.mappings = {
            "<space>" = "none";
          };
          filesystem.window.mappings = {
            "o" = "open";
          };
        };
      };
      telescope.enable = true;

      treesitter.enable = true;
      treesitter-context.enable = false;

      project-nvim.enable = true;

      notify.enable = true;
      noice.enable = true;

      alpha = {
        enable = true;
        theme = "dashboard";
      };

      gitsigns.enable = true;
      diffview.enable = true;

      hop.enable = true;
      leap.enable = true;
      vim-surround.enable = true;
      comment.enable = true;
      which-key = {
        enable = true;
        settings = {
          delay = 300;
        };
      };
      tmux-navigator.enable = true;

      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          enable_check_bracket_line = false;
          fast_wrap = {
            enable = true;
            map = "<M-e>";
            chars = ["{" "[" "(" "\"" "'" "`"];
          };
        };
      };

      toggleterm = {
        enable = true;
        settings = {direction = "float";};
      };

      trouble.enable = true;
      markdown-preview.enable = true;

      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "default";
            "<C-n>" = ["show" "select_next" "fallback"];
            "<C-p>" = ["show" "select_prev" "fallback"];
            "<CR>" = ["accept" "fallback"];
            "<Tab>" = ["select_next" "fallback"];
            "<S-Tab>" = ["select_prev" "fallback"];
          };
          appearance = {
            nerd_font_variant = "mono";
          };
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 500;
            };
          };
          sources = {
            default = ["lsp" "path" "snippets" "buffer"];
          };
          snippets = {
            preset = "luasnip";
          };
          fuzzy = {
            implementation = "prefer_rust_with_warning";
          };
          signature = {
            enabled = true;
          };
        };
      };

      luasnip.enable = true;
      friendly-snippets.enable = true;
      lsp-signature.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          clangd.enable = true;
          zls.enable = true;
          marksman.enable = true;
        };
        keymaps = {
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = ["alejandra"];
            lua = ["stylua"];
            javascript = ["prettierd"];
            typescript = ["prettierd"];
            javascriptreact = ["prettierd"];
            typescriptreact = ["prettierd"];
            css = ["prettierd"];
            html = ["prettierd"];
            markdown = ["prettier"];
            "markdown.mdx" = ["prettier"];
            sh = ["shfmt"];
          };
          format_on_save = {
            lsp_fallback = true;
          };
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      snacks-nvim
    ];

    keymaps = [
      {
        key = "jk";
        mode = ["i"];
        action = "<ESC>";
        options.desc = "Exit insert mode";
      }

      {
        key = "<leader>f";
        mode = ["n"];
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find file";
      }
      {
        key = "<leader>ff";
        mode = ["n"];
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        key = "<leader>fp";
        mode = ["n"];
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Find in project";
      }
      {
        key = "<leader>fr";
        mode = ["n"];
        action = "<cmd>Telescope oldfiles<cr>";
        options.desc = "Recent files";
      }
      {
        key = "<leader>fn";
        mode = ["n"];
        action = "<cmd>enew<cr>";
        options.desc = "New file";
      }
      {
        key = "<leader>e";
        mode = ["n"];
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "File browser toggle";
      }

      {
        key = "<A-n>";
        mode = ["n"];
        action = "<cmd>tabnext<cr>";
        options.desc = "Next tab";
      }
      {
        key = "<A-p>";
        mode = ["n"];
        action = "<cmd>tabprevious<cr>";
        options.desc = "Previous tab";
      }

      {
        key = "<A-h>";
        mode = ["n"];
        action = "<C-w>h";
        options.desc = "Pane left";
      }
      {
        key = "<A-j>";
        mode = ["n"];
        action = "<C-w>j";
        options.desc = "Pane down";
      }
      {
        key = "<A-k>";
        mode = ["n"];
        action = "<C-w>k";
        options.desc = "Pane up";
      }
      {
        key = "<A-l>";
        mode = ["n"];
        action = "<C-w>l";
        options.desc = "Pane right";
      }
      {
        key = "<C-h>";
        mode = ["t"];
        action = "<C-\\><C-n><Cmd>TmuxNavigateLeft<CR>";
        options.desc = "Tmux navigate left (terminal)";
      }
      {
        key = "<C-j>";
        mode = ["t"];
        action = "<C-\\><C-n><Cmd>TmuxNavigateDown<CR>";
        options.desc = "Tmux navigate down (terminal)";
      }
      {
        key = "<C-k>";
        mode = ["t"];
        action = "<C-\\><C-n><Cmd>TmuxNavigateUp<CR>";
        options.desc = "Tmux navigate up (terminal)";
      }
      {
        key = "<C-l>";
        mode = ["t"];
        action = "<C-\\><C-n><Cmd>TmuxNavigateRight<CR>";
        options.desc = "Tmux navigate right (terminal)";
      }

      {
        key = "<leader>wv";
        mode = ["n"];
        action = "<cmd>vsplit<cr>";
        options.desc = "Split vertical";
      }
      {
        key = "<leader>ws";
        mode = ["n"];
        action = "<cmd>split<cr>";
        options.desc = "Split horizontal";
      }
      {
        key = "<leader>wu";
        mode = ["n"];
        action = "<cmd>only<cr>";
        options.desc = "Unsplit";
      }
      {
        key = "<leader>wm";
        mode = ["n"];
        action = "<cmd>wincmd L<cr>";
        options.desc = "Move window";
      }

      {
        key = "<leader>.";
        mode = ["n"];
        action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Comment line";
      }
      {
        key = "<leader>.";
        mode = ["v"];
        action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Comment selection";
      }

      {
        key = "cl";
        mode = ["n"];
        action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Comment line";
      }
      {
        key = "cl";
        mode = ["v"];
        action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Comment selection";
      }

      {
        key = "<leader>dj";
        mode = ["n"];
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Go to next diagnostic";
      }
      {
        key = "<leader>dk";
        mode = ["n"];
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Go to previous diagnostic";
      }
      {
        key = "<leader>dl";
        mode = ["n"];
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show diagnostic details";
      }
      {
        key = "<leader>dt";
        mode = ["n"];
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics list";
      }

      {
        key = "<leader>am";
        mode = ["n"];
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code actions";
      }
      {
        key = "<leader>as";
        mode = ["n"];
        action = "<cmd>Telescope builtin<CR>";
        options.desc = "Search everywhere";
      }
      {
        key = "<leader>ar";
        mode = ["n"];
        action = "<cmd>Telescope commands<CR>";
        options.desc = "Run command";
      }
      {
        key = "<leader>gf";
        mode = ["n"];
        action = "<cmd>Telescope git_files<CR>";
        options.desc = "Git files";
      }
      {
        key = "<leader>gb";
        mode = ["n"];
        action = "<cmd>Telescope git_branches<CR>";
        options.desc = "Git branches";
      }
      {
        key = "<leader>gs";
        mode = ["n"];
        action = "<cmd>Telescope git_status<CR>";
        options.desc = "Git status";
      }
      {
        key = "<leader>gl";
        mode = ["n"];
        action = "<cmd>Telescope git_commits<CR>";
        options.desc = "Git log";
      }
      {
        key = "<leader>gH";
        mode = ["n"];
        action = "<cmd>DiffviewFileHistory %<CR>";
        options.desc = "File history";
      }
      {
        key = "<leader>gA";
        mode = ["n"];
        action = "<cmd>DiffviewFileHistory<CR>";
        options.desc = "Project history";
      }
      {
        key = "<leader>gd";
        mode = ["n"];
        action = "<cmd>DiffviewOpen<CR>";
        options.desc = "Open diffview";
      }
      {
        key = "<leader>gq";
        mode = ["n"];
        action = "<cmd>DiffviewClose<CR>";
        options.desc = "Close diffview";
      }
      {
        key = "<leader>ghn";
        mode = ["n"];
        action = "<cmd>Gitsigns next_hunk<CR>";
        options.desc = "Next hunk";
      }
      {
        key = "<leader>ghp";
        mode = ["n"];
        action = "<cmd>Gitsigns prev_hunk<CR>";
        options.desc = "Previous hunk";
      }
      {
        key = "<leader>ghs";
        mode = ["n" "v"];
        action = "<cmd>Gitsigns stage_hunk<CR>";
        options.desc = "Stage hunk";
      }
      {
        key = "<leader>ghr";
        mode = ["n" "v"];
        action = "<cmd>Gitsigns reset_hunk<CR>";
        options.desc = "Reset hunk";
      }
      {
        key = "<leader>ghu";
        mode = ["n"];
        action = "<cmd>Gitsigns undo_stage_hunk<CR>";
        options.desc = "Undo stage hunk";
      }
      {
        key = "<leader>ghv";
        mode = ["n"];
        action = "<cmd>Gitsigns preview_hunk<CR>";
        options.desc = "Preview hunk";
      }
      {
        key = "<leader>gtb";
        mode = ["n"];
        action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
        options.desc = "Toggle line blame";
      }
      {
        key = "<leader>gtw";
        mode = ["n"];
        action = "<cmd>Gitsigns toggle_word_diff<CR>";
        options.desc = "Toggle word diff";
      }

      {
        key = "<leader>q";
        mode = ["n"];
        action = "<cmd>q<CR>";
        options.desc = "Close current window";
      }

      {
        key = "H";
        mode = ["n" "v"];
        action = "^";
        options.desc = "Line start";
      }
      {
        key = "L";
        mode = ["n" "v"];
        action = "$";
        options.desc = "Line end";
      }

      {
        key = "<F1>";
        mode = ["n" "i" "v" "x" "s" "o" "t" "c"];
        action = "<Nop>";
        options.desc = "Disable accidental F1 help";
      }
      {
        key = "<leader>h";
        mode = ["n"];
        action = ":help<Space>";
        options = {
          desc = "Open :help prompt";
          nowait = true;
        };
      }
      {
        key = "<leader>H";
        mode = ["n"];
        action = ":help <C-r><C-w><CR>";
        options.desc = "Help for word under cursor";
      }
    ];

    extraPackages =
      (with pkgs; [
        ripgrep
        fd
        bat
        lazygit
        nil
        typescript-language-server
        typescript
        vscode-langservers-extracted
        pyright
        lua-language-server
        zls
        marksman
        multimarkdown
        clang-tools
        prettierd
        prettier
        stylua
        shfmt
        alejandra
        figlet
        toilet
      ])
      ++ lib.optionals pkgs.stdenv.isLinux [
        pkgs."wl-clipboard"
        pkgs.hyprls
      ];

    extraConfigLua = ''
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        update_in_insert = true,
        severity_sort = true,
        underline = true,
        signs = true,
      })

      local function lsp_on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "K", vim.lsp.buf.hover, "Hover docs")
        map("n", "gd", vim.lsp.buf.definition, "Goto definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      end

      if vim.g.__nixvim_lsp_attached ~= true then
        vim.g.__nixvim_lsp_attached = true
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            lsp_on_attach(nil, args.buf)
          end,
        })
      end

      local ok_notify, notify = pcall(require, "notify")
      if ok_notify then
        notify.setup({ background_colour = "#1e1e2e" })
        vim.notify = notify
      end

      local ok_snacks, snacks = pcall(require, "snacks")
      if ok_snacks then
        snacks.setup({
          input = {
            enabled = true,
          },
          picker = {
            enabled = true,
          },
          terminal = {
            enabled = true,
          },
        })
      end

      local ok_wk, wk = pcall(require, "which-key")
      if ok_wk then
        wk.add({
          { "<leader>a", group = "Actions" },
          { "<leader>d", group = "Diagnostics" },
          { "<leader>f", group = "Files" },
          { "<leader>g", group = "Git" },
          { "<leader>gh", group = "Git Hunks" },
          { "<leader>gt", group = "Git Toggles" },
          { "<leader>w", group = "Windows" },
        })
      end

      local ok_alpha, alpha = pcall(require, "alpha")
      if ok_alpha then
        local dashboard = require("alpha.themes.dashboard")

        local header_lines = nil
        local function gen_banner(cmd)
          local h = io.popen(cmd)
          if not h then return nil end
          local out = h:read("*a") or ""
          h:close()
          if #out == 0 then return nil end
          local lines = {}
          for line in out:gmatch("([^\n]*)\n?") do
            if line ~= "" then table.insert(lines, line) end
          end
          return #lines > 0 and lines or nil
        end

        header_lines = gen_banner("toilet -f ansi-shadow NIXVIM 2>/dev/null")
          or gen_banner("figlet -f \"ANSI Shadow\" NIXVIM 2>/dev/null")
          or gen_banner("figlet NIXVIM 2>/dev/null")
          or { "NIXVIM" }

        dashboard.section.header.val = header_lines
        dashboard.section.buttons.val = {
          dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
          dashboard.button("r", "Recent files", ":Telescope oldfiles<CR>"),
          dashboard.button("g", "Live grep", ":Telescope live_grep<CR>"),
          dashboard.button("n", "New file", ":enew<CR>"),
          dashboard.button("e", "File browser", ":Neotree toggle<CR>"),
          dashboard.button("q", "Quit", ":qa<CR>"),
        }

        local v = vim.version()
        dashboard.section.footer.val = string.format("NixVim | Neovim %d.%d.%d", v.major, v.minor, v.patch)
        dashboard.opts.opts.noautocmd = true
        alpha.setup(dashboard.config)

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "alpha",
          callback = function()
            vim.opt_local.foldenable = false
          end,
        })
      end
    '';
  };
}
