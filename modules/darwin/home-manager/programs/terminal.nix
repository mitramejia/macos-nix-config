{pkgs, ...}: {
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
        theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
        font-family = "JetBrainsMono NFM Regular";
        font-size = 14.5;
        window-padding-x = 2;
        window-padding-y = 2;
        adjust-cell-height = 10;
        cursor-style = "block";
        cursor-style-blink = true;
        scrollback-limit = 200000;
        copy-on-select = false;
        link-url = true;
        clipboard-read = "allow";
        clipboard-write = "allow";
        mouse-hide-while-typing = true;
        shell-integration = "detect";
        image-storage-limit = 4294967295;
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
  };
}
