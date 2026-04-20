{ ... }: {

  # ── Kitty terminal ────────────────────────────────────────────────────────
  # Based on jurten-cfg (github.com/jurten/jurten-cfg) — Tokyo Night theme
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";  # matches system font from desktop/plasma.nix
      size = 11.0;
    };

    settings = {
      # ── Colors — Tokyo Night ─────────────────────────────────────────────
      foreground           = "#a9b1d6";
      background           = "#1a1b26";
      selection_foreground = "none";
      selection_background = "#28344a";
      cursor               = "#c0caf5";
      cursor_text_color    = "#1a1b26";
      url_color            = "#9ece6a";

      # 16-color palette
      color0  = "#414868";  color8  = "#414868";
      color1  = "#f7768e";  color9  = "#f7768e";
      color2  = "#73daca";  color10 = "#73daca";
      color3  = "#e0af68";  color11 = "#e0af68";
      color4  = "#7aa2f7";  color12 = "#7aa2f7";
      color5  = "#bb9af7";  color13 = "#bb9af7";
      color6  = "#7dcfff";  color14 = "#7dcfff";
      color7  = "#c0caf5";  color15 = "#c0caf5";

      # ── Tab bar ──────────────────────────────────────────────────────────
      tab_bar_edge             = "bottom";
      tab_bar_style            = "fade";
      tab_bar_align            = "left";
      tab_bar_min_tabs         = 2;
      active_tab_foreground    = "#3d59a1";
      active_tab_background    = "#16161e";
      active_tab_font_style    = "bold-italic";
      inactive_tab_foreground  = "#787c99";
      inactive_tab_background  = "#16161e";
      inactive_tab_font_style  = "normal";
      tab_bar_background       = "#101014";

      # ── Visual ───────────────────────────────────────────────────────────
      background_opacity         = "0.8";
      cursor_shape               = "block";
      cursor_stop_blinking_after = 15;
      cursor_trail               = 1;
      cursor_trail_decay         = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      url_style                  = "curly";
      detect_urls                = "yes";

      # ── Performance ──────────────────────────────────────────────────────
      scrollback_lines  = 2000;
      repaint_delay     = 10;
      input_delay       = 3;
      sync_to_monitor   = "yes";
    };
  };
}
