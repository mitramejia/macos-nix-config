{
  pkgs,
  lib,
  ...
}: {
  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      includes = [
        (
          lib.mkIf pkgs.stdenv.hostPlatform.isLinux
          "~/.ssh/config_external"
        )
        (
          lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
          "~/.ssh/config_external"
        )
      ];
      matchBlocks = {
        "github.com" = {
          identitiesOnly = true;
          identityFile = [
            "~/.ssh/github_id"
            "~/.ssh/comun_github_id"
          ];
        };
      };
    };
  };
}
