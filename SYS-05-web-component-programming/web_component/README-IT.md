# Programmazione Web Component con AIsuru

> Guida completa all'integrazione e personalizzazione del web component AIsuru nelle tue applicazioni

## Panoramica

Questa guida spiega come integrare e programmare il web component AIsuru per creare esperienze AI contestuali. Imparerai a:

- Integrare il web component AIsuru in una pagina web
- Passare il contenuto della pagina all'agente all'avvio della sessione
- Abilitare conversazioni contestuali legate a ciò che l'utente sta visualizzando
- Attivare azioni sul DOM dalle risposte dell'agente

---

## Prerequisiti

Prima di iniziare, hai bisogno di:

1. Un **account AIsuru** su [aisuru.com](https://www.aisuru.com)
2. Un **Agente AI (Memori)** configurato nel tuo account
3. Accesso alla sezione **Dev Docs** del tuo agente
4. Conoscenza base di HTML e JavaScript

> ⚠️ **Docker Desktop obbligatorio** — L'applicazione demo gira interamente in container Docker. Assicurati di avere [Docker Desktop](https://www.docker.com/products/docker-desktop/) installato e avviato sulla tua macchina prima di eseguire `npm run start`.

---

## Applicazione Demo

Questo modulo include **una demo applicativa funzionante** realizzata con Ruby on Rails che mostra tecniche di programmazione del web component.

### Quick Start

```bash
# Naviga nella cartella demo
cd demo
```

Crea un file chiamato `.env_dev` nella cartella `demo/` (solo la prima volta) con il seguente contenuto:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

```bash
# Costruisci e avvia l'applicazione (comando unico)
npm run start

# Apri nel browser
open http://localhost:13005
```

> ℹ️ Il servizio `web` di questa demo è mappato sulla porta host **13005** (invece di 3000) per poter girare insieme alle altre demo. All'interno del container resta comunque sulla 3000.

> 💡 **Utenti Windows — se `npm run start` non funziona:** Git su Windows può convertire automaticamente i line endings in CRLF, causando errori negli script shell dentro Docker. Esegui questo comando una volta dal terminale e poi riprova:
> ```bash
> git config --global core.autocrlf false
> ```

### Demo Disponibili

#### Demo 1: Agente per Controllare il Contenuto della Pagina

Impara come rendere il tuo agente AIsuru consapevole della pagina web in cui è integrato, permettendogli di rispondere a domande su ciò che l'utente sta visualizzando e di attivare azioni sulla pagina.

- Integrare un agente AIsuru in una pagina web
- Passare il contenuto della pagina all'agente all'avvio della sessione
- Abilitare conversazioni contestuali legate alla pagina corrente
- Attivare azioni sul DOM dalle risposte dell'agente

**Ideale per:** Pagine interattive dove l'agente deve essere consapevole del contenuto visualizzato.

### Struttura del Progetto

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Pagina di selezione demo
│   │   └── demo1_controller.rb     # Demo 1: Agente per Controllare il Contenuto della Pagina
│   └── views/
│       ├── home/index.html.erb     # Selezione demo
│       └── demo1/index.html.erb    # Pagina Demo 1
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

# Visualizza i log
docker compose logs -f web

# Installa/aggiorna gem
docker compose run --rm web bundle

# Console Rails
docker compose run --rm web rails console
```

---

## Come Ottenere gli ID del Tuo Agente

Naviga al tuo agente in AIsuru, poi clicca su **Dev docs** nel menu laterale sinistro.

Espandi la sezione **▼ Altri riferimenti** per trovare:

| Campo | Descrizione | Esempio |
|-------|-------------|---------|
| **Memori (Agente) ID secondario** | ID agente per il web component | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
| **ID Utente proprietario** | ID dell'utente proprietario | `c3d4e5f6-a7b8-9012-cdef-123456789012` |

---

## Configurazione Base del Web Component

### Step 1: Includere il Web Component

Aggiungi queste due righe nel tuo HTML `<head>` o prima del tag di chiusura `</body>`:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Step 2: Configurare il Web Component

```html
<memori-client
  memoriName="NomeDelTuoAgente"
  ownerUserName="tuo.username"
  memoriID="IL_TUO_MEMORI_ID"
  ownerUserID="IL_TUO_OWNER_USER_ID"
  tenantID="www.aisuru.com"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://www.aisuru.com"
  layout="CHAT"
  uiLang="IT"
  spokenLang="IT"
  showLogin="true"
></memori-client>
```

---

## Passare il Contesto della Pagina all'Agente

Usa l'attributo `initialQuestion` per passare informazioni sulla pagina corrente all'agente all'avvio della sessione:

```html
<memori-client
  ...
  initialQuestion="L'utente sta visualizzando il seguente contenuto: [contenuto pagina]"
></memori-client>
```

Questo permette all'agente di rispondere a domande su ciò che l'utente vede senza che debba ripeterlo.

---

## Attivare Azioni sul DOM dalle Risposte dell'Agente

Il web component emette un evento `MemoriNewDialogState` ogni volta che l'agente risponde. Puoi ascoltare questo evento e analizzare speciali tag di output per attivare azioni sulla pagina:

```javascript
document.addEventListener('MemoriNewDialogState', (event) => {
  const emission = event.detail?.emission || '';
  const match = emission.match(/<output class="memori-test">([\s\S]*?)<\/output>/);
  if (!match) return;

  const actions = JSON.parse(match[1]);
  actions.forEach(action => {
    if (action === 'highlight_home_button') highlightHomeButton();
    if (action === 'show_alert') showAlert();
    if (action === 'flash_background_temp') flashBackground();
  });
});
```

L'agente emette tag di output strutturati contenenti array JSON di nomi di azioni, che il tuo JavaScript esegue.

---

## 📂 Struttura del Modulo

```
SYS-05-web-component-programming/
├── README.md          # Panoramica modulo
└── web_component/     # Demo app programmazione web component
    ├── README.md      # Guida completa (EN)
    ├── README-IT.md   # Questo file — guida completa (IT)
    └── demo/          # Applicazione Rails con demo web component
```

## Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Guida Funzioni Avanzate](https://docs.aisuru.com/advanced-functions)
- [Pacchetto NPM Web Component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

🏠 [Home del Corso](../../README.md)
