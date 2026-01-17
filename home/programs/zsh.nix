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
}
