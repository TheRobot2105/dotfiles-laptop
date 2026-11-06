#!/usr/bin/env bash
sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o modules/hosts/nixos-laptop/facter.json
sudo chown felix:users modules/hosts/nixos-laptop/facter.json