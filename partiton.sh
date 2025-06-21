#!/usr/bin/env bash
echo -n "Password für LUKS:"
read -s password
echo -n "$password" > /tmp/luks-password
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix