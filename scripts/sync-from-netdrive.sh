#!/usr/bin/env bash
# Spiegelt die Arbeitsdateien vom Netzlaufwerk (Quelle) in dieses lokale
# Git-Repo (nur für Git-Operationen/Publishing). Einseitig: Netzlaufwerk -> lokal.
# Nicht andersherum verwenden - Änderungen bitte immer auf dem Netzlaufwerk machen.
set -euo pipefail

NETSRC="/mnt/uni_home/Lehrveranstaltungen/44_WiSe_2627/Sem_Sim_WiSe_2026_27/Sitzungen"
LOCAL="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rsync -a --delete \
  --exclude='.git/' \
  --exclude='docs/' \
  --exclude='scripts/' \
  --exclude='.gitignore' \
  --exclude='.claude/' \
  --exclude='.quarto/' \
  --exclude='.Rhistory' \
  --exclude='.RData' \
  --exclude='.DS_Store' \
  "$NETSRC"/ "$LOCAL"/

echo "Sync abgeschlossen: $NETSRC -> $LOCAL"
