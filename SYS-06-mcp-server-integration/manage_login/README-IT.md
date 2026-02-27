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
open http://localhost:3000
```

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
│   ├── mcp-server/                 # Server MCP Filesystem (Node.js)
│   └── mcp-server-mysql/           # Server MCP MySQL (Node.js)
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

**Per la Demo 1 (MongoDB):**
- Tunnel TCP ngrok: `ngrok tcp 27017`
- Usa l'URL TCP nella configurazione MCP di AIsuru

**Per la Demo 3 (Filesystem):**
- ngrok viene avviato automaticamente tramite docker-compose
- Controlla l'URL su http://localhost:4041
- Usa l'URL HTTPS + endpoint `/mcp` in AIsuru

---

## Configurare il Server MCP in AIsuru

Dopo aver avviato la demo, configura il server MCP nella piattaforma AIsuru:

1. Vai nelle impostazioni del tuo agente in AIsuru
2. Naviga nella sezione **MCP Servers**
3. Clicca **+ Aggiungi MCP Server**
4. Inserisci l'URL ngrok per la demo corrispondente:
   - Demo 1: `tcp://tuo-url-ngrok:porta` (MongoDB)
   - Demo 3: `https://tuo-url-ngrok/mcp` (Filesystem)
5. Salva e testa la connessione conversando con il tuo agente

---

## 📂 Struttura del Modulo

```
SYS-06-mcp-server-integration/
├── README.md          # Panoramica modulo (EN)
├── README-IT.md       # Panoramica modulo (IT)
└── manage_login/      # Demo app integrazione MCP server
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
