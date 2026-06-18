{
  username,
  userEmail,
  hostname,
  inputs,
  ...
}: {
  imports = [
    ./dock.nix
    ./homebrew.nix
    ./user.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    users.${username}.imports = [
      inputs.nixvim.homeModules.nixvim
      ./programs/agents.nix
      (import ./programs/git.nix {inherit userEmail username;})
      ./programs/home.nix
      ./programs/nixvim.nix
      (import ./programs/shell.nix {inherit hostname username;})
      ./programs/ssh.nix
      ./programs/terminal.nix
      ./programs/tmux.nix
    ];
    backupFileExtension = "backup";
  };
}
