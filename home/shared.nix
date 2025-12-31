{
  pkgs,
  ...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "emacsclient -nw";
    VISUAL = "emacsclient -c -a 'emacs'";
  };

  home.packages = with pkgs; [
    # CLI Tools
    eza # better ls
    bat # cat with highlighting
    fd # faster find
    ripgrep
    fzf # Ctrl+R fuzzy
    zoxide # better cd
    htop
    fastfetch
    ffmpeg

    # GUI Apps (Shared)
    firefox
    telegram-desktop
    antigravity
    audacity
    reaper

    # Fonts
    nerd-fonts.jetbrains-mono

    # LSPs/Formatters
    nodePackages.typescript-language-server
    tailwindcss-language-server
    nixd
    nixfmt-rfc-style
    gopls
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
      env.TERM = "xterm-256color";

      window = {
        dimensions = {
          columns = 120;
          lines = 35;
        };
        padding = {
          x = 10;
          y = 10;
        };
        opacity = 0.95;
        decorations = "none";
        dynamic_title = true;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        size = 13.0;
      };

      colors = {
        primary = {
          background = "#24283b";
          foreground = "#c0caf5";
        };
        normal = {
          black = "#1d202f";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };
        bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$nodejs$aws$nix_shell$cmd_duration\n$character";

      directory = {
        style = "bold lavender";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = " ";
        style = "bold green";
      };
      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style) )";
      };
      nodejs = {
        symbol = " ";
        style = "bold yellow";
        format = "via [$symbol($version )]($style)";
      };
      aws = {
        symbol = "☁️  ";
        style = "bold orange";
      };
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state]($style) ";
        style = "bold blue";
      };
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "yellow";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      ignoreDups = true;
      share = true;
      ignorePatterns = [
        "ls"
        "cd"
        "exit"
        "reboot"
        "clear"
      ];
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first --git";
      cat = "bat --style=plain --paging=never";
      e = "emacsclient -nw";
      gc = "nix-collect-garbage -d";
    };

    initContent = ''
      # Zoxide
      eval "$(zoxide init zsh)"
      alias cd="z"

      # FZF (Ctrl+R)
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # Emacs-mode on
      bindkey -e

      # Alt+W (copy)
      wl-copy-region() {
        zle copy-region-as-kill
        print -rn -- $CUTBUFFER | wl-copy
      }
      zle -N wl-copy-region
      bindkey '\ew' wl-copy-region  # \ew = Alt+W

      # Ctrl+Y (yank)
      wl-paste-insert() {
        LBUFFER+="$(wl-paste)"
      }
      zle -N wl-paste-insert
      bindkey '^Y' wl-paste-insert

      bindkey '^H' backward-kill-word     # Ctrl+Backspace
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/user.inc"; }
    ];
    settings = {
      init.defaultBranch = "main";
    };
  };

  programs.emacs = {
    enable = true;
    # package is defined in OS-specific configs
  };

  # Symlink tree-sitter grammars so Emacs (Brew or Nix) can find them
  # Emacs looks in ~/.emacs.d/var/treesit/ (Doom/Standard)
  home.file.".emacs.d/var/treesit" = {
    source = "${pkgs.emacsPackages.treesit-grammars.with-grammars (grammars: with grammars; [
      tree-sitter-bash
      tree-sitter-css
      tree-sitter-dockerfile
      tree-sitter-html
      tree-sitter-javascript
      tree-sitter-json
      tree-sitter-markdown
      tree-sitter-nix
      tree-sitter-tsx
      tree-sitter-typescript
      tree-sitter-yaml
      tree-sitter-go
      tree-sitter-gomod
      tree-sitter-python
    ])}/lib";
    recursive = true;
  };
}
