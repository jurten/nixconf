{pkgs, inputs, ...}: let
  colorscripts = pkgs.callPackage ../../pkgs/colorscripts.nix {};
  addons = inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons;
in {
  imports = [../../modules/home-manager];

  home.username = "jurten";
  home.homeDirectory = "/home/jurten";
  home.stateVersion = "24.05";

  # Needed here too — HM evaluates packages in its own nixpkgs instance
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Editors & IDEs
    # neovim is managed by programs.neovim in modules/home-manager/nvim.nix
    vscode-fhs # VSCode with FHS compatibility (extensions work via nix-ld)
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
    nmap

    # Communication & productivity
    discord
    slack
    teams-for-linux
    obsidian # knowledge base / notes
    libreoffice-qt6-still

    # Media
    mpv # video player
    gimp # image editor
    zathura # PDF/PS/DjVu/CB viewer (mupdf backend)
    glow # markdown CLI viewer/pager

    # Python dev stack (works with direnv: add a flake.nix/shell.nix per project)
    python3
    python3Packages.pip
    poetry
    uv # fast Python package manager; provides `uvx` for running MCP servers

    # Hyprland ecosystem (user-level tools)
    hyprlock # lockscreen (config in modules/home-manager/hyprland.nix)
    mako # notification daemon
    fuzzel # keyboard-driven app launcher
    pavucontrol # volume control GUI (opens floating per window rules)

    # Star Wars terminal art
    colorscripts

    # Remote desktop
    remmina # GUI RDP/VNC client
    freerdp # RDP backend for remmina

    # Utilities
    openfortivpn # Fortinet VPN
    unetbootin # bootable USB creator
    google-chrome
    claude-code
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

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      path = "lq6omp2i.default";
      isDefault = true;
      settings = {
        "browser.tabs.inTitlebar" = 0;
      };
      extensions.packages = with addons; [
        ublock-origin
        vimium
        darkreader
        sponsorblock
        tree-style-tab
        web-clipper-obsidian
      ];
    };
  };
}
