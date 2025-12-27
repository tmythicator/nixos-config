{
  config,
  pkgs,
  user,
  ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "emacsclient -nw";
    VISUAL = "emacsclient -c -a 'emacs'";
    SOPS_AGE_KEY_FILE = "${homeDir}/.config/sops/age/keys.txt";
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
    nvitop
    fastfetch

    # GUI apps
    firefox
    google-chrome
    telegram-desktop
    antigravity

    # Media
    audacity
    reaper
    gimp
    vlc
    tauon

    # GNOME utils
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection

    # Fonts
    nerd-fonts.jetbrains-mono

    # LSPs/Formatters
    nodePackages.typescript-language-server
    tailwindcss-language-server
    nixd
    nixfmt-rfc-style
    gopls
  ];

  # Sops
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

    secrets.git_name = { };
    secrets.git_email = { };

    templates."git-user.inc" = {
      content = ''
        [user]
        name = ${config.sops.placeholder.git_name}
        email = ${config.sops.placeholder.git_email}
      '';
      path = "${homeDir}/.config/git/user.inc";
    };
  };

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

      keyboard.bindings = [
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }

        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
      ];
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
      path = "${config.xdg.dataHome}/zsh/history";
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
      update = "sudo nixos-rebuild switch --flake ${homeDir}/Development/nixos-config#nixos-rog";
      upgrade = "nix flake update --flake ${homeDir}/Development/nixos-config && update";
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

  # Dev & Editor
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "${homeDir}/.ssh/id_ed25519";
      };
    };
  };

  programs.git = {
    enable = true;
    includes = [
      { path = "${homeDir}/.config/git/user.inc"; }
    ];
    settings = {
      init.defaultBranch = "main";
    };
  };

  # Emacs
  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    startWithUserSession = "graphical";
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
  };

  systemd.user.services.emacs.Service = {
    Restart = "on-failure";
    RestartSec = 3;
    Environment = "DISPLAY=:0";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      (epkgs.treesit-grammars.with-grammars (
        grammars: with grammars; [
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
        ]
      ))
    ];
  };

  # GNOME settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      center-new-windows = true;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "ctrl:nocaps"
        "grp:ctrl_shift_toggle"
      ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
      ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      gestures = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>a";
      command = "alacritty";
      name = "Alacritty";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "emacsclient -c -n";
      name = "Emacs Client";
    };
  };
}
