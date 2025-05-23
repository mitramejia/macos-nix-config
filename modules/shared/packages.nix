{pkgs, ...}:
with pkgs; [
  # Development environments and IDEs
  devenv
  lunarvim
  neovim
  nil

  # Build tools and compilers
  gcc
  jdk17

  # Package managers and development tools
  actionlint
  android-tools
  pnpm

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
  du-dust
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
  python3
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
