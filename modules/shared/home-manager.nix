{
  pkgs,
  lib,
  ...
}: let
  #  TODO: Make it configurable, maybe use nix template
  name = "Mitra Mejia	";
  email = "mitra.mejia@gmail.com";
in {
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

  kitty = {
    enable = true;
    package = pkgs.kitty;
    shellIntegration.enableZshIntegration = true;
    settings = {
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      window_padding_width = 4;
      confirm_os_window_close = 0;
    };
    themeFile = "Catppuccin-Mocha";
    extraConfig = ''
      tab_bar_style fade
      tab_fade 1
      font_size 12.0
      active_tab_font_style   bold
      inactive_tab_font_style bold
    '';
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
      plugins = ["node" "git" "aws" "z" "vi-mode" "aliases" "tmux"];
      theme = ""; # disable theme to allow nix/home-manager starship to control prompt
      extraConfig = ''
        ZSH_TMUX_AUTOSTART=true
      '';
    };
    initExtraFirst = ''
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


      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"


      # Vim is my editor
      export ALTERNATE_EDITOR=""
      export EDITOR="vim"

    '';
    initExtra = ''
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
      gash = "git stash";
      gasha = "git stash apply";
      gplo = "git pull origin";
      open-pr = "gh pr create";
      p = "pnpm";
      vim = "lvim";
    };
  };

  tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 1000000;
    terminal = "tmux-256color";
    keyMode = "vi";
    newSession = true;
    mouse = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    prefix = "C-Space";
    extraConfig = ''
      set -gu default-command
      set -g default-shell "$SHELL"
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1

      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      unbind -
      unbind |

      bind-key - split-window -v -c "#{pane_current_path}"
      bind-key | split-window -h -c "#{pane_current_path}"

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
    '';

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time "%H:%M"
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
    ];
  };

  git = {
    enable = true;
    ignores = ["*.swp"];
    userName = name;
    userEmail = email;
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
          (
            lib.mkIf pkgs.stdenv.hostPlatform.isLinux
            "~/.ssh/github_id"
          )
          (
            lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
            "~/.ssh/github_id"
          )
        ];
      };
    };
  };
}
