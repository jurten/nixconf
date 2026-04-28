{pkgs, ...}: {
  imports = [../../modules/home-manager];

  home.username = "jurten";
  home.homeDirectory = "/home/jurten";
  home.stateVersion = "24.05";

  # Needed here too — HM evaluates packages in its own nixpkgs instance
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Editors & IDEs
    # neovim is managed by programs.neovim in modules/home-manager/nvim.nix
    kdePackages.kate # KDE text editor

    # Terminal & shell tools
    # kitty is managed by programs.kitty in modules/home-manager/kitty.nix
    wget
    fastfetch # system info on shell start
    htop
    tldr # simplified man pages
    zip
    p7zip
    lzip
    git
    gh # GitHub CLI
    dig
    grex # generate regex from examples

    # Communication & productivity
    discord
    obsidian # knowledge base / notes
    libreoffice-qt6-still

    # Media
    mpv # video player
    gimp # image editor

    # Python dev stack (works with direnv: add a flake.nix/shell.nix per project)
    python3
    python3Packages.pip

    # Hyprland ecosystem (user-level tools)
    hyprlock # lockscreen (config in modules/home-manager/hyprland.nix)
    mako # notification daemon
    fuzzel # keyboard-driven app launcher
    pavucontrol # volume control GUI (opens floating per window rules)

    # Utilities
    unetbootin # bootable USB creator
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/slack" = "slack.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "text/html" = "firefox.desktop";
    };
  };

  # Let Home Manager manage itself (enables `home-manager` CLI for the user)
  programs.home-manager.enable = true;
}
