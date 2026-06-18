_: {
  # Visual stand-in for Hyprland's `col.active_border` gradient (border_size = 2).
  # yabai dropped built-in borders, so JankyBorders draws the focus outline.
  # Colors are Catppuccin Mocha (red -> teal), matching the terminal themes in
  # modules/darwin/home-manager.nix. Tune width/colors to taste.
  services.jankyborders = {
    enable = true;
    active_color = "gradient(top_left=0xfff38ba8,bottom_right=0xff94e2d5)";
    inactive_color = "0xff181825";
    width = 4.0;
    hidpi = true;
    style = "round"; # ~ decoration.rounding = 10
  };
}
