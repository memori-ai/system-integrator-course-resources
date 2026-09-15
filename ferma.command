#!/bin/bash
# =====================================================================
#  Ferma tutte le demo del corso - doppio clic (macOS).
#  Controparte di avvia.command. Equivalente per Windows: ferma.bat
# =====================================================================
cd "$(dirname "$0")" || exit 1

export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin:/Applications/Docker.app/Contents/Resources/bin"

if ! command -v node >/dev/null 2>&1; then
  for profilo in "$HOME/.nvm/nvm.sh" "$HOME/.zprofile" "$HOME/.bash_profile" "$HOME/.profile"; do
    [ -r "$profilo" ] && . "$profilo" >/dev/null 2>&1
  done
fi

fine() {
  echo
  read -r -p "Premi Invio per chiudere questa finestra..." _
  exit "${1:-0}"
}

echo
echo " ============================================================"
echo "   Arresto delle demo in corso..."
echo " ============================================================"
echo

if ! command -v node >/dev/null 2>&1; then
  echo " Node.js non risulta installato, quindi le demo non sono mai"
  echo " state avviate da qui: non c'e' nulla da fermare."
  fine 0
fi

if ! docker info >/dev/null 2>&1; then
  echo " Docker non e' in esecuzione: le demo sono gia' ferme."
  fine 0
fi

node stop-all.js

echo
echo " Fatto: le demo sono state fermate."
echo " Per riavviarle, doppio clic su \"avvia.command\"."
fine 0
