{pkgs, ...}:
with pkgs; [
  # Development environments and IDEs
  devenv
  nil

  # Build tools and compilers
  gcc
  jdk17

  # Package managers and development tools
  actionlint
  android-tools
  uv
  zoxide
  telegram-desktop

  # Cloud and Infrastructure tools
  docker-compose
  doppler
  flyctl
  go
  gopls
  ngrok
  ssm-session-manager-plugin
  terraform
  terraform-ls
  tflint

  # Version Control and Source Management
  gh
  git-filter-repo

  # Security and Encryption
  _1password-cli
  age
  gnupg
  libfido2
  sops

  # System utilities
  alejandra
  btop
  coreutils
  dust
  eza
  htop
  iftop
  just
  killall
  neofetch
  nh
  tmux
  tree
  wget
  sapling
  lazygit

  # Text processing and search
  act
  aspell
  aspellDicts.en
  bat
  difftastic
  fd
  fzf
  glow
  hunspell
  jq
  pandoc
  ripgrep
  nixd
  # Media processing

  ffmpeg
  imagemagick
  jpegoptim
  pngquant

  # Fonts and UI
  font-awesome
  nerd-fonts.jetbrains-mono

  # Archive management
  unrar
  unzip
  zip

  # Programming languages and runtimes
  python311
  python3Packages.virtualenv
  ruby

  # Databases
  sqlite

  # Mobile Development
  fastlane

  # Network tools
  openssh

  # Code formatting
  black
]
