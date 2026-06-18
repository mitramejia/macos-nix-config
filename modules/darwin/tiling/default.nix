{...}: {
  # yabai (tiling) + skhd (hotkeys) + JankyBorders (focus outline), translated from
  # the Hyprland setup in ../../../nixos-config/modules/home/hyprland. Split mirrors
  # that module's layout: binds / settings / rules in dedicated files.
  imports = [
    ./yabai.nix
    ./skhd.nix
    ./borders.nix
    ./spaces.nix
  ];
}
