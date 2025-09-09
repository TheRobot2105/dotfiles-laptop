#!/usr/bin/env bash
sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
sudo chown felix:users facter.json