{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    dockutil
    cocoapods
    # Backend dependencies for Comun
    pyenv
    poetry
    gnupg
    postgresql
    openssl
    readline
    sqlite
    xz
    zlib
  ]
