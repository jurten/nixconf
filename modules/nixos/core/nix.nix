{ pkgs, ... }: {
  # Nix experimental features (flakes + new CLI)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages at the system level
  nixpkgs.config.allowUnfree = true;

  # Nix LSP, formatter, linter and helpers for editor integration
  environment.systemPackages = with pkgs; [
    nil        # lightweight Nix LSP (fast, good for most editors)
    nixd       # feature-rich Nix LSP (supports nixpkgs option completion)
    alejandra  # opinionated Nix formatter
    statix     # Nix linter (catches antipatterns)
    manix      # offline Nix documentation search
    comma      # run any package without installing: , some-tool
    net-tools  # ifconfig, netstat, route
  ];

  networking.firewall.enable = true;  # ufw-equivalent; NixOS uses nftables/iptables directly

  # Lets unpatched ELF binaries run on NixOS — needed for:
  # - VSCode extensions that ship pre-compiled binaries
  # - pip-installed tools with native extensions
  # - poetry environments with C extensions
  programs.nix-ld.enable = true;

  # Per-project dev environments that activate automatically on cd
  # Works with python/poetry: add a shell.nix or flake.nix and it just works
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # caches nix-shell envs so they don't rebuild every time
  };
}
