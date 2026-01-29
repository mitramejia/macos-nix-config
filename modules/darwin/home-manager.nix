{
  username,
  userEmail,
  hostname,
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
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        stateVersion = "23.11";
      };
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
            plugins = ["node" "git" "aws" "z" "vi-mode" "aliases" "tmux" "yarn" "nvm" "jenv" "macos"];
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

            export PATH="$PATH:/Users/mitramejia/.cache/lm-studio/bin"

            # Remove history data we don't want to see
            export HISTIGNORE="pwd:ls:cd"




            # Vim is my editor
            export ALTERNATE_EDITOR=""
            export EDITOR="vim"

              export PATH="$HOME/.jenv/bin:$PATH"
              eval "$(jenv init -)"

            [ -s "/Users/mitramejia/.scm_breeze/scm_breeze.sh" ] && source "/Users/mitramejia/.scm_breeze/scm_breeze.sh"
          '';
          shellAliases = {
            v = "lvim";
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
            vim = "lvim";
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
          userName = username;
          userEmail = userEmail;
          lfs = {
            enable = true;
          };
          extraConfig = {
            init.defaultBranch = "main";
            core = {
              editor = "vim";
              autocrlf = "input";
            };
            commit.gpgsign = false;
            pull.rebase = false;
          };
        };

        vim = {
          enable = true;
          plugins = with pkgs.vimPlugins; [vim-airline vim-airline-themes copilot-vim vim-startify vim-tmux-navigator];
          settings = {ignorecase = true;};
          extraConfig = ''
            "" General
            set number
            set history=1000
            set nocompatible
            set modelines=0
            set encoding=utf-8
            set scrolloff=3
            set showmode
            set showcmd
            set hidden
            set wildmenu
            set wildmode=list:longest
            set cursorline
            set ttyfast
            set nowrap
            set ruler
            set backspace=indent,eol,start
            set laststatus=2
            set clipboard=autoselect

            " Dir stuff
            set nobackup
            set nowritebackup
            set noswapfile
            set backupdir=~/.config/vim/backups
            set directory=~/.config/vim/swap

            " Relative line numbers for easy movement
            set relativenumber
            set rnu

            "" Whitespace rules
            set tabstop=8
            set shiftwidth=2
            set softtabstop=2
            set expandtab

            "" Searching
            set incsearch
            set gdefault

            "" Statusbar
            set nocompatible " Disable vi-compatibility
            set laststatus=2 " Always show the statusline
            let g:airline_theme='bubblegum'
            let g:airline_powerline_fonts = 1

            "" Local keys and such
            let mapleader=","
            let maplocalleader=" "

            "" Change cursor on mode
            :autocmd InsertEnter * set cul
            :autocmd InsertLeave * set nocul

            "" File-type highlighting and configuration
            syntax on
            filetype on
            filetype plugin on
            filetype indent on

            "" Paste from clipboard
            nnoremap <Leader>, "+gP

            "" Copy from clipboard
            xnoremap <Leader>. "+y

            "" Move cursor by display lines when wrapping
            nnoremap j gj
            nnoremap k gk

            "" Map leader-q to quit out of window
            nnoremap <leader>q :q<cr>

            "" Move around split
            nnoremap <C-h> <C-w>h
            nnoremap <C-j> <C-w>j
            nnoremap <C-k> <C-w>k
            nnoremap <C-l> <C-w>l

            "" Easier to yank entire line
            nnoremap Y y$

            "" Move buffers
            nnoremap <tab> :bnext<cr>
            nnoremap <S-tab> :bprev<cr>

            "" Like a boss, sudo AFTER opening the file to write
            cmap w!! w !sudo tee % >/dev/null

            let g:startify_lists = [
              \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
              \ { 'type': 'sessions',  'header': ['   Sessions']       },
              \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
              \ ]

            let g:startify_bookmarks = [
              \ '~/.local/share/src',
              \ ]

            let g:airline_theme='bubblegum'
            let g:airline_powerline_fonts = 1
          '';
        };

        ssh = {
          enable = true;
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
    {path = "/Applications/Iterm.app/";}
    {path = "/Applications/Notes.app/";}
    {path = "/Applications/WhatsApp.app/";}
    {path = "/Applications/Obsidian.app/";}
    {path = "/Applications/Notion.app/";}
    {path = "/Applications/Notion\ Calendar.app/";}
    {path = "/Users/mitramejia/Applications/WebStorm.app";}
    {path = "/Users/mitramejia/Applications/PyCharm.app";}
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
