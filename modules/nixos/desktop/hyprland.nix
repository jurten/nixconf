{ pkgs, ... }: {
  # Hyprland: dynamic tiling Wayland compositor
  # Installs the binary, sets up PAM rules, polkit, logind session
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # compatibility for X11 apps (Discord, Chrome, etc.)
  };

  # Note: xdg.portal is handled automatically by programs.hyprland.enable (NixOS 24.11+)
  # Do not set extraPortals here — it conflicts with the auto-configured portal setup.

  # System-level tools needed for the rice setup
  environment.systemPackages = with pkgs; [
    grim         # Wayland screenshot tool
    slurp        # select screen region (used with grim)
    wl-clipboard # wl-copy / wl-paste (clipboard for Wayland)
    brightnessctl  # backlight control (keyboard brightness keys)
    hyprpaper    # wallpaper daemon (managed via services.hyprpaper)
    wlogout      # Wayland power menu (SUPER+SHIFT+Escape)
    papirus-icon-theme  # icon theme for app launchers (fuzzel, etc.)
  ];
}
