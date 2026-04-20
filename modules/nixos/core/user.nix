{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in

{
  options.main-user = {
    enable = lib.mkEnableOption "enable main-user module";

    userName = lib.mkOption {
      default = "username";
      description = "The main user's login name";
    };

    description = lib.mkOption {
      default = "main user";
      description = "The main user's display name (shown on login screen)";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = cfg.description;
      initialPassword = "default";  # change with passwd after first boot
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };
}
