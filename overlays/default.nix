{ inputs, ... }:
final: prev: {
  antigravity =
    inputs.antigravity-nix.packages.${prev.stdenv.hostPlatform.system}.google-antigravity-ide;
}
