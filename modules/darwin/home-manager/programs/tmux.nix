{pkgs, ...}: {
  programs.tmux = {
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
          set -g @catppuccin_status_module_text_bg '#{E:@thm_mantle}'
          set -g status-left '#{E:@catppuccin_status_session} '
          set -gF status-right '#{E:@catppuccin_status_primary_ip}'
          set -agF status-right '#{E:@catppuccin_status_ctp_cpu}'
          set -agF status-right '#{E:@catppuccin_status_ctp_memory}'
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
}
