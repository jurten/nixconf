{ pkgs, ... }: {
  # X11 + KDE Plasma 6 with SDDM
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;  # needed to launch Hyprland Wayland session
  services.desktopManager.plasma6.enable = true;

  # Keyboard layout:
  # - "us" with variant "intl" = English International — gives dead keys for
  #   Spanish: type ' then a → á, ~ then n → ñ, etc.
  # - "jp" as second layout for direct Japanese kana input
  # - Alt+Shift toggles between layouts
  # For actual Japanese text input (romaji→kanji), use fcitx5-mozc below
  services.xserver.xkb = {
    layout = "us,jp";
    variant = "intl,";
    options = "grp:alt_shift_toggle";
  };

  # Japanese input method via fcitx5 + Mozc
  # Switch with Ctrl+Space inside fcitx5; handles romaji→hiragana→kanji conversion
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc  # Google's Japanese IME engine (best quality)
      fcitx5-gtk   # GTK integration (needed for non-Qt apps like Chrome)
    ];
  };

  # XDG portal — base setup; hyprland.nix adds its own portal on top
  xdg.portal.enable = true;

  # Fonts: monospace for terminal/editor, CJK for Japanese text rendering
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono  # monospace with icons (for neovim/kitty)
    noto-fonts                  # broad unicode coverage
    noto-fonts-cjk-sans         # Japanese / Chinese / Korean characters
    noto-fonts-color-emoji      # emoji
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "Noto Sans" ];
  };

  # Load firmware for all detected hardware (WiFi cards, Bluetooth adapters, etc.)
  # Requires allowUnfree = true (set in core/nix.nix)
  hardware.enableAllFirmware = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Printing via CUPS
  services.printing.enable = true;

  # Flatpak — sandboxed app distribution
  services.flatpak.enable = true;
}
