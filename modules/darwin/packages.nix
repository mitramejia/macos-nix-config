{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    dockutil
    cocoapods
    doppler
    fastlane
    nerd-fonts.jetbrains-mono
    gnupg
  ]
