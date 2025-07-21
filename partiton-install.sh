#!/usr/bin/env bash
rm -rf /tmp/luks-password
echo -n "Password für LUKS:"
read -sr password
echo -n "$password" >/tmp/luks-password
sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
git add .
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix --yes-wipe-all-disks
echo -n "Ready for Install?(yes/no):"
read -r ready
if [[ "$ready" = "yes" ]]; then
    sudo nixos-install --root /mnt --flake .#nixos-laptop
    sudo nixos-enter --root /mnt -c 'passwd felix'
fi
