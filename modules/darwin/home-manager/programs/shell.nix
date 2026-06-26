{
  username,
  hostname,
}: {lib, ...}: {
  programs.zsh = {
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
      codex-oss = "codex -p gpt-oss-20b-lmstudio --oss";
      codex = "headroom wrap codex";
      # Uses nh to manage generations https://github.com/nix-community/nh?tab=readme-ov-file#what-does-it-do
      fr = "nh darwin switch --hostname ${hostname} /Users/${username}/WebstormProjects/nix-config";
      fu = "nh darwin switch --hostname ${hostname} --update /Users/${username}/WebstormProjects/nix-config";
    };
  };
}
