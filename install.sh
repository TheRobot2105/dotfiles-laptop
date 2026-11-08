#!/usr/bin/env bash
# Neuinstallation in einem Schritt aus dem NixOS-Live-ISO, direkt von main.
#
#   git clone https://github.com/TheRobot2105/dotfiles-laptop.git ~/.dotfiles
#   cd ~/.dotfiles && ./install.sh nixos-laptop [--dry-run]
#
# Ablauf: Host-Key aus Bitwarden holen → damit den User-SSH-Key aus sops
# entschlüsseln (für den privaten wallpaper-Input) → facter → als Benutzer
# disko (LÖSCHT DIE PLATTE) → Host-Key nach /mnt/etc/ssh → System direkt
# nach /mnt bauen (nicht in den RAM des Live-ISOs) → nixos-install. sops-nix entschlüsselt dann schon bei der Installation.
#
# Umgebungsvariablen:
#   BW_ITEM    Name des Bitwarden-Eintrags mit dem Host-Key (Standard: ssh-host-key)
#   BW_SERVER  optional, z.B. https://vault.bitwarden.eu
set -euo pipefail

# Benötigte Werkzeuge aus nixpkgs holen und das Skript darin neu starten.
export NIX_CONFIG="experimental-features = nix-command flakes"
if [ -z "${INSTALL_SH_IN_SHELL:-}" ]; then
	export INSTALL_SH_IN_SHELL=1
	exec nix shell nixpkgs#{bitwarden-cli,sops,ssh-to-age,jq,nixos-facter,git,nix-output-monitor} --command "$0" "$@"
fi

host=""
dry_run=false
for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	-*)
		echo "Unbekannte Option: $arg" >&2
		exit 1
		;;
	*) host=$arg ;;
	esac
done

repo=$(git rev-parse --show-toplevel)
cd "$repo"

hosts=$(nix eval --json .#nixosConfigurations --apply builtins.attrNames | jq -r '.[]')
if [ -z "$host" ] || ! grep -qx "$host" <<<"$hosts"; then
	echo "Benutzung: $0 <host> [--dry-run]" >&2
	# shellcheck disable=SC2086 # Liste absichtlich aufteilen
	echo "Verfügbare Hosts:" $hosts >&2
	exit 1
fi

BW_ITEM=${BW_ITEM:-ssh-host-key}
luks_file=/tmp/luks-password # muss zu passwordFile in modules/hosts/*/disko.nix passen
tmp=$(mktemp -d)
chmod 700 "$tmp"

ssh_begin="# >>> install.sh (temporär)"
ssh_end="# <<< install.sh"
remove_ssh_block() {
	local range="/^$ssh_begin\$/,/^$ssh_end\$/d"
	[ -f ~/.ssh/config ] && sed -i "$range" ~/.ssh/config
	sudo test -f /root/.ssh/config && sudo sed -i "$range" /root/.ssh/config
	return 0
}

cleanup() {
	remove_ssh_block 2>/dev/null || true
	find "$tmp" -type f -exec shred -u {} + 2>/dev/null || true
	rm -rf "$tmp"
	[ -f "$luks_file" ] && shred -u "$luks_file"
	bw lock >/dev/null 2>&1 || true
}
trap cleanup EXIT

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# --- 1. Host-Key aus Bitwarden ------------------------------------------------
step "Host-Key aus Bitwarden holen (Eintrag: $BW_ITEM)"
# Server nur ändern, wenn nötig – bw erlaubt das nur im ausgeloggten Zustand.
if [ -n "${BW_SERVER:-}" ] && [ "$(bw config server)" != "${BW_SERVER%/}" ]; then
	bw logout >/dev/null 2>&1 || true
	bw config server "${BW_SERVER%/}" >/dev/null
fi
case "$(bw status | jq -r .status)" in
unauthenticated) BW_SESSION=$(bw login --raw) ;;
*) BW_SESSION=$(bw unlock --raw) ;;
esac
export BW_SESSION
bw sync >/dev/null

host_key=$tmp/ssh_host_ed25519_key
bw get item "$BW_ITEM" | jq -r '.sshKey.privateKey // .notes // empty' >"$host_key"
chmod 600 "$host_key"
if ! ssh-keygen -y -f "$host_key" >"$host_key.pub" 2>/dev/null; then
	echo "Eintrag '$BW_ITEM' enthält keinen gültigen privaten SSH-Key." >&2
	exit 1
fi

# --- 2. User-SSH-Key für GitHub (privater wallpaper-Input) --------------------
step "User-SSH-Key aus secrets/secrets.yaml entschlüsseln"
user_key=$tmp/id_ed25519
SOPS_AGE_KEY=$(ssh-to-age -private-key -i "$host_key") \
	sops -d --extract '["ssh-private-key-laptop"]' secrets/secrets.yaml >"$user_key"
chmod 600 "$user_key"
# Gilt für alle ssh-Aufrufe von git/nix in dieser Live-Sitzung – für den
# Benutzer (Auswertung) und für root (Build in /mnt).
# Der Block steht zwischen Markern, damit ein erneuter Lauf ihn ersetzt
# statt einen zweiten anzuhängen; cleanup entfernt ihn wieder.
ssh_conf="$ssh_begin
Host github.com
  IdentityFile $user_key
  IdentitiesOnly yes
  StrictHostKeyChecking accept-new
