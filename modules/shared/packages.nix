{pkgs, ...}:
with pkgs; [
  devenv

  # General packages for development and system management
  act
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  difftastic
  du-dust
  gcc
  git-filter-repo
  killall
  neofetch
  openssh
  pandoc
  sqlite
  ruby
  pnpm
  wget
  zip
  nil
  neovim
  lunarvim
  alejandra
  android-tools
  openjdk
  just
  actionlint

  # Encryption and security tools
  _1password-cli
  age
  gnupg
  libfido2
  sops

  # Cloud-related tools and SDKs
  docker
  docker-compose
  flyctl

  go
  gopls
  ngrok
  ssm-session-manager-plugin
  terraform
  terraform-ls
  tflint

  # Media-related packages
  imagemagick
  ffmpeg
  fd
  font-awesome
  glow
  jpegoptim
  pngquant

  # Node.js development tools
  fzf
  nodePackages.live-server
  nodePackages.nodemon
  nodePackages.eas-cli
  nodePackages.jsonlint # Linter for github workflow configuration files, ie: .env-cmdrc.json

  # Source code management, Git, GitHub tools
  gh

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip

  # Python packages
  black
  python39
  python39Packages.virtualenv
]
