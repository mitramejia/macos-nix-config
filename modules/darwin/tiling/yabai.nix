_: {
  # Mirrors modules/home/hyprland/settings.nix + window-rules.nix.
  # SIP stays enabled, so the scripting addition is off; space-assignment rules and
  # move-window-to-space are unavailable (see the plan's "known gaps").
  services.yabai = {
    enable = true;
    enableScriptingAddition = false; # SIP on

    config = {
      layout = "bsp"; # ~ Hyprland dwindle
      window_gap = 6; # gaps_in
      top_padding = 8; # gaps_out
      bottom_padding = 8;
      left_padding = 8;
      right_padding = 8;
      split_ratio = 0.50; # master mfact = 0.5
      window_placement = "second_child";
      focus_follows_mouse = "autofocus"; # follow_mouse = 1
      mouse_follows_focus = "off"; # no_warps = true
      mouse_modifier = "alt"; # Super+drag -> Alt+drag
      mouse_action1 = "move"; # bindm mouse:272 movewindow
      mouse_action2 = "resize"; # bindm mouse:273 resizewindow
      mouse_drop_action = "swap";
    };

    # Float rules: macOS equivalents of the Hyprland "float on" rules. The Linux app
    # classes don't exist here, so this is a sensible starter set; extend as needed.
    extraConfig = ''
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off
      yabai -m rule --add app="^Finder$" title="^(Copy|Move|Info|Get Info|Connect)" manage=off
      yabai -m rule --add title="^Picture-in-Picture$" manage=off
    '';
  };
}
