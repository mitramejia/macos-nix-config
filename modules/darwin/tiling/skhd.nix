{
  config,
  lib,
  pkgs,
  ...
}: let
  # Shared with spaces.nix so native desktop shortcuts and skhd bindings agree.
  desktops = import ./desktops.nix;

  # Primary user — owns the skhd launchd agent we bounce on activation.
  user = config.system.primaryUser;

  # Main modifier, mirroring Hyprland's `$modifier`. Super -> Ctrl+Alt+Cmd.
  # Change this one line to re-base every binding below.
  mod = "ctrl + alt + cmd";

  moveToSpace = pkgs.callPackage ./move-to-space.nix {};

  # mod+N -> switch to Desktop N. skhd posts the native Ctrl+N itself via `skhd -k`,
  # reusing skhd's own Accessibility grant. (osascript/System Events needs *Automation*
  # consent, which a background launchd agent can't be prompted for, so it silently
  # fails from skhd.) Needs spaces.nix (enables the Ctrl+1..9 shortcuts) and >=N Spaces.
  spaceBindings =
    lib.concatMapStrings (
      desktop: "${mod} - ${toString desktop.number} : ${pkgs.skhd}/bin/skhd -k \"ctrl - ${toString desktop.number}\"\n"
    )
    desktops;

  # shift+mod+N -> move the focused window to space N via the SIP-safe helper.
  moveBindings =
    lib.concatMapStrings (
      desktop: "shift + ${mod} - ${toString desktop.number} : ${moveToSpace}/bin/yabai-move-to-space ${toString desktop.keyCode}\n"
    )
    desktops;
in {
  # Mirrors the window-management subset of modules/home/hyprland/binds.nix.
  # Modifier: Super -> Cmd+Alt. App launchers / media keys are intentionally omitted.
  services.skhd.enable = true;
  services.skhd.skhdConfig =
    ''
      # --- Focus (Super -> Cmd+Alt; h/j/k/l + arrows) ---
      ${mod} - h : yabai -m window --focus west
      ${mod} - j : yabai -m window --focus south
      ${mod} - k : yabai -m window --focus north
      ${mod} - l : yabai -m window --focus east
      ${mod} - left  : yabai -m window --focus west
      ${mod} - right : yabai -m window --focus east

      # --- Move / warp window within the layout (Super+Shift -> Shift+Cmd+Alt; h/j/k/l + arrows) ---
      shift + ${mod} - h : yabai -m window --warp west
      shift + ${mod} - j : yabai -m window --warp south
      shift + ${mod} - k : yabai -m window --warp north
      shift + ${mod} - l : yabai -m window --warp east
      shift + ${mod} - left  : yabai -m window --warp west
      shift + ${mod} - right : yabai -m window --warp east
      shift + ${mod} - up    : yabai -m window --warp north
      shift + ${mod} - down  : yabai -m window --warp south

      # --- Window state ---
      ${mod} - q : yabai -m window --close
      ${mod} - f : yabai -m window --toggle zoom-fullscreen
      shift + ${mod} - f : yabai -m window --toggle float --grid 4:4:1:1:2:2
      shift + ${mod} - i : yabai -m window --toggle split

      # --- Reload window manager (Super+Shift+R analogue) ---
      shift + ${mod} - r : yabai --restart-service; skhd --restart-service

      # --- Adjacent space navigation: use the native Ctrl+left/right directly. ---
      #     A dedicated Super+Ctrl+arrow bind can't exist now because Ctrl is part
      #     of Super, so it would collide with focus left/right.

      # --- Direct space jump 1..9 (Super+1..9 analogue) ---
    ''
    + spaceBindings
    + ''

      # --- Move focused window to space 1..9 (Super+Shift+1..9; Swift drag hack, SIP-on) ---
    ''
    + moveBindings;

  # skhd's hot-reloader watches the resolved (immutable) /nix/store config path,
  # so it never picks up changes across `fr`. Bounce the launchd agent on every
  # activation so edits to skhdConfig take effect without a manual restart.
  # (`skhd --restart-service` would target com.koekeishiya.skhd, not org.nixos.skhd.)
  system.activationScripts.postActivation.text = lib.mkAfter ''
    launchctl kickstart -k "gui/$(id -u ${user})/org.nixos.skhd" >/dev/null 2>&1 || true
  '';
}
