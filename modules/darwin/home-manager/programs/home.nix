{pkgs, ...}: {
  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ../../packages.nix {};
    stateVersion = "23.11";
  };
}
