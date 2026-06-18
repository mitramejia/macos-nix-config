{
  username,
  userEmail,
}: {...}: {
  programs.git = {
    enable = true;
    ignores = ["*.swp"];
    lfs = {
      enable = true;
    };
    settings = {
      user = {
        name = username;
        email = userEmail;
      };
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      commit.gpgsign = false;
      pull.rebase = false;
    };
  };
}
