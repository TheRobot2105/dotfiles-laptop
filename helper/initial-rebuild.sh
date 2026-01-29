#!/usr/bin/env bash
ssh_private=/etc/ssh/ssh_host_ed25519_key
ssh_public=/etc/ssh/ssh_host_ed25519_key.pub
dotfiles_dir=/home/felix/.dotfiles
if [ -f "$ssh_private" ] && [ -f "$ssh_public" ] && [ -d "$dotfiles_dir" ]; then
	sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
	sudo chown felix:users facter.json
	#sudo nixos-rebuild switch --flake .#nixos-laptop
	nh os switch
else
	echo "Bitte den Odnernamen kontrollieren und den Namen und Ort des ssh-keys überprüfen."
fi
