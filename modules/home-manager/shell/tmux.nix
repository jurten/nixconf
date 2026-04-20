{ pkgs, ... }:

{
  home.file.".local/bin/tmux-cpu-percent" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      read -r _ u1 n1 s1 i1 w1 r1 x1 _ < /proc/stat
      sleep 0.2
      read -r _ u2 n2 s2 i2 w2 r2 x2 _ < /proc/stat
      total=$(( (u2+n2+s2+i2+w2+r2+x2) - (u1+n1+s1+i1+w1+r1+x1) ))
      idle=$(( i2 - i1 ))
      echo "$(( (total - idle) * 100 / total ))%"
    '';
  };

  home.file.".local/bin/tmux-icon" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      case "$1" in
        nvim|vim|vi)         echo "󰙱 " ;;
        zsh|bash|sh|fish)    echo " " ;;
        python*|ipython)     echo " " ;;
        node|npm|npx|bun)    echo " " ;;
        git|lazygit)         echo " " ;;
        ssh)                 echo " " ;;
        htop|btop|top)       echo " " ;;
        docker)              echo " " ;;
        make|cmake|cargo)    echo " " ;;
        kubectl|k9s)         echo "󱃾 " ;;
        psql|mysql|sqlite3)  echo " " ;;
        *)                   echo " " ;;
      esac
    '';
  };

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
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_text "#($HOME/.local/bin/tmux-icon #{pane_current_command})#{pane_current_command}"
          set -g @catppuccin_window_current_text "#($HOME/.local/bin/tmux-icon #{pane_current_command})#{pane_current_command}"
          set -g @catppuccin_cpu_text " #($HOME/.local/bin/tmux-cpu-percent)"
        '';
      }
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

      # Status bar (catppuccin v2 requires manual status-right)
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_cpu}#{E:@catppuccin_status_uptime}"

      # Session persistence
      set -g @continuum-restore 'on'
      set -g @resurrect-capture-pane-contents 'on'

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
