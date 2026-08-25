# Integrazione MCP Server

> Guida completa all'integrazione di server MCP (Model Context Protocol) con gli agenti AI AIsuru

## Panoramica

Questa guida spiega come connettere gli agenti AI AIsuru a sorgenti dati e servizi esterni tramite server MCP. Imparerai a:

- Connettere agenti a database MongoDB tramite MCP server integrato nella piattaforma
- Costruire server MCP personalizzati in Node.js per operazioni sul filesystem
- Esporre servizi locali pubblicamente usando tunnel ngrok
- Configurare le integrazioni MCP server nella piattaforma AIsuru

---

## Applicazione Demo

Questo modulo include **due applicazioni demo funzionanti** che mostrano diversi approcci all'integrazione di server MCP.

### Quick Start

```bash
# Naviga nella cartella demo
cd demo
```

Crea un file `.env` nella cartella `demo/` (solo la prima volta) con il seguente contenuto:

```
NGROK_AUTHTOKEN=il_tuo_token_qui
```

```bash
# Costruisci e avvia l'applicazione (comando unico)
npm run start

# Apri nel browser
open http://localhost:13006
```

> ℹ️ Il servizio `web` di questa demo è mappato sulla porta host **13006** (invece di 3000) per poter girare insieme alle altre demo. All'interno del container resta comunque sulla 3000.

### Avvio Demo con Un Click

Ogni pagina demo ha un pulsante **"Start demo"**: cliccandolo l'app ferma
automaticamente il tunnel ngrok delle altre demo (gli account ngrok gratuiti
permettono un solo tunnel attivo alla volta), avvia il container del tunnel
giusto e mostra il valore da incollare in AIsuru (connection string per la
Demo 1, URL MCP per le Demo 2/3), pronto da copiare. Il pulsante
**"Stop all tunnels"** spegne tutti i tunnel a fine esercitazione.

Niente terminale — la guida manuale passo-passo resta comunque disponibile in
ogni pagina demo come alternativa.

**Come funziona (nota di sicurezza):** l'app Rails parla con Docker attraverso
un socket proxy filtrato (`docker-socket-proxy` nel `docker-compose.yml`) che
espone solo le API di start/stop dei container; i nomi dei servizi sono
hardcoded in `app/controllers/infra_controller.rb` e nessun input utente arriva
mai a una riga di comando. Tieni i tunnel accesi solo mentre usi davvero una
demo: espongono i servizi della demo (con credenziali di esempio) su internet
pubblico.

### Demo Disponibili

#### Demo 1: MongoDB via MCP Server

Collega un agente AI AIsuru a un database MongoDB usando il server MCP integrato nella piattaforma.

**Cosa imparerai:**
- Eseguire MongoDB localmente con Docker
- Esporre MongoDB via TCP usando ngrok
- Configurare l'integrazione MCP server nella piattaforma AIsuru
- Interrogare dati in tempo reale conversando con il tuo agente

**Architettura:**
`AIsuru Agent → MCP Server (AIsuru) → ngrok TCP → MongoDB (Docker)`

**Prerequisiti:**
- Account ngrok e auth token
- MongoDB in esecuzione su Docker

#### Demo 3: Filesystem MCP Server

Collega un agente AI AIsuru a un server MCP personalizzato per operazioni sul filesystem.

**Cosa imparerai:**
- Costruire un server MCP personalizzato in Node.js
- Esporre operazioni sul filesystem tramite protocollo MCP
- Distribuire il server MCP con Docker Compose
- Vedere le modifiche ai file in tempo reale nel workspace

**Architettura:**
`AIsuru Agent → ngrok HTTPS → MCP Server (Node.js) → Shared Filesystem`

**Strumenti disponibili:**
- `list_files` - Elenca file e directory
- `read_file` - Legge il contenuto di un file
- `write_file` - Aggiorna file esistenti
- `create_file` - Crea nuovi file

**Prerequisiti:**
- Account ngrok e auth token
- Docker e Docker Compose

#### Demo 5: Agent come MCP

Esponi un agente AIsuru come server MCP tramite **AIsuru Agent Link**, poi fai in modo che un
secondo agente lo consumi come tool. Gli agenti coinvolti sono due: l'**Esperto** (agente A)
conosce una serie di cifre inventate delle policy ACME ed è esposto come server MCP;
l'**Assistente** (agente B) non ne conosce nessuna e ha istruzione di consultare l'Esperto
ogni volta che una domanda le tocca. La pagina della demo mostra le due chat affiancate, così
la risposta prima e dopo la connessione MCP si confronta direttamente.

**Cosa imparerai:**
- Generare i due token MCP di un agente
- Distinguere il token Consumer dal token Builder
- Registrare un server MCP custom su un secondo agente
- Vedere un agente modificare il prompt di un altro agente

**Architettura:**
`Agente Assistente → Server MCP (AIsuru Agent Link) → Agente Esperto`

**Prerequisiti:**
- Due agenti su AIsuru. Niente in locale: nessun database, nessun tunnel ngrok, nessun server
  MCP self-hosted. Tutto avviene dentro AIsuru, quindi qui il pulsante "Start demo" non serve.

I due system prompt pronti all'uso si trovano in [`agents/`](agents/) e sono anche scaricabili
dalla pagina stessa della demo, dato che i partecipanti al corso non hanno questo repository:

- `agents/esperto-policy-acme.md` — agente A, l'Esperto Policy Interne ACME
- `agents/assistente-onboarding.md` — agente B, l'Assistente Onboarding ACME

Le cifre dell'Esperto sono inventate di proposito: una normativa reale sarebbe già nota al
modello base e il confronto "prima e dopo" non dimostrerebbe nulla.

**I due tipi di token**

| Tipo di token | Cosa permette |
|---|---|
| Consumer | Interrogare l'agente come tool. Risponde, nient'altro cambia. |
| Builder | Tutto quello che permette il Consumer, **più** la modifica dell'agente, prompt incluso. |

Il token Builder contiene quello Consumer. Parti dal token più stretto e allargalo solo quando
il task lo richiede.

**Nota di sicurezza:** nessun token MCP raggiunge mai questa app Rails. Gli unici identificativi
che viaggiano nella querystring sono `memoriID` e `ownerUserID`, entrambi già pubblici in
qualsiasi embed del web component. Lo scambio dei token avviene direttamente tra i due agenti
dentro AIsuru.

### Struttura del Progetto

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Pagina di selezione demo
│   │   ├── demo1_controller.rb     # Demo 1: MongoDB MCP
│   │   └── demo3_controller.rb     # Demo 3: Filesystem MCP
│   └── views/
│       ├── home/index.html.erb     # Selezione demo
│       ├── demo1/index.html.erb    # Pagina Demo 1
│       └── demo3/index.html.erb    # Pagina Demo 3
├── docker/
│   └── mcp-server/                 # Server MCP Filesystem (Node.js)
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

## Prerequisiti

Prima di iniziare, hai bisogno di:

1. Un **account AIsuru** su [aisuru.com](https://www.aisuru.com)
2. Un **Agente AI (Memori)** configurato nel tuo account
3. Un **account ngrok** su [ngrok.com](https://ngrok.com)
4. **Docker** e **Docker Compose** installati

---

## Come Ottenere gli ID del Tuo Agente

1. Vai su [AIsuru](https://www.aisuru.com) e crea un agente (o usa il tuo tenant PaaS)
2. Apri il tuo agente e clicca su **Dev docs** nel menu laterale sinistro
3. Espandi la sezione **"▼ Altri riferimenti"**
4. Copia:
   - **Memori (Agente) ID secondario** → `memoriID`
   - **ID Utente proprietario** → `ownerUserID`

---

## Configurare ngrok

Entrambe le demo richiedono ngrok per esporre i servizi locali pubblicamente:

1. Crea un account su [ngrok.com](https://ngrok.com)
2. Ottieni il tuo auth token dalla [dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Aggiungi il token al file `.env` nella cartella `demo/`:
   ```
   NGROK_AUTHTOKEN=il_tuo_token_qui
   ```

Il modo più semplice per avviare il tunnel giusto è il pulsante **"Start demo"**
in ogni pagina demo. Equivalenti manuali (dalla cartella `demo/`):

**Per la Demo 1 (MongoDB):**
- `docker compose up -d ngrok-mongo` (tunnel TCP verso MongoDB; dashboard su http://localhost:4043)
- Usa host/porta TCP nella connection string MCP di AIsuru

**Per la Demo 2 (MySQL):**
- `docker compose up -d ngrok-demo2` (tunnel TCP verso MySQL; dashboard su http://localhost:4044)
- Usa host/porta TCP come `MYSQL_HOST` / `MYSQL_PORT` nel server MCP MySQL integrato di AIsuru

**Per la Demo 3 (Filesystem):**
- `docker compose up -d ngrok-mcp` (dashboard su http://localhost:4041)
- Usa l'URL HTTPS + endpoint `/mcp` in AIsuru

⚠️ Gli account ngrok gratuiti permettono **un solo tunnel attivo alla volta**:
prima ferma gli altri tunnel con `docker compose stop ngrok-mongo ngrok-mcp ngrok-demo2`.

---

## Configurare il Server MCP in AIsuru

Questo passaggio serve **sempre**, qualunque strada tu abbia seguito per avviare
la demo: il bottone "Start demo" (o la guida manuale) alza solo il tunnel, non
può configurare nulla dentro il tuo agente.

Vai nelle impostazioni del tuo agente in AIsuru, poi nella sezione
**MCP Servers**. Cosa fare dipende dalla demo:

**Demo 1 e 2 — server integrati.** MongoDB e MySQL sono già inclusi in AIsuru:
scegli il server pronto dalla lista e compila i parametri di connessione.
- Demo 1 (MongoDB): connection string
  `mongodb://admin:adminpassword@<NGROK_HOST>:<NGROK_PORT>/mcp_demo?authSource=admin`,
  database `mcp_demo`
- Demo 2 (MySQL): `MYSQL_HOST` / `MYSQL_PORT` dal tunnel TCP,
  `MYSQL_USER=mcpuser`, `MYSQL_PASS=mcppassword`, `MYSQL_DB=mcp_demo_mysql`.
  Lascia `ALLOW_INSERT/UPDATE/DELETE/DDL_OPERATION` disattivati finché non vuoi
  che l'agente scriva.

**Demo 3 — server personalizzato.** Il server MCP filesystem è tuo, quindi non
compare nel catalogo: usa la sezione **"Aggiungi MCP Personalizzato"** e incolla
lì la stringa `https://tuo-url-ngrok/mcp`, endpoint `/mcp` compreso.

Salva e testa la connessione conversando con il tuo agente.

---

## 📂 Struttura del Modulo

```
SYS-06-mcp-server-integration/
├── README.md          # Panoramica modulo (EN)
├── README-IT.md       # Panoramica modulo (IT)
└── manage-server-mcp/ # Demo app integrazione MCP server
    ├── README.md      # Guida completa (EN)
    ├── README-IT.md   # Questo file — guida completa (IT)
    └── demo/          # Applicazione Rails con demo MCP
```

## Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Specifica Protocollo MCP](https://modelcontextprotocol.io/)
- [Documentazione ngrok](https://ngrok.com/docs)
- [Pacchetto NPM Web Component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

🏠 [Home del Corso](../../README.md)
