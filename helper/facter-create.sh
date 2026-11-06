#!/usr/bin/env bash
host=${1:-$(hostname)} # Hostname der Konfiguration, z.B. nixos-desktop
sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o modules/hosts/$host/facter.json
sudo chown felix:users modules/hosts/$host/facter.json