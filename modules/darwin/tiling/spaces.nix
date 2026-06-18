{
  config,
  lib,
  ...
}: let
  user = config.system.primaryUser;

  # Shared with skhd.nix so native desktop shortcuts and skhd bindings agree.
  desktops = import ./desktops.nix;

  # "Switch to Desktop N" symbolic-hotkey id is 117 + N, bound to Ctrl+N.
  # `-dict-add` MERGES the single id into AppleSymbolicHotKeys without replacing the
  # whole dictionary, so other customized shortcuts are left untouched. Using `defaults`
  # (not PlistBuddy) keeps cfprefsd's cache in sync.
  mkCmd = desktop: let
    id = toString desktop.hotKeyId;
    ascii = toString desktop.ascii;
    kc = toString desktop.keyCode;
  in "sudo -u ${user} defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${id} '{enabled=1;value={type=standard;parameters=(${ascii},${kc},262144);};}'";

  cmds = lib.concatStringsSep "\n" (map mkCmd desktops);
in {
  # Enables native "Switch to Desktop 1..9" (Ctrl+1..9) so skhd can bridge to it.
  # Takes effect after a logout; needs >=9 Spaces to exist.
  # Remove this from default.nix's imports if you only want Ctrl+Alt+arrows navigation.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "[tiling] enabling 'Switch to Desktop 1..9' (Ctrl+1..9) for ${user}" >&2
    ${cmds}
    sudo -u ${user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
  '';
}
