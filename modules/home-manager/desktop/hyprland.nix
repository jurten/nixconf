{ pkgs, lib, ... }: {

  # ── Hyprland window manager ───────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;         # use system-provided hyprland (programs.hyprland.enable = true)
    portalPackage = null;   # use system-provided xdg-desktop-portal-hyprland
    extraConfig = ''
      # ── Monitors ─────────────────────────────────────────────────────────
      monitor = ,preferred,auto,1

      # ── Autostart ────────────────────────────────────────────────────────
      exec-once = hyprpaper
      exec-once = waybar
      exec-once = mako
      exec-once = /run/current-system/sw/libexec/polkit-kde-authentication-agent-1

      # ── Wayland env vars (needed for Chrome, Electron, SDL apps) ─────────
      env = XCURSOR_SIZE,24
      env = QT_QPA_PLATFORM,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = GDK_BACKEND,wayland,x11
      env = SDL_VIDEODRIVER,wayland
      env = MOZ_ENABLE_WAYLAND,1

      # ── Look & feel ───────────────────────────────────────────────────────
      general {
        gaps_in    = 5
        gaps_out   = 12
        border_size = 2
        col.active_border   = rgba(7aa2f7ee) rgba(bb9af7ee) 45deg
        col.inactive_border = rgba(292e42aa)
        layout = dwindle
        resize_on_border = true
      }

      decoration {
        rounding = 12
        active_opacity   = 1.0
        inactive_opacity = 0.92

        blur {
          enabled          = true
          size             = 6
          passes           = 3
          new_optimizations = true
          vibrancy         = 0.17
        }

        shadow {
          enabled      = true
          range        = 10
          render_power = 3
          color        = rgba(1a1a2eee)
        }
      }

      animations {
        enabled = true

        bezier = easeOutQuint,  0.23, 1,    0.32, 1
        bezier = almostLinear,  0.5,  0.5,  0.75, 1.0
        bezier = quick,         0.15, 0,    0.1,  1

        animation = windows,     1, 5, easeOutQuint
        animation = windowsIn,   1, 5, easeOutQuint, popin 87%
        animation = windowsOut,  1, 2, almostLinear, popin 87%
        animation = border,      1, 6, easeOutQuint
        animation = fade,        1, 3, quick
        animation = workspaces,  1, 4, almostLinear, slidefade 15%
        animation = layers,      1, 4, easeOutQuint
      }

      dwindle {
        pseudotile     = true
        preserve_split = true
      }

      misc {
        force_default_wallpaper  = 0
        disable_hyprland_logo    = true
        disable_splash_rendering = true
        mouse_move_enables_dpms  = true
      }

      # ── Input ─────────────────────────────────────────────────────────────
      input {
        kb_layout  = us,jp
        kb_variant = intl,
        kb_options = grp:alt_shift_toggle
        follow_mouse = 1
        sensitivity  = 0

        touchpad {
          natural_scroll = true
        }
      }

      gesture = 3, horizontal, workspace

      # ── Keybindings ───────────────────────────────────────────────────────
      $mod = SUPER

      # Core
      bind = $mod,       Return, exec,         kitty
      bind = $mod,       Q,      killactive,
      bind = $mod SHIFT, M,      exit,
      bind = $mod,       F,      fullscreen,
      bind = $mod,       V,      togglefloating,
      bind = $mod,       Space,  exec,          fuzzel
      bind = $mod,       Tab,    exec,          rofi -show window
      bind = $mod,       P,      pseudo,
      bind = $mod,       E,      togglesplit,
      bind = $mod,       L,      exec,          hyprlock
      bind = $mod SHIFT, Escape, exec,         wlogout
      bind = $mod,       I,      exec,          sh -c 'systemctl --user is-active --quiet hypridle.service && systemctl --user stop hypridle.service || systemctl --user start hypridle.service'

      # Cycle through windows in current workspace
      bind = $mod, j,    cyclenext,
      bind = $mod, k,    cyclenext, prev
      bind = $mod, down, cyclenext,
      bind = $mod, up,   cyclenext, prev

      # Move window to adjacent workspace
      bind = $mod SHIFT, k, movetoworkspace, e-1
      bind = $mod SHIFT, j, movetoworkspace, e+1

      # Workspaces 1-9
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9

      # Move window to workspace
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9

      # Scroll workspaces
      bind = $mod, mouse_down, workspace, e+1
      bind = $mod, mouse_up,   workspace, e-1

      # Screenshots
      bind = ,      Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +%s).png

      # Audio (wpctl from PipeWire)
      bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl  = , XF86AudioMute,        exec, wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle
      bindl  = , XF86AudioMicMute,     exec, wpctl set-mute   @DEFAULT_AUDIO_SOURCE@ toggle

      # Brightness
      bindel = , XF86MonBrightnessUp,   exec, brightnessctl set 5%+
      bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

      # Mouse fallback (still useful when you want it)
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow

      # ── Window rules ─────────────────────────────────────────────────────
      # Float small/utility windows
      windowrule {
        name = float-pavucontrol
        match:class = ^pavucontrol$
        float = true
      }
      windowrule {
        name = float-nm-connection-editor
        match:class = ^nm-connection-editor$
        float = true
      }
      windowrule {
        name = float-pip
        match:title = ^Picture-in-Picture$
        float = true
      }
      windowrule {
        name = float-polkit
        match:class = ^org.kde.polkit-kde-authentication-agent-1$
        float = true
      }

      # Fix Electron/Chrome apps on Wayland
      windowrule {
        name = opacity-obsidian
        match:class = ^obsidian$
        opacity = 0.95 0.85
      }
      windowrule {
        name = opacity-discord
        match:class = ^discord$
        opacity = 0.95 0.85
      }
    '';
  };

  # ── Waybar ────────────────────────────────────────────────────────────────
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 34;
      margin-top    = 6;
      margin-left   = 12;
      margin-right  = 12;
      spacing  = 4;

      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [ "custom/idle" "hyprland/language" "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs    = false;
        format         = "{icon}";
        format-icons = {
          "1" = "一"; "2" = "二"; "3" = "三";
          "4" = "四"; "5" = "五"; "6" = "六";
          "7" = "七"; "8" = "八"; "9" = "九";
          default = "·";
        };
        persistent-workspaces = {
          "*" = 5;
        };
      };

      clock = {
        format     = " {:%H:%M}";
        format-alt = " {:%A, %d %b %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        timezone   = "America/Argentina/Buenos_Aires";
      };

      cpu = {
        format   = " {usage}%";
        tooltip  = false;
        interval = 2;
      };

      memory = {
        format   = " {used:0.1f}G";
        interval = 5;
      };

      network = {
        format-wifi       = " {essid}";
        format-ethernet   = " connected";
        format-disconnected = "󰌙 disconnected";
        tooltip-format    = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format         = "{icon} {volume}%";
        format-muted   = "󰝟";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
      };

      battery = {
        format          = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons    = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        tooltip-format  = "{timeTo}";
        states = {
          warning  = 30;
          critical = 15;
        };
      };

      "hyprland/language" = {
        format = "󰌌 {}";
        format-en = "US";
        format-ja = "JP";
      };

      "custom/idle" = {
        exec        = "sh -c 'systemctl --user is-active --quiet hypridle.service && echo \"{\\\"text\\\":\\\"󰒲\\\",\\\"class\\\":\\\"active\\\"}\" || echo \"{\\\"text\\\":\\\"󰒳\\\",\\\"class\\\":\\\"inactive\\\"}\"'";
        return-type = "json";
        interval    = 3;
        format      = "{}";
        tooltip     = false;
      };

      tray = {
        spacing = 8;
      };
    }];

    # Tokyo Night theme
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      /* Bar itself: semi-transparent */
      window#waybar {
        background: rgba(26, 27, 38, 0.75);
        color: #c0caf5;
        border-radius: 14px;
        box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.3);
      }

      tooltip {
        background: rgba(26, 27, 38, 0.95);
        border: 1px solid rgba(122, 162, 247, 0.4);
        border-radius: 10px;
        color: #a9b1d6;
      }

      /* ── Workspaces ── */
      #workspaces {
        background: rgba(41, 46, 66, 0.8);
        border-radius: 50px;
        padding: 2px 6px;
        box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.3);
      }

      #workspaces button {
        color: #565f89;
        padding: 2px 10px;
        border-radius: 50px;
        transition: all 0.3s ease;
      }

      #workspaces button.active {
        color: #7aa2f7;
        background: rgba(122, 162, 247, 0.25);
        box-shadow: 0px 3px 8px rgba(122, 162, 247, 0.3);
        font-weight: bold;
      }

      #workspaces button.urgent {
        color: #f7768e;
        background: rgba(247, 118, 142, 0.25);
      }

      #workspaces button:hover {
        color: #c0caf5;
        background: rgba(169, 177, 214, 0.15);
        margin-top: -2px;
        margin-bottom: 2px;
      }

      /* ── Clock: standalone pill in center ── */
      #clock {
        color: #bb9af7;
        font-weight: bold;
        padding: 2px 16px;
        background: rgba(41, 46, 66, 0.8);
        border-radius: 50px;
        box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.3);
        margin: 4px 0;
      }

      /* ── Right modules: individual pills ── */
      #cpu, #memory, #network, #pulseaudio, #battery,
      #language, #custom-idle, #tray {
        background: rgba(41, 46, 66, 0.8);
        border-radius: 50px;
        padding: 2px 12px;
        margin: 4px 2px;
        box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
      }

      #cpu, #memory, #network, #pulseaudio, #battery,
      #language, #custom-idle, #tray:hover {
        background: rgba(55, 62, 90, 0.95);
        margin-top: 2px;
        margin-bottom: 6px;
      }

      #cpu        { color: #9ece6a; }
      #memory     { color: #7dcfff; }
      #network    { color: #7dcfff; }
      #pulseaudio { color: #e0af68; }
      #pulseaudio.muted { color: rgba(86, 95, 137, 0.7); }
      #battery    { color: #9ece6a; }
      #battery.warning  { color: #e0af68; }
      #battery.critical {
        color: #f7768e;
        box-shadow: 0px 5px 10px rgba(247, 118, 142, 0.3);
      }
      #battery.charging { color: #9ece6a; }
      #language   { color: #bb9af7; }
      #custom-idle        { color: rgba(86, 95, 137, 0.7); }
      #custom-idle.active { color: #e0af68; }
      #tray { padding: 2px 8px; }
    '';
  };

  # ── Mako (notifications) ─────────────────────────────────────────────────
  xdg.configFile."mako/config".text = ''
    background-color=#1a1b26dd
    text-color=#a9b1d6
    border-color=#7aa2f7
    border-size=2
    border-radius=10
    font=JetBrainsMono Nerd Font 11
    default-timeout=5000
    ignore-timeout=1
    markup=0
    format=%s\n%b
    width=360
    max-icon-size=48
    padding=12
    margin=6

    [urgency=high]
    border-color=#f7768e
    default-timeout=0
  '';

  # ── Fuzzel (app launcher) ─────────────────────────────────────────────────
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=12
    dpi-aware=yes
    prompt=
    terminal=kitty -e
    width=35
    lines=8
    letter-spacing=0
    icon-theme=Papirus

    [colors]
    background=1a1b26dd
    text=a9b1d6ff
    match=7aa2f7ff
    selection=292e42ff
    selection-text=a9b1d6ff
    selection-match=7aa2f7ff
    border=7aa2f799

    [border]
    width=2
    radius=10
  '';

  # ── Rofi (window switcher) ───────────────────────────────────────────────
  xdg.configFile."rofi/config.rasi".text = ''
    @theme "~/.config/rofi/themes/rounded-tokyo-night.rasi"
  '';

  xdg.configFile."rofi/themes/rounded-tokyo-night.rasi".text = ''
    * {
        bg0: #1a1b26F2;
        bg1: #1f2335;
        bg2: #292e4280;
        bg3: #7aa2f7F2;
        fg0: #a9b1d6;
        fg1: #c0caf5;
        fg2: #565f89;
        fg3: #292e42;

        font: "JetBrainsMono Nerd Font 12";
        background-color: transparent;
        text-color: @fg0;
        margin: 0px;
        padding: 0px;
        spacing: 0px;
    }

    window {
        location: center;
        width: 480;
        transparency: "screenshot";
        padding: 1px;
        border-radius: 10px;
    }

    mainbox {
        padding: 12px;
        border: 1px;
        border-color: #7aa2f7ee;
        background-color: #1a1b26ee;
        border-radius: 10px;
    }

    inputbar {
        background-color: #1f2335;
        border-color: #7aa2f788;
        border: 2px;
        border-radius: 8px;
        padding: 8px 16px;
        spacing: 8px;
        children: [ prompt, entry ];
    }

    prompt {
        text-color: @fg2;
    }

    entry {
        placeholder: "Search windows...";
        placeholder-color: #565f89;
        text-color: @fg1;
    }

    message {
        margin: 12px 0 0;
        border-radius: 8px;
        border-color: @bg2;
        background-color: @bg2;
    }

    textbox {
        padding: 8px 24px;
    }

    listview {
        background-color: transparent;
        margin: 12px 0 0;
        lines: 8;
        columns: 1;
        fixed-height: false;
    }

    element {
        padding: 8px 16px;
        spacing: 8px;
        border-radius: 8px;
    }

    element normal active {
        text-color: #7aa2f788;
    }

    element selected normal, element selected active {
        background-color: #7aa2f722;
        text-color: @fg1;
        border: 1px;
        border-color: #7aa2f788;
        border-radius: 8px;
    }

    element-icon {
        size: 1em;
        vertical-align: 0.5;
    }

    element-text {
        text-color: inherit;
    }
  '';

  # ── Hypridle (idle daemon) ─────────────────────────────────────────────────
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd    = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd           = "hyprlock";
      };

      listener = [
        {
          # dim after 4 min
          timeout    = 240;
          on-timeout = "brightnessctl -s set 20%";
          on-resume  = "brightnessctl -r";
        }
        {
          # lock 15 s after dimming
          timeout    = 255;
          on-timeout = "hyprlock";
        }
        {
          # screen off after 10 min
          timeout    = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume  = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Prevent hypridle from auto-starting — toggle it manually with Super+I
  systemd.user.services.hypridle.Install.WantedBy = lib.mkForce [];

  # ── Hyprlock (lockscreen) ─────────────────────────────────────────────────
  # ── Idle toggle script ────────────────────────────────────────────────────
  home.file.".local/bin/toggle-idle" = {
    executable = true;
    text = ''
      #!/bin/sh
      if systemctl --user is-active --quiet hypridle.service; then
        systemctl --user stop hypridle.service
      else
        systemctl --user start hypridle.service
      fi
    '';
  };

  # ── Wlogout (power menu) ──────────────────────────────────────────────────
  xdg.configFile."wlogout/layout".text = ''
    { "label": "lock",      "action": "hyprlock",                "text": "Lock",     "keybind": "l" }
    { "label": "suspend",   "action": "systemctl suspend",       "text": "Suspend",  "keybind": "u" }
    { "label": "logout",    "action": "hyprctl dispatch exit 0", "text": "Logout",   "keybind": "e" }
    { "label": "shutdown",  "action": "systemctl poweroff",      "text": "Shutdown", "keybind": "s" }
    { "label": "reboot",    "action": "systemctl reboot",        "text": "Reboot",   "keybind": "r" }
    { "label": "hibernate", "action": "systemctl hibernate",     "text": "Hibernate","keybind": "h" }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
    }

    window {
      background: rgba(26, 27, 38, 0.92);
    }

    button {
      color: #a9b1d6;
      background: rgba(41, 46, 66, 0.85);
      border: 1px solid rgba(122, 162, 247, 0.15);
      border-radius: 12px;
      margin: 8px;
      padding: 20px 40px;
      font-size: 16px;
      transition: all 0.2s ease;
    }

    button:hover {
      background: rgba(122, 162, 247, 0.2);
      border-color: #7aa2f7;
      color: #c0caf5;
    }

    #lock    { color: #7aa2f7; }
    #suspend { color: #7dcfff; }
    #logout  { color: #e0af68; }
    #shutdown { color: #f7768e; }
    #reboot  { color: #ff9e64; }
    #hibernate { color: #bb9af7; }
  '';

  # ── Hyprpaper (wallpaper) ────────────────────────────────────────────────
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${./wallpapers/lovelytics.webp}" ];
      splash  = false;
      wallpaper = [
        {
          monitor  = "eDP-1";
          path     = "${./wallpapers/lovelytics.webp}";
          fit_mode = "cover";
        }
      ];
    };
  };

  # ── Hyprlock (lockscreen) ─────────────────────────────────────────────────
  xdg.configFile."hypr/hyprlock.conf".text = ''
    background {
      monitor =
      path = ${./wallpapers/lovelytics.webp}
      blur_passes = 3
      blur_size   = 8
    }

    input-field {
      monitor =
      size = 280, 50
      outline_thickness = 2
      dots_size    = 0.3
      dots_spacing = 0.2
      dots_center  = true
      outer_color  = rgb(7aa2f7)
      inner_color  = rgb(26, 27, 38)
      font_color   = rgb(169, 177, 214)
      fade_on_empty = true
      placeholder_text = <i>password...</i>
      check_color  = rgb(158, 206, 106)
      fail_color   = rgb(247, 118, 142)
      fail_text    = <i>$FAIL <b>($ATTEMPTS)</b></i>
      position     = 0, -120
      halign       = center
      valign       = center
    }

    label {
      monitor =
      text     = cmd[update:1000] echo "<b>$(date +"%H:%M")</b>"
      color    = rgba(169, 177, 214, 1.0)
      font_size = 72
      font_family = JetBrainsMono Nerd Font
      position  = 0, 80
      halign    = center
      valign    = center
    }

    label {
      monitor =
      text      = cmd[update:60000] echo "$(date +"%A, %d %B")"
      color     = rgba(187, 154, 247, 1.0)
      font_size  = 18
      font_family = JetBrainsMono Nerd Font
      position   = 0, 0
      halign     = center
      valign     = center
    }
  '';

  # ── GTK dark theme ───────────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name    = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # libadwaita / GTK4 apps respect this
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  home.packages = [ pkgs.rofi ];
}
