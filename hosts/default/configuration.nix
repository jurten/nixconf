{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 16GB swapfile
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  # Hostname — changed from generic "nixos" to something identifiable
  networking.hostName = "jurten-desktop";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "America/Argentina/Buenos_Aires";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT    = "es_AR.UTF-8";
    LC_MONETARY       = "es_AR.UTF-8";
    LC_NAME           = "es_AR.UTF-8";
    LC_NUMERIC        = "es_AR.UTF-8";
    LC_PAPER          = "es_AR.UTF-8";
    LC_TELEPHONE      = "es_AR.UTF-8";
    LC_TIME           = "es_AR.UTF-8";
  };

  # Main user — defined via the reusable module in modules/nixos/main-user.nix
  main-user.enable = true;
  main-user.userName = "jurten";
  main-user.description = "Jurten";

  # Home Manager — activated and pointed at home.nix
  # All user packages and dotfiles are managed from there
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."jurten" = import ./home.nix;
  };

  # Firefox managed at system level (integrates with KDE, gets system updates)
  programs.firefox.enable = true;

  # Minimal system-level packages (only what needs to be available before login)
  environment.systemPackages = with pkgs; [
    vim
  ];

  # SSH server
  services.openssh.enable = true;

  # Keep at original install version — do not change
  system.stateVersion = "24.05";
}
