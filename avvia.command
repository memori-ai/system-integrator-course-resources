#!/bin/bash
# =====================================================================
#  Demo del corso System Integrator - avvio con un doppio clic (macOS).
#
#  Fa le stesse cose di "npm run start:all" senza dover aprire un
#  terminale: controlla i prerequisiti (Node.js e Docker Desktop),
#  avvia Docker Desktop se e' spento, lancia le quattro demo e apre
#  l'hub nel browser. Equivalente per Windows: avvia.bat
#
#  Funziona anche su Linux se eseguito da terminale; li' Docker va
#  avviato a mano perche' non esiste Docker Desktop da aprire.
# =====================================================================
cd "$(dirname "$0")" || exit 1

# Aperto con doppio clic dal Finder, questo script NON eredita il PATH
# configurato nel profilo dell'utente: senza queste aggiunte "node" e
# "docker" risultano mancanti anche quando sono installati.
export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin:/Applications/Docker.app/Contents/Resources/bin"

# Ultima spiaggia per chi usa nvm o un'installazione non standard: leggo i
# file di profilo solo se node non si trova, e ignoro ogni loro errore.
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
echo "   Demo del corso AIsuru System Integrator"
echo " ============================================================"
echo

# ----------------------------------------------------------------- 1/3
echo " [1/3] Controllo Node.js..."
if ! command -v node >/dev/null 2>&1; then
  echo "       Node.js non risulta installato."
  echo
  echo " Cosa fare:"
  echo "   1. vai su https://nodejs.org"
  echo "   2. scarica la versione indicata come \"LTS\" e installala"
  echo "      lasciando tutte le opzioni come sono"
  echo "   3. fai di nuovo doppio clic su questo file"
  fine 1
fi
echo "       OK."
echo

# ----------------------------------------------------------------- 2/3
echo " [2/3] Controllo Docker Desktop..."
if ! command -v docker >/dev/null 2>&1; then
  echo "       Docker Desktop non risulta installato."
  echo
  echo " Cosa fare:"
  echo "   1. vai su https://www.docker.com/products/docker-desktop/"
  echo "   2. scarica Docker Desktop per Mac e installalo"
  echo "   3. aprilo almeno una volta e attendi che scriva \"Engine running\""
  echo "   4. fai di nuovo doppio clic su questo file"
  fine 1
fi

if ! docker info >/dev/null 2>&1; then
  if command -v open >/dev/null 2>&1 && [ -d "/Applications/Docker.app" ]; then
    echo "       Docker Desktop non e' in esecuzione: provo ad avviarlo io."
    open -g -a Docker >/dev/null 2>&1
  else
    echo "       Docker non e' in esecuzione: avvialo e riprova."
    fine 1
  fi

  echo "       Attendo che sia pronto, puo' volerci un paio di minuti."
  tentativi=0
  until docker info >/dev/null 2>&1; do
    tentativi=$((tentativi + 1))
    if [ "$tentativi" -ge 60 ]; then
      echo
      echo "       Docker Desktop non e' diventato pronto entro tre minuti."
      echo
      echo " Cosa fare:"
      echo "   1. apri Docker Desktop dalla cartella Applicazioni"
      echo "   2. attendi che in basso a sinistra compaia \"Engine running\""
      echo "   3. fai di nuovo doppio clic su questo file"
      fine 1
    fi
    printf "."
    sleep 3
  done
  echo
fi
echo "       OK."
echo

# ----------------------------------------------------------------- 3/3
echo " [3/3] Avvio delle demo."
echo
echo "       La prima volta puo' richiedere anche una decina di minuti:"
echo "       e' normale. Non chiudere questa finestra finche' non compare"
echo "       il messaggio finale."
echo

if node start-all.js --quiet; then
  echo
  echo " ============================================================"
  echo "   Tutto pronto."
  echo " ============================================================"
  echo
  echo " L'elenco delle demo si sta aprendo nel tuo browser. Se non si"
  echo " apre da solo, fai doppio clic sul file \"index.html\" che trovi"
  echo " in questa stessa cartella."
else
  echo
  echo " ============================================================"
  echo "   Alcune demo non sono partite."
  echo " ============================================================"
  echo
  echo " Quelle partite correttamente sono comunque utilizzabili: le"
  echo " trovi nell'elenco che si sta aprendo nel browser."
  echo
  echo " Per capire cosa e' andato storto apri il file \"avvio.log\" in"
  echo " questa cartella, oppure inviacelo: contiene i dettagli tecnici."
fi

echo
echo " Le demo restano attive anche dopo aver chiuso questa finestra."
echo " Per fermarle, doppio clic su \"ferma.command\"."
fine 0
