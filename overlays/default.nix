{ inputs, ... }:
final: prev: {
  antigravity =
    inputs.antigravity-nix.packages.${prev.stdenv.hostPlatform.system}.google-antigravity-ide;

  firefox = if prev.stdenv.isDarwin then prev.firefox-bin else prev.firefox;
}
