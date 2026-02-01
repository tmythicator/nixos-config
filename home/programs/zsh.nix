{ pkgs, ... }:
{
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
      et = "emacs -nw";
      gc = "nix-collect-garbage -d";
    };

    initContent =
      let
        isDarwin = pkgs.stdenv.isDarwin;
        copyCmd = if isDarwin then "pbcopy" else "wl-copy";
        pasteCmd = if isDarwin then "pbpaste" else "wl-paste";
        pastePrimaryCmd = if isDarwin then pasteCmd else "wl-paste --primary";
      in
      ''
        # Emacs-mode on
        bindkey -e

        # Ctrl+W: Smart Cut (Region if selected, Word otherwise)
        wl-smart-cut() {
          if ((REGION_ACTIVE)); then
            zle kill-region
          else
            zle backward-kill-word
          fi
          print -rn -- $CUTBUFFER | wl-copy
        }
        zle -N wl-smart-cut
        bindkey '^W' wl-smart-cut

        # Ctrl+Y: Paste from system clipboard
        wl-paste-insert() {
          LBUFFER+="$(wl-paste)"
        }
        zle -N wl-paste-insert
        bindkey '^Y' wl-paste-insert

        # Ctrl+Backspace
        bindkey '^H' backward-kill-word
      '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
