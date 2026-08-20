#!/usr/bin/env bash
# Kopiert die gerenderten Revealjs-/PDF-Ausgaben jeder Sitzung nach docs/,
# damit GitHub Pages sie ausliefern kann. Läuft NACH sync-from-netdrive.sh.
#
# Neue Sitzung hinzufügen: Block unten kopieren, Variablen anpassen und
# den passenden Eintrag in docs/index.html ergänzen.
set -euo pipefail

LOCAL="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$LOCAL"

publish_session () {
  local src="$1"   # z.B. Sitzung_01_Einfuehrung/Praesentation
  local qmd="$2"   # Basisname ohne .qmd, z.B. Sitzung_01_Einfuehrung
  local slug="$3"  # Zielordner unter docs/, z.B. sitzung-01-einfuehrung

  local dst="docs/$slug"
  mkdir -p "$dst"
  rm -rf "$dst"/*

  cp "$src/$qmd.html" "$dst/index.html"
  [ -d "$src/${qmd}_files" ] && cp -r "$src/${qmd}_files" "$dst/"
  [ -f "$src/$qmd.pdf" ] && cp "$src/$qmd.pdf" "$dst/"

  # lokal referenzierte Bilder (nicht in _files/) automatisch mitkopieren
  grep -oE '(src|data-background-image)="[^"/][^"]*"' "$src/$qmd.html" \
    | sed -E 's/.*"(.*)"/\1/' \
    | grep -v "^${qmd}_files/" \
    | sort -u \
    | while read -r asset; do
        [ -f "$src/$asset" ] && cp "$src/$asset" "$dst/"
      done

  echo "Veröffentlicht: $src -> $dst"
}

publish_session "Sitzung_01_Einfuehrung/Praesentation" "Sitzung_01_Einfuehrung" "sitzung-01-einfuehrung"

# publish_session "Sitzung_02_Ueberblick/Praesentation" "Sitzung_02_Ueberblick" "sitzung-02-ueberblick"
