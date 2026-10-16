# Programmazione del Web Component AIsuru

Guida all'integrazione e alla programmazione del web component AIsuru nelle tue applicazioni.

[English version](./README.md)

## Panoramica

Questa guida copre:

- L'embedding del web component AIsuru in una pagina web
- La configurazione del component con le credenziali del tuo agente
- L'attivazione di azioni sul DOM dalle risposte dell'agente tramite un tag di output strutturato
- Il passaggio di informazioni sulla pagina corrente all'agente all'avvio della sessione

---

## Prerequisiti

1. Un account AIsuru su [memori.aclambda.online](https://memori.aclambda.online)
2. Un agente (memori) configurato in quell'account
3. Accesso alla sezione **Dev docs** dell'agente
4. Conoscenza base di HTML e JavaScript

**Serve Docker Desktop.** La demo gira dentro container Docker: installa [Docker Desktop](https://www.docker.com/products/docker-desktop/) e assicurati che sia in esecuzione prima di lanciare `npm run start`.

---

## Applicazione demo

Il modulo include una demo Rails.

### Avvio rapido

```bash
cd demo
```

La prima volta crea un file `.env_dev` nella cartella `demo/` con questo contenuto:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

(Il launcher `npm run start:all` nella root del repository scrive il file da solo.)

```bash
# Compila e avvia l'applicazione
npm run start

# Apri il browser
open http://localhost:13005
```

Il servizio `web` è mappato sulla porta 13005 invece che sulla 3000, così questa demo può girare insieme alle altre. Dentro il container ascolta comunque sulla 3000.

**Windows, se `npm run start` fallisce:** Git su Windows può convertire i fine riga in CRLF, cosa che rompe gli script shell dentro il container. Esegui questo comando una volta e riprova:

```bash
git config --global core.autocrlf false
```

### Demo disponibili

#### Demo 1: l'agente controlla la pagina

L'agente risponde in chat e, allo stesso tempo, agisce sulla pagina in cui è embedded: evidenzia un pulsante, mostra un alert o fa lampeggiare lo sfondo. Lato piattaforma non serve nulla di particolare: il comportamento nasce dal prompt dell'agente più un listener nella pagina.

Nella demo sono cablate tre azioni:

| Azione | Effetto sulla pagina |
|--------|----------------------|
| `highlight_home_button` | Contorno giallo attorno al pulsante "Back to Demo Selection" |
| `show_alert` | Alert dismissibile in cima alla pagina, sparisce dopo 4 secondi |
| `flash_background_temp` | Lo sfondo della pagina diventa giallo caldo per 1,5 secondi |

La pagina della demo guida tutta la configurazione:

1. Scarica `agent_prompt.txt` dalla pagina e incollalo nel prompt del tuo agente (impostazioni agente, sezione AI). Il prompt dichiara le tre azioni e il formato del tag di output.
2. Copia gli ID dell'agente da **Dev docs** e incollali nel form della pagina, che carica il web component.
3. Chiedi un'azione all'agente ("evidenzia il pulsante indietro", "mostrami un alert", "fai lampeggiare lo sfondo") e osserva la pagina reagire.

### Struttura del progetto

```
demo/
├── agent_prompt.txt                # Prompt da incollare nell'agente, servito dal pulsante di download
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Pagina di selezione delle demo
│   │   └── demo1_controller.rb     # Demo 1, incluso il download del prompt
│   └── views/
│       ├── home/index.html.erb     # Selezione delle demo
│       └── demo1/index.html.erb    # Pagina della demo 1, component e listener
├── docker-compose.yml
├── Dockerfile.dev
└── Gemfile
```

### Comandi Docker

```bash
# Avvia l'applicazione
docker compose up

# Avvia in background
docker compose up -d

# Ferma l'applicazione
docker compose down

# Guarda i log
docker compose logs -f web

# Installa/aggiorna le gem
docker compose run --rm web bundle

# Console Rails
docker compose run --rm web rails console
```

---

## Come ottenere gli ID dell'agente

Apri il tuo agente su AIsuru, clicca **Dev docs** nella barra laterale a sinistra ed espandi **Altri riferimenti** ("Other references" nell'interfaccia in inglese):

| Campo | Usato come | Esempio |
|-------|------------|---------|
| Secondary Memori (Agent) ID | `memoriID` | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
| Owner user ID | `ownerUserID` | `c3d4e5f6-a7b8-9012-cdef-123456789012` |

---

## Setup base del web component

### Passo 1: includi il web component

Aggiungi queste due righe nell'`<head>` della pagina, oppure appena prima della chiusura di `</body>`:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Passo 2: configura il web component

```html
<memori-client
  memoriName="NomeDelTuoAgente"
  ownerUserName="tuo.username"
  memoriID="YOUR_MEMORI_ID"
  ownerUserID="YOUR_OWNER_USER_ID"
  tenantID="memori.aclambda.online"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://memori.aclambda.online"
  layout="CHAT"
  uiLang="IT"
  spokenLang="IT"
  showLogin="true"
></memori-client>
```

---

## Attivare azioni sul DOM dalle risposte dell'agente

È quello che implementa la Demo 1, e richiede due pezzi.

**Lato agente**, il prompt dichiara le azioni disponibili e chiede all'agente di chiudere la risposta con un tag nascosto che contiene un array JSON di nomi di azione:

```
<output class="memori-test">["highlight_home_button"]</output>
```

Più azioni possono viaggiare nello stesso tag. Il tag non va mai spiegato all'utente: la pagina lo rimuove e reagisce di conseguenza.

**Lato pagina**, il web component emette un evento `MemoriNewDialogState` a ogni risposta. Il listener legge il tag e smista le azioni:

```javascript
document.addEventListener('MemoriNewDialogState', (e) => {
  const emission = e.detail.emission;
  if (!emission) return;

  const match = emission.match(/<output class="memori-test">([\s\S]*?)<\/output>/);
  if (!match) return;

  const actions = JSON.parse(match[1].trim());

  actions.forEach((action) => {
    if (action === 'highlight_home_button') highlightHomeButton();
    else if (action === 'show_alert') showAlert();
    else if (action === 'flash_background_temp') flashBackground();
  });
});
```

Il nome della classe del tag e i nomi delle azioni sono una convenzione fra il tuo prompt e la tua pagina: scegli i tuoi, purché le due parti siano d'accordo.

---

## Passare il contesto della pagina all'agente

Tecnica collegata, non usata dalla Demo 1: l'attributo `initialQuestion` invia un messaggio all'agente all'apertura della sessione, ed è il punto giusto per descrivere cosa sta guardando l'utente.

```html
<memori-client
  ...
  initialQuestion="L'utente sta visualizzando il seguente contenuto della pagina: [contenuto qui]"
></memori-client>
```

L'agente può così rispondere su ciò che è a schermo senza che l'utente debba descriverlo.

---

## Struttura del modulo

```
SYS-05-web-component-programming/
├── README.md          # Panoramica del modulo (EN)
├── README-IT.md       # Panoramica del modulo (IT)
└── web_component/     # Demo app programmazione web component
    ├── README.md      # Guida completa (EN)
    ├── README-IT.md   # Questo file, guida completa (IT)
    └── demo/          # Applicazione Rails, demo 1
```

## Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Guida alle funzioni avanzate](https://docs.aisuru.com/advanced-functions)
- [Pacchetto NPM del web component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

[Home del corso](../../README-IT.md)
