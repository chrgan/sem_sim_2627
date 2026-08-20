#!/usr/bin/env bash
# Gesamter Publish-Workflow: Netzlaufwerk -> lokales Repo -> docs/ -> commit -> push.
# Aufruf: scripts/publish.sh "Commit-Nachricht"
set -euo pipefail

LOCAL="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MSG="${1:-Update Sitzungen}"

"$LOCAL/scripts/sync-from-netdrive.sh"
"$LOCAL/scripts/build-docs.sh"

cd "$LOCAL"
git add -A
if git diff --cached --quiet; then
  echo "Keine Änderungen zu committen."
  exit 0
fi
git commit -m "$MSG"
git push
