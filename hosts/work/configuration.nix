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

  networking.hostName = "jurten-work";
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

  # Main user
  main-user.enable = true;
  main-user.userName = "jurten";
  main-user.description = "Jurten";

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."jurten" = import ./home.nix;
    backupFileExtension = "hm-backup";
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/jurten/nixos#work";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    dates = "weekly";
  };

  system.stateVersion = "24.05";
}
