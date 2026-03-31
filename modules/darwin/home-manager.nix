{
  username,
  userEmail,
  hostname,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dock
  ];

  # It me
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    # masApps = {
    #   "1password" = 1333542190;
    # };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${username} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      imports = [inputs.nixvim.homeModules.nixvim];

      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        stateVersion = "23.11";
      };

      home.activation.linkOpencodeSkills = lib.hm.dag.entryAfter ["writeBoundary"] ''
        skills_source="$HOME/.codex/skills"
        skills_target="$HOME/.config/opencode/skills"

        mkdir -p "$(dirname "$skills_target")"

        if [[ -d "$skills_source" ]]; then
          rm -rf "$skills_target"
          ln -s "$skills_source" "$skills_target"
        fi
      '';

      programs = {
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };

        fzf = {
          enable = true;
          defaultOptions = ["--color 16"];
          enableZshIntegration = true;
        };
        starship = {
          enable = true;
          package = pkgs.starship;
          settings = {
            command_timeout = 5000;
          };
        };

        ghostty = {
          enable = true;
          package =
            if pkgs.stdenv.isDarwin
            then pkgs.ghostty-bin
            else pkgs.ghostty;
          enableZshIntegration = true;
          settings = {
            theme = "Catppuccin Mocha";
            font-family = "JetBrainsMono NFM Regular";
            font-size = 14.5;
            window-padding-x = 16;
            window-padding-y = 16;
            adjust-cell-height = 10;
            cursor-style = "block";
            cursor-style-blink = true;
            scrollback-limit = 200000;
            copy-on-select = false;
            clipboard-read = "allow";
            clipboard-write = "allow";
            mouse-hide-while-typing = true;
            shell-integration = "detect";
          };
        };

        zsh = {
          enable = true;
          enableCompletion = false;
          syntaxHighlighting.enable = true;
          autosuggestion.enable = true;
          autocd = true;
          cdpath = ["~/.local/share/src"];

          oh-my-zsh = {
            enable = true;
            plugins = ["git" "z" "vi-mode" "aliases" "yarn" "macos"];
            theme = ""; # disable theme to allow nix/home-manager starship to control prompt
            extraConfig = ''
              DISABLE_AUTO_TITLE=true
            '';
          };
          initContent = lib.mkBefore ''
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
              . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
              . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
            fi

            if [[ "$(uname)" == "Linux" ]]; then
              alias pbcopy='xclip -selection clipboard'
            fi

            # Define variables for directories
            export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
            export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
            export PATH=$HOME/.composer/vendor/bin:$PATH
            export PATH=$HOME/.local/share/bin:$PATH

            export ANDROID_HOME=$HOME/Library/Android/sdk

            export PNPM_HOME=~/.pnpm-packages

            export PATH="$HOME/.local/bin:$HOME/.pyenv/versions/3.12.7/bin/:$PATH"


            export PATH="$HOME/.local/bin:$HOME/.pyenv/versions/3.12.7/bin/:$PATH"

            # Remove history data we don't want to see
            export HISTIGNORE="pwd:ls:cd"

            # Clean stale tmux default socket to avoid "not a terminal" errors.
            tmux_sock="/private/tmp/tmux-$(id -u)/default"
            if [[ -S "$tmux_sock" ]] && ! pgrep -x tmux >/dev/null 2>&1; then
              rm -f "$tmux_sock"
            fi

            # Vim is my editor
            export ALTERNATE_EDITOR=""
            export EDITOR="vim"
          '';
          shellAliases = {
            v = "nvim";
            cat = "bat";
            ls = "eza --icons";
            ll = "eza -lh --icons --grid --group-directories-first";
            la = "eza -lah --icons --grid --group-directories-first";
            ".." = "cd ..";
            gp = "git push origin";
            gpf = "git push --force-with-lease origin";
            gash = "git stash";
            gasha = "git stash apply";
            gplo = "git pull origin";
            open-pr = "gh pr create";
            p = "pnpm";
            pa = "pnpm add";
            y = "yarn";
            vim = "nvim";
            # Uses nh to manage generations https://github.com/nix-community/nh?tab=readme-ov-file#what-does-it-do
            fr = "nh darwin switch --hostname ${hostname} /Users/${username}/WebstormProjects/nix-config";
            fu = "nh darwin switch --hostname ${hostname} --update /Users/${username}/WebstormProjects/nix-config";
          };
        };

        yazi = {
          enable = true;
          settings = {
            yazi = {
              ratio = [
                1
                4
                3
              ];
              sort_by = "natural";
              sort_sensitive = true;
              sort_reverse = false;
              sort_dir_first = true;
              linemode = "none";
              show_hidden = true;
              show_symlink = true;
            };

            preview = {
              image_filter = "lanczos3";
              image_quality = 90;
              tab_size = 1;
              max_width = 600;
              max_height = 900;
              cache_dir = "";
              ueberzug_scale = 1;
              ueberzug_offset = [
                0
                0
                0
                0
              ];
            };

            tasks = {
              micro_workers = 5;
              macro_workers = 10;
              bizarre_retry = 5;
            };
          };
        };

        scmpuff = {
          enable = true;
          enableAliases = true;
          enableZshIntegration = true;
        };

        mcp = {
          servers = {
            linear = {
              type = "remote";
              url = "https://mcp.linear.app/mcp";
              enabled = true;
            };
            github = {
              type = "remote";
              url = "https://api.githubcopilot.com/mcp/";
              enabled = true;
              oauth = false;
              headers = {
                Authorization = "Bearer {env:GITHUB_PAT_TOKEN}";
              };
            };
            "datadog-mcp" = {
              type = "remote";
              url = "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp";
              enabled = true;
            };
          };
        };

        opencode = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            model = "gpt-5.4";
          };
        };

        tmux = {
          enable = true;
          shell = "${pkgs.zsh}/bin/zsh";
          historyLimit = 1000000;
          newSession = true;
          terminal = "screen-256color";
          keyMode = "vi";
          mouse = true;
          baseIndex = 1;
          focusEvents = true;
          disableConfirmationPrompt = true;
          prefix = "C-Space";
          aggressiveResize = true;
          escapeTime = 0;
          extraConfig = ''
                     set-window-option -g pane-base-index 1

                     # truecolor (RGB) support with tmux-256color
                     set -ga terminal-overrides ",tmux-256color:RGB"

                     # keybindings
                     bind-key -T copy-mode-vi v send-keys -X begin-selection
                     bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                     bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

                     bind - split-window -v -c "#{pane_current_path}"
                     bind | split-window -h -c "#{pane_current_path}"

                     bind h select-pane -L
                     bind j select-pane -D
                     bind k select-pane -U
                     bind l select-pane -R

                     # reload tmux configuration
                     bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux config reloaded"

                  # renumber when window is closed
                  set -g renumber-windows on
                  # set left and right status bar
                  set -g allow-rename on
                  set -g automatic-rename on
                  # Show path when idle in a shell; otherwise show the active command.
                  set -g automatic-rename-format "#{?#{m:^(zsh|bash|fish|nu)$,#{pane_current_command}},#{b:pane_current_path},#{pane_current_command}}"
                  set -g status-position bottom
                  set -g status-interval 5
                  set -g status-left-length 100
                  set -g status-right-length 100
                  set -g set-clipboard on

                  # For Yazi image previews (allow passthrough)
            set -g allow-passthrough on
            set -ga update-environment TERM
            set -ga update-environment TERM_PROGRAM
          '';

          plugins = with pkgs; [
            # Catppuccin with its options grouped here
            {
              plugin = tmuxPlugins.catppuccin;
              extraConfig = ''
                set -g @catppuccin_flavor 'mocha'
                set -g @catppuccin_window_status_style 'rounded'
                set -g @catppuccin_window_number_position 'right'
                set -g @catppuccin_window_status 'no'
                set -g @catppuccin_window_current_text " #{window_name}"
                set -g @catppuccin_window_default_text " #{window_name}"
                set -g @catppuccin_window_text " #{window_name}"
                set -g @catppuccin_window_current_fill 'number'
                set -g @catppuccin_window_current_color '#{E:@thm_surface_2}'
                set -g @catppuccin_date_time_text '%d.%m. %H:%M'
                set -g @catppuccin_status_module_text_bg '#{E:@thm_mantle}'
                set -g status-left '#{E:@catppuccin_status_session} '
                set -gF status-right '#{E:@catppuccin_status_primary_ip}'
                set -agF status-right '#{E:@catppuccin_status_ctp_cpu}'
                set -agF status-right '#{E:@catppuccin_status_ctp_memory}'
                set -ag status-right '#{E:@catppuccin_status_date_time}'
              '';
            }
            {
              plugin = tmuxPlugins.continuum;
              extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-boot 'on'
                set -g @continuum-save-interval '10'
              '';
            }
            tmuxPlugins.better-mouse-mode
            tmuxPlugins.yank
            tmuxPlugins.open
            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.copycat
          ];
        };

        git = {
          enable = true;
          ignores = ["*.swp"];
          lfs = {
            enable = true;
          };
          settings = {
            user = {
              name = username;
              email = userEmail;
            };
            init.defaultBranch = "main";
            core = {
              editor = "vim";
              autocrlf = "input";
            };
            commit.gpgsign = false;
            pull.rebase = false;
          };
        };

        nixvim = {
          enable = true;
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
              nodePackages.typescript-language-server
              nodePackages.typescript
              vscode-langservers-extracted
              pyright
              lua-language-server
              zls
              marksman
              multimarkdown
              clang-tools
              prettierd
              nodePackages.prettier
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

        ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks."*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
          includes = [
            (
              lib.mkIf pkgs.stdenv.hostPlatform.isLinux
              "~/.ssh/config_external"
            )
            (
              lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
              "~/.ssh/config_external"
            )
          ];
          matchBlocks = {
            "github.com" = {
              identitiesOnly = true;
              identityFile = [
                "~/.ssh/github_id"
                "~/.ssh/comun_github_id"
              ];
            };
          };
        };
      };
    };
    backupFileExtension = "backup";
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    {path = "/Applications/Slack.app/";}
    {path = "/Applications/1Password.app/";}
    {path = "/Applications/Messages.app/";}
    {path = "/Applications/Facetime.app/";}
    {path = "/Applications/iTerm.app/";}
    {path = "/Applications/Notes.app/";}
    {path = "/Applications/WhatsApp.app/";}
    {path = "/Applications/Obsidian.app/";}
    {path = "/Applications/Notion.app/";}
    {path = "/Applications/Notion\ Calendar.app/";}
    {path = "/Users/mitramejia/Applications/WebStorm.app";}
    {path = "/Users/mitramejia/Applications/Android\ Studio.app/";}
    {path = "/Applications/Music.app/";}
    {path = "/Applications/Linear.app/";}
    {path = "/Applications/Arc.app/";}
    {path = "/Applications/iPhone\ Mirroring.app/";}
    {path = "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/";}
    {
      path = "/Applications";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = "${config.users.users.${username}.home}/Downloads";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = "${config.users.users.${username}.home}/Desktop";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
  ];
}
