{ pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    antigravity
    reaper
    mermaid-cli
  ];
}
