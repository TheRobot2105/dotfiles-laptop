#!/usr/bin/env bash
rm -rf /tmp/luks-password
echo -n "Password für LUKS:"
read -sr password
echo -n "$password" >/tmp/luks-password
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix
echo "it is important that a temp Password has been set in configuration.nix!"
echo -n "Ready for Install?(yes/no):"
read ready
if [[ "$ready" = "yes" ]]; then
    sudo nixos-install --root /mnt --flake .#nixos-laptop
fi
