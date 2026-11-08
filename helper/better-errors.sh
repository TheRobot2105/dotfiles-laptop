#!/usr/bin/env bash
# Baut und aktiviert die Konfiguration mit nh. `script` gibt nh ein echtes Terminal,
# damit die Fortschrittsanzeige erhalten bleibt, und schreibt die Ausgabe zusätzlich
# nach nixos-switch.log. Schlägt der Build fehl, werden nur die Fehlerzeilen gezeigt.
# nh holt sich sudo selbst – daher NICHT mit sudo aufrufen.
host=${1:-$(hostname)} # Hostname der Konfiguration, z.B. nixos-desktop
log=nixos-switch.log

if ! script -qefc "nh os switch . --hostname $host" "$log"; then
	echo
	echo "Fehler (vollständiges Log: $log):"
	# keine "error"-Zeile gefunden → die letzten Zeilen zeigen
	grep --color=always -i "error" "$log" || tail -n 20 "$log"
	exit 1
fi
