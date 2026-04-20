{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell  = "${pkgs.zsh}/bin/zsh";

    prefix       = "C-Space";
    baseIndex    = 1;
    mouse        = true;
    keyMode      = "vi";
    sensibleOnTop = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      catppuccin
      yank
      resurrect
      continuum
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      bind C-Space send-prefix

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Alt-arrow to switch panes (no prefix)
      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D

      # Shift-arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Shift-Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # Session persistence
      set -g @continuum-restore 'on'
      set -g @resurrect-capture-pane-contents 'on'

      # Catppuccin theme
      set -g @catppuccin_flavour 'mocha'

      # Vi copy mode bindings
      bind-key -T copy-mode-vi v   send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

      # Split in current path
      bind '"' split-window -v -c "#{pane_current_path}"
      bind %   split-window -h -c "#{pane_current_path}"
    '';
  };
}
