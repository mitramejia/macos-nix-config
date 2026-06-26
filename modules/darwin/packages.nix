{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
  headroomAi = pkgs.callPackage ../../packages/headroom-ai.nix {};
in
  shared-packages
  ++ [
    dockutil
    cocoapods
    # Backend dependencies for Comun
    poetry
    gnupg
    postgresql
    openssl
    readline
    sqlite
    xz
    zlib
    idb-companion
    headroomAi
  ]
