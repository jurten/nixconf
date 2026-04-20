{pkgs, ...}: {
  home.file.".local/bin/starwars-greeting" = {
    executable = true;
    source = ./starwars-greeting.py;
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      ignoreDups = true;
      share = true;
    };

    initContent = ''
      # Star Wars greeting (kitty interactive shells only)
      if [[ -n "$KITTY_PID" && $- == *i* ]]; then
        sw_scripts=(darthvader jangofett tiefighter1 tiefighter1row tiefighter2)
        colorscript -e ''${sw_scripts[$(( RANDOM % ''${#sw_scripts[@]} + 1 ))]}
      fi

      # Better completion menu
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      # Word-boundary navigation (Ctrl+Left/Right)
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';
  };

  programs.fd = {
    enable = true;
    hidden = true; # search hidden files by default
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--border"
      "--color=bg+:#292e42,bg:#1a1b26,spinner:#bb9af7,hl:#f7768e"
      "--color=fg:#a9b1d6,header:#f7768e,info:#bb9af7,pointer:#bb9af7"
      "--color=marker:#bb9af7,fg+:#a9b1d6,prompt:#7aa2f7,hl+:#f7768e"
    ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$username$directory$custom$git_branch$git_status$nodejs$python$rust$golang$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold #9ece6a)";
        error_symbol = "[❯](bold #f7768e)";
      };

      username = {
        show_always = true;
        style_user = "bold #9ece6a";
        style_root = "bold #f7768e";
        format = "[$user]($style) ";
      };

      directory = {
        style = "bold #7aa2f7";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      custom = {
        git_provider = {
          command = ''r=$(git remote get-url origin 2>/dev/null); case "$r" in *github*) echo " ";; *gitlab*) echo " ";; *bitbucket*) echo " ";; *) echo " ";; esac'';
          when = "git rev-parse --git-dir > /dev/null 2>&1";
          style = "#565f89";
          format = "[$output]($style)";
        };
      };

      git_branch = {
        symbol = "";
        style = "#e0af68";
        format = "[$branch]($style) ";
      };

      git_status = {
        style = "#f7768e";
        format = "([$all_status$ahead_behind]($style) )";
      };

      nodejs = {
        symbol = " ";
        style = "#9ece6a";
        format = "[$symbol$version]($style) ";
      };
      python = {
        symbol = " ";
        style = "#e0af68";
        format = "[$symbol$version]($style) ";
      };
      rust = {
        symbol = " ";
        style = "#ff9e64";
        format = "[$symbol$version]($style) ";
      };
      golang = {
        symbol = " ";
        style = "#7dcfff";
        format = "[$symbol$version]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        format = "[⏱ $duration]($style) ";
        style = "#565f89";
      };
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"]; # makes zoxide use `cd` directly, no alias needed
  };

  home.shellAliases = {
    grep = "rg";
    find = "fd";
    cat = "bat";
  };
}
