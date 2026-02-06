#!/bin/bash
set -e

echo "Starting macOS setup..."

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Installing Nix..."
    # Using the official installer
    sh <(curl -L https://nixos.org/nix/install)

    # Source nix profile to make it available in current shell
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo "Nix is already installed."
fi

echo "Building and switching to flake configuration..."
nix run --extra-experimental-features "nix-command flakes" nix-darwin -- switch --flake .#macos

echo "Setup complete!"
