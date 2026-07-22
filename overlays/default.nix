{ inputs, ... }:
final: prev: {
  antigravity = inputs.antigravity-nix.packages.${prev.system}.google-antigravity-ide;
}
