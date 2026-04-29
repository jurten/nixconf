{pkgs, ...}: {
  # Nix experimental features (flakes + new CLI)
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Binary caches — pull prebuilt binaries, avoid compiling from source
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBs="
  ];
  nix.settings.trusted-users = [ "root" "jurten" ];

  # Allow unfree packages at the system level
  nixpkgs.config.allowUnfree = true;

  # Nix LSP, formatter, linter and helpers for editor integration
  environment.systemPackages = with pkgs; [
    nil # lightweight Nix LSP (fast, good for most editors)
    nixd # feature-rich Nix LSP (supports nixpkgs option completion)
    alejandra # opinionated Nix formatter
    statix # Nix linter (catches antipatterns)
    manix # offline Nix documentation search
    comma # run any package without installing: , some-tool
    net-tools # ifconfig, netstat, route
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [5173 5174];
  }; #ufw-equivalent; NixOS uses nftables/iptables directly

  # Lets unpatched ELF binaries run on NixOS — needed for:
  # - VSCode extensions that ship pre-compiled binaries
  # - pip-installed tools with native extensions
  # - poetry environments with C extensions
  programs.nix-ld.enable = true;

  # Per-project dev environments that activate automatically on cd
  # Works with python/poetry: add a shell.nix or flake.nix and it just works
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # caches nix-shell envs so they don't rebuild every time
  };
}