$ssh_end"
install -d -m700 ~/.ssh
sudo install -d -m700 /root/.ssh
remove_ssh_block
printf '%s\n' "$ssh_conf" >>~/.ssh/config
printf '%s\n' "$ssh_conf" | sudo tee -a /root/.ssh/config >/dev/null
# root wertet das Repo des Live-Benutzers aus.
sudo git config --global --get-all safe.directory 2>/dev/null | grep -qxF "$repo" ||
	sudo git config --global --add safe.directory "$repo"

# --- 3. Hardware erfassen ------------------------------------------------------
step "Hardware mit nixos-facter erfassen"
facter=modules/hosts/$host/facter.json
sudo "$(command -v nixos-facter)" -o "$facter"
sudo chown "$(id -u):$(id -g)" "$facter"
git add "$facter" # der flake sieht nur Dateien, die git kennt

# --- 4. disko-Skript bauen -----------------------------------------------------
# Im Live-ISO liegt /nix/store im RAM. Hier wird nur das kleine disko-Skript
# gebaut, das eigentliche System erst nach dem Partitionieren direkt in /mnt.
flake=".#nixosConfigurations.$host.config"
step "disko-Skript bauen ($host)"
disko=$(nix build --accept-flake-config --no-link --print-out-paths "$flake.system.build.destroyFormatMount")

if $dry_run; then
	step "Dry-Run: System auswerten und anzeigen, was geladen würde"
	nix build --accept-flake-config --dry-run "$flake.system.build.toplevel"
	step "Dry-Run: Auswertung ok, es wurde nichts verändert."
	exit 0
fi

# --- 5. LUKS-Passwort und Partitionierung --------------------------------------
disks=$(nix eval --raw "$flake.disko.devices.disk" \
	--apply 'd: builtins.concatStringsSep " " (map (x: x.device) (builtins.attrValues d))')

step "LUKS-Passwort festlegen"
while true; do
	read -rsp "Passwort für LUKS: " pw1 && echo
	read -rsp "Wiederholen: " pw2 && echo
	[ -n "$pw1" ] && [ "$pw1" = "$pw2" ] && break
	echo "Passwörter leer oder ungleich, nochmal."
done
(umask 077 && printf '%s' "$pw1" >"$luks_file")
unset pw1 pw2

# shellcheck disable=SC2086 # mehrere Platten möglich
lsblk -o NAME,SIZE,MODEL $disks
read -rp "ALLE Daten auf $disks werden gelöscht. Fortfahren? (yes/no): " ready
[ "$ready" = "yes" ] || exit 1

step "Platte partitionieren und nach /mnt einhängen"
sudo "$disko/bin/disko-destroy-format-mount" --yes-wipe-all-disks # bestätigt wurde oben

# disko legt die Swap-Datei an, aktiviert sie aber nicht. Ohne Swap reicht
# der RAM des Live-ISOs (Store im RAM) beim großen Build nicht.
step "Swap auf der neuen Platte aktivieren"
for dev in $(nix eval --json "$flake.swapDevices" --apply 'map (s: s.device)' | jq -r '.[]'); do
	sudo swapon "/mnt$dev" || echo "Konnte /mnt$dev nicht aktivieren, weiter ohne." >&2
done
swapon --show

# --- 6. Host-Key ins neue System, dann installieren ----------------------------
step "Host-Key nach /mnt/etc/ssh kopieren"
sudo install -D -m600 -o root -g root "$host_key" /mnt/etc/ssh/ssh_host_ed25519_key
sudo install -D -m644 -o root -g root "$host_key.pub" /mnt/etc/ssh/ssh_host_ed25519_key.pub

# Auswerten und Bauen getrennt: Der Speicher der Auswertung (mehrere GB) wird
# erst frei, wenn der Prozess endet – der Build läuft dann in einem frischen.
nix_mnt=(sudo --preserve-env=NIX_CONFIG nix --accept-flake-config --store /mnt)
step "System auswerten"
drv=$("${nix_mnt[@]}" eval --raw "$flake.system.build.toplevel.drvPath")

step "System direkt in den Store auf der neuen Platte bauen (/mnt/nix/store)"
# nom zeigt dieselbe Fortschrittsanzeige wie nh; pipefail bricht bei Fehlern ab.
"${nix_mnt[@]}" build --no-link --log-format internal-json -v "$drv^*" |& nom --json
# nom schluckt die normale Ausgabe – Pfad holen (baut nichts neu).
system=$("${nix_mnt[@]}" build --no-link --print-out-paths "$drv^*")

step "NixOS installieren"
sudo nixos-install --root /mnt --system "$system" --no-root-passwd --no-channel-copy

# --- 7. Repo ins neue System übernehmen ---------------------------------------
step "Dotfiles nach /mnt/home/felix/.dotfiles kopieren"
sudo mkdir -p /mnt/home/felix
sudo cp -a "$repo" /mnt/home/felix/.dotfiles
sudo nixos-enter --root /mnt -c 'chown -R felix:users /home/felix/.dotfiles'
# Nach dem Reboot liegt der User-SSH-Key aus sops bereit → Remote auf SSH.
remote=$(git remote get-url origin)
ssh_remote=$(sed -E 's#\.git$##; s#^https://github.com/#git@github.com:#; s#$#.git#' <<<"$remote")
sudo git -C /mnt/home/felix/.dotfiles remote set-url origin "$ssh_remote"

step "Fertig. Nach dem Reboot: $facter committen und pushen."
