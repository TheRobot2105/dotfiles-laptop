#!/usr/bin/env bash
set -e 
set -o pipefail
ssh_private=/etc/ssh/ssh_host_ed25519_key
ssh_public=/etc/ssh/ssh_host_ed25519_key.pub
dotfiles_dir=/home/felix/.dotfiles
host=${1:-$(hostname)} # Hostname der Konfiguration, z.B. nixos-desktop
if [ -f "$ssh_private" ] && [ -f "$ssh_public" ] && [ -d "$dotfiles_dir" ]; then
	sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o modules/hosts/$host/facter.json
	sudo chown felix:users modules/hosts/$host/facter.json
	sudo nixos-rebuild switch --flake .#$host
	nix-store --optimise -vv
	nh clean all
else
	echo "Bitte den Odnernamen kontrollieren und den Namen und Ort des ssh-keys überprüfen."
fi
