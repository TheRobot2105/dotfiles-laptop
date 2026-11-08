#!/usr/bin/env bash
set -e
set -o pipefail
ssh_private=/etc/ssh/ssh_host_ed25519_key
ssh_public=/etc/ssh/ssh_host_ed25519_key.pub
dotfiles_dir=/home/felix/.dotfiles
host=${1:-$(hostname)} # Hostname der Konfiguration, z.B. nixos-desktop

# Flakes für alle nix-Aufrufe aktivieren (auch die, die nh intern macht),
# da sie auf einem frischen System noch nicht eingeschaltet sind.
export NIX_CONFIG="experimental-features = nix-command flakes"

# nh wird erst durch die Konfiguration installiert – beim ersten Lauf aus nixpkgs holen.
if command -v nh >/dev/null; then
	nh=(nh)
else
	nh=(nix run nixpkgs#nh --)
fi

if [ -f "$ssh_private" ] && [ -f "$ssh_public" ] && [ -d "$dotfiles_dir" ]; then
	cd "$dotfiles_dir"
	sudo --preserve-env=NIX_CONFIG nix run nixpkgs#nixos-facter -- -o "modules/hosts/$host/facter.json"
	sudo chown felix:users "modules/hosts/$host/facter.json"
	# nh baut als Benutzer, zeigt Fortschritt (nix-output-monitor) und Paket-Diff
	# und holt sich sudo erst zum Aktivieren selbst – daher NICHT mit sudo aufrufen.
	"${nh[@]}" os switch "$dotfiles_dir" --hostname "$host"
	nix-store --optimise -vv
	"${nh[@]}" clean all
else
	echo "Bitte den Ordnernamen kontrollieren und den Namen und Ort des ssh-keys überprüfen."
fi
