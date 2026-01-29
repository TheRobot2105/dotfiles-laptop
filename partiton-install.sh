#!/usr/bin/env bash
set -e
rm -rf /tmp/luks-password
echo -n "Password für LUKS:"
read -sr password
echo -n "$password" >/tmp/luks-password

echo -n "Ready for Install?(yes/no):"
read -r ready
if [[ "$ready" = "yes" ]]; then
    sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
    sudo chown -R nixos:users /home/nixos/dotfiles-laptop
    git add .
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix --yes-wipe-all-disks
    sudo nixos-install --root /mnt --flake .#nixos-laptop
    sudo nixos-enter --root /mnt -c 'passwd felix'
fi
