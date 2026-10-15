# Integrazione MCP Server

Guida al collegamento degli agenti AIsuru a fonti dati e servizi esterni tramite MCP server (Model Context Protocol).

[English version](./README.md)

## Panoramica

Questa guida copre:

- Il collegamento di un agente a MongoDB e MySQL tramite gli MCP server integrati in AIsuru
- L'uso dei server di piattaforma che non richiedono infrastruttura propria (Scheduler, Persistence, Skills, Agent Link, Vibe Coder, Outlook)
- La costruzione di un MCP server personalizzato in Node.js e il suo deploy con Docker Compose
- La trasformazione di una REST API esistente in tool dell'agente con il connettore OAuth/API
- L'esposizione pubblica di servizi locali con i tunnel ngrok
- La configurazione delle integrazioni MCP nella piattaforma AIsuru

---

## Applicazione demo

Il modulo include un'applicazione Rails con otto demo.

### Avvio rapido

```bash
cd demo
```

La prima volta crea un file `.env` nella cartella `demo/` con questo contenuto:

```
NGROK_AUTHTOKEN=il_tuo_token
```

```bash
# Compila e avvia l'applicazione
npm run start

# Apri il browser
open http://localhost:13006
```

Il servizio `web` è mappato sulla porta 13006 invece che sulla 3000, così questa demo può girare insieme alle altre. Dentro il container ascolta comunque sulla 3000.

### Avvio della demo con un clic

Ogni demo che richiede un tunnel ha un pulsante **"Avvia demo"**: ferma il tunnel di qualsiasi altra demo (gli account ngrok gratuiti consentono un tunnel attivo alla volta), avvia il container del tunnel giusto e mostra il valore da incollare in AIsuru, pronto da copiare. Quel valore è la connection string per la Demo 1, l'URL MCP per le Demo 2 e 3, i parametri del connettore per la Demo 6. Un pulsante **"Ferma tutti i tunnel"** chiude tutto quando hai finito.

Non serve il terminale. La guida manuale passo passo resta disponibile in ogni pagina come fallback.

**Come funziona, e perché è sicuro:** l'app Rails parla con Docker attraverso un socket proxy filtrato (`docker-socket-proxy` in `docker-compose.yml`) che espone solo le API di start e stop dei container. I nomi dei servizi sono cablati in `app/controllers/infra_controller.rb` e nessun input utente arriva mai a una riga di comando. Tieni i tunnel attivi solo mentre stai davvero usando una demo: espongono i servizi della demo, con credenziali da demo, su internet pubblica.

### Demo disponibili

| Demo | Cosa collega | Infrastruttura locale |
|------|--------------|-----------------------|
| 1 | MongoDB tramite l'MCP server integrato | Docker + ngrok TCP |
| 2 | MySQL tramite l'MCP server integrato | Docker + ngrok TCP |
| 3 | Un MCP server filesystem personalizzato in Node.js | Docker + ngrok HTTPS |
| 4 | MCP Scheduler e MCP Persistence | Nessuna |
| 5 | Un agente esposto a un altro tramite Agent Link | Nessuna |
| 6 | Una REST API tramite il connettore OAuth/API | Docker + ngrok HTTPS |
| 7 | Outlook, Vibe Coder e Persistence su un solo agente | Nessuna |
| 8 | Una skill tramite MCP Skills | Nessuna |

#### Demo 1: MongoDB via MCP server

Collega un agente a un database MongoDB usando l'MCP server integrato nella piattaforma.

**Cosa imparerai:**
- Far girare MongoDB in locale con Docker
- Esporre MongoDB via TCP con ngrok
- Configurare l'integrazione MCP in AIsuru
- Chattare con l'agente interrogando dati reali

**Architettura:** `Agente AIsuru → MCP Server (AIsuru) → ngrok TCP → MongoDB (Docker)`

**Prerequisiti:** account ngrok e auth token, MongoDB in esecuzione in Docker.

#### Demo 2: MySQL via MCP server

Stessa idea della Demo 1 su un database diverso, più la scrittura. Non c'è nulla da scrivere o distribuire: l'MCP server MySQL è integrato in AIsuru. Attivati gli switch di scrittura, l'agente può anche inserire, aggiornare ed eliminare righe.

**Cosa imparerai:**
- Far girare MySQL con Docker
- Esporre MySQL con un tunnel TCP ngrok
- Compilare i parametri dell'MCP server MySQL integrato
- Attivare la scrittura e vedere l'agente modificare i dati

**Architettura:** `Agente AIsuru → MCP MySQL integrato (AIsuru) → ngrok TCP → MySQL (Docker)`

**Prerequisiti:** account ngrok e auth token, Docker.

#### Demo 3: Filesystem MCP server

Collega un agente a un MCP server filesystem scritto da te, per operazioni sui file.

**Cosa imparerai:**
- Costruire un MCP server personalizzato in Node.js
- Esporre operazioni sul filesystem via protocollo MCP
- Distribuire l'MCP server con Docker Compose
- Vedere i file cambiare nel workspace condiviso

**Architettura:** `Agente AIsuru → ngrok HTTPS → MCP Server (Node.js) → filesystem condiviso`

**Tool esposti:**
- `list_files`, elenca file e directory
- `read_file`, legge il contenuto di un file
- `write_file`, aggiorna un file esistente
- `create_file`, crea un nuovo file

**Prerequisiti:** account ngrok e auth token, Docker e Docker Compose.

#### Demo 4: MCP Scheduler + MCP Persistence

Due MCP server di piattaforma, senza nulla da ospitare: **MCP Scheduler** esegue una chiamata a tool più tardi, su pianificazione, e **MCP Persistence** conserva dati strutturati tra i turni e tra le sessioni.

**Cosa imparerai:**
- Pianificare una chiamata a tool ricorrente, fino a un minuto di intervallo
- Conservare dati strutturati fuori dalla cronologia della conversazione
- Rileggere i dati salvati, sia tramite l'agente sia dalla dashboard di Persistence

**Architettura:** `Agente AIsuru → MCP Scheduler (AIsuru) + MCP Persistence (AIsuru)`

**Prerequisiti:** un agente su AIsuru. Nulla in locale.

**Perché non c'è la chat embedded:** un task pianificato scatta minuti o ore dopo, e a quel punto gli serve comunque una conversazione da raggiungere e uno store su cui scrivere. Serve quindi l'identità stabile e autenticata della chat dell'agente su AIsuru. Un web component embedded in una pagina pubblica è una sessione usa e getta, che potrebbe non esserci più quando il task parte: per questo la demo gira dentro AIsuru. La pagina contiene il setup e il prompt da provare.

Chiedi all'agente un task ricorrente che salvi ogni risultato con il tool di persistence, poi ricarica la dashboard di Persistence: il valore salvato cambia da solo, senza che nessuno stia chattando.

#### Demo 5: Agent come MCP

Espone un agente AIsuru come MCP server tramite **AIsuru Agent Link**, poi lo fa consumare come tool da un secondo agente. Gli agenti coinvolti sono due: l'**Esperto** (agente A) conosce una serie di valori inventati della policy ACME ed è esposto come MCP server, l'**Assistente** (agente B) non ne conosce nessuno e ha istruzione di consultare l'Esperto ogni volta che una domanda li riguarda. La pagina della demo mostra le due chat affiancate, così la risposta prima e dopo il collegamento MCP si confronta direttamente.

**Cosa imparerai:**
- Generare i due token MCP di un agente
- Distinguere il token Consumer da quello Builder
- Registrare un MCP server personalizzato su un secondo agente
- Vedere un agente modificare il prompt di un altro agente

**Architettura:** `Agente Assistente → MCP Server (AIsuru Agent Link) → Agente Esperto`

**Prerequisiti:** due agenti su AIsuru. Nulla in locale: nessun database, nessun tunnel ngrok, nessun MCP server self-hosted. Tutto avviene dentro AIsuru, quindi qui il pulsante "Avvia demo" non si applica.

I due prompt di sistema pronti si trovano in [`agents/`](agents/) e sono serviti come download anche dalla pagina della demo, dato che i partecipanti al corso non hanno questo repository:

- `agents/esperto-policy-acme.md`, agente A, l'esperto di policy interne ACME
- `agents/assistente-onboarding.md`, agente B, l'assistente onboarding ACME

I valori dell'Esperto sono inventati di proposito: una normativa reale sarebbe già nota al modello di base, e il confronto prima/dopo non dimostrerebbe nulla.

**I due tipi di token**

| Tipo di token | Cosa consente |
|---|---|
| Consumer | Interrogare l'agente come tool. Risponde, nient'altro cambia. |
| Builder | Tutto ciò che consente il Consumer, più la modifica dell'agente, prompt incluso. |

Il token Builder contiene quello Consumer. Parti dal token più stretto e allargalo solo quando il compito lo richiede.

**Nota di sicurezza:** nessun token MCP arriva mai a questa app Rails. Gli unici identificativi dell'agente che viaggiano nella querystring sono `memoriID` e `ownerUserID`, entrambi già pubblici in qualsiasi embed del web component. Tutto lo scambio di token avviene direttamente fra i due agenti dentro AIsuru.

#### Demo 6: Connettore OAuth / API

Collega una HTTP/REST API esistente a un agente senza scrivere una riga di codice. Punti il connettore a una specifica OpenAPI e ogni endpoint diventa un tool, con il token OAuth2 richiesto, messo in cache e rinnovato al posto tuo.

**Cosa imparerai:**
- Far girare in Docker una REST API con OAuth2 client credentials
- Esporla in HTTPS con ngrok
- Importare tutti gli endpoint dalla specifica OpenAPI, senza scrivere JSON a mano
- Vedere l'agente leggere i dati e riscriverli

**Architettura:** `Agente AIsuru → connettore OAuth/API → ngrok HTTPS → gestionale FastAPI (Docker)`

**Porte:** il gestionale FastAPI ascolta sulla `8100`, la dashboard del suo tunnel ngrok è sulla `4045`.

**Dati datati:** le date di seed sono calcolate alla prima creazione del database, e il volume `gestionale_data` sopravvive ai riavvii. Se il container è su da settimane, "questo mese" e "in ritardo" risulteranno sbagliati. Usa il pulsante **Reset** su `/demo6` (oppure `docker compose down -v`) per rigenerare date fresche prima della lezione.

**Prerequisiti:** account ngrok e auth token, Docker e Docker Compose.

#### Demo 7: Dall'email all'app

Tre MCP server su un solo agente: **Outlook MCP Server** legge la casella di posta, **AIsuru Vibe Coder** genera un'app HTML/JavaScript autonoma e **MCP Persistence** tiene la libreria dei progetti. Il partecipante non scrive né codice né prompt: manda una email e riceve un'applicazione.

**Cosa imparerai:**
- Combinare tre MCP server su un singolo agente
- Leggere una casella di posta reale con l'Outlook MCP Server
- Generare un'app HTML/JavaScript autonoma con AIsuru Vibe Coder
- Salvare ed elencare i progetti generati con MCP Persistence

**Architettura:** `Email → Outlook MCP Server → AIsuru Vibe Coder → MCP Persistence → app generata`

**Prerequisiti:** un agente su AIsuru. Nulla in locale oltre alla pagina Rails: nessun servizio Docker e nessun tunnel ngrok, come nelle Demo 4 e 5.

**Setup:**
- Crea un agente.
- Aggiungi `Outlook MCP Server` (richiede `ms-tenant-id` e `ms-client-id`, forniti da chi tiene il corso).
- Aggiungi `AIsuru Vibe Coder`.
- Aggiungi `MCP Persistence`.
- Scarica dalla pagina il prompt di sistema pronto e incollalo in Agente, Personalizzazione, Prompt.
- Apri la chat dell'agente su AIsuru, autenticato come suo proprietario.

**Perché non c'è la chat embedded:** l'Outlook MCP Server attiva di default `IDENTITY_STRICT_MAILBOX`, che limita l'accesso alla casella all'account AIsuru proprietario dell'agente. Un visitatore che arriva da un web component embedded è un'identità diversa, quindi ogni chiamata alla casella viene rifiutata. È la protezione che funziona, non una configurazione sbagliata. La Demo 7 tiene quindi il flag attivo ed esegue tutta la sequenza dentro AIsuru; la pagina contiene il setup, i due download e i messaggi da incollare.

**Sequenza, in ordine:**
1. Inizializza la libreria dei progetti.
2. Collega la casella di posta.
3. Completa l'accesso Microsoft.
4. Manda a quella casella l'email di progetto scaricabile.
5. Chiedi all'agente di leggere le ultime 3 email e costruire ciò che trova.
6. Chiedi cosa c'è nella libreria.

Ogni messaggio della sequenza va incollato nella chat dell'agente su AIsuru.

`MCP Scheduler` qui non è usato di proposito. Potrebbe controllare la casella a intervalli regolari, ma quel pattern è trattato a parte nella Demo 4.

I due download pronti si trovano in [`agents/`](agents/) e sono serviti anche dalla pagina della demo, alla rotta `demo7/asset/:kind`:

- `agents/vibe-project-builder.md`, il prompt di sistema da incollare nell'agente
- `agents/email-flowsales-crm.md`, l'email di progetto da mandare alla casella

#### Demo 8: MCP Skills

Collega una **skill** a un agente: un file markdown che descrive esattamente come gestire un tipo di richiesta, caricato all'occorrenza invece di essere cablato nel prompt di sistema. La demo è un prima e dopo sullo stesso messaggio di un cliente.

**Cosa imparerai:**
- Creare e registrare una skill sull'MCP Skills server
- Richiamare la skill nel prompt di sistema dell'agente, così che sappia quando usarla
- Confrontare la risposta dell'agente prima e dopo la skill

**Architettura:** `Agente AIsuru → MCP Skills (AIsuru)`

**Prerequisiti:** un agente su AIsuru. Nulla in locale.

**Sequenza:** carica l'agente nella pagina e manda il messaggio del cliente (una richiesta di reso) senza alcuna skill attiva, poi aggiungi il server `MCP Skills`, apri la sua dashboard, crea una nuova skill con "Modifica come SKILL.md" e incolla il file scaricato dalla pagina. Aggiungi in Agente, Personalizzazione, Prompt una sezione che dica all'agente di applicare la skill sulle richieste di rimborso, ricarica l'agente e manda di nuovo lo stesso messaggio.

Creare la skill non basta: senza la riga nel prompt di sistema la skill non viene mai richiamata e la risposta resta quella generica.

La skill si trova in [`agents/skill-refund-response.md`](agents/skill-refund-response.md); la pagina serve il blocco fenced di quel file alla rotta `demo8/skill/:kind`, così ciò che il partecipante scarica si incolla direttamente in AIsuru.

### Struttura del progetto

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Pagina di selezione delle demo
│   │   ├── demo1_controller.rb     # ... un controller per demo, da demo1 a demo8
│   │   └── infra_controller.rb     # Pulsante "Avvia demo": avvia e ferma i tunnel
│   └── views/
│       ├── home/index.html.erb     # Selezione delle demo
│       ├── demo1/ ... demo8/       # Una pagina per demo
│       └── shared/                 # Partial di setup riusati fra le demo
├── docker/
│   ├── mcp-server/                 # Demo 3: MCP server filesystem (Node.js)
│   ├── gestionale/                 # Demo 6: API FastAPI con OAuth2
│   ├── mongo-init/                 # Demo 1: dati di seed MongoDB
│   └── mysql-init/                 # Demo 2: dati di seed MySQL
├── docker-compose.yml              # web, database, mcp-server, gestionale, tunnel ngrok, socket proxy
├── Dockerfile.dev
└── Gemfile
```

La cartella `agents/` sta accanto a `demo/` ed è montata in sola lettura dentro il container: è così che le pagine delle demo 5, 7 e 8 servono i loro download.

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

## Prerequisiti

1. Un account AIsuru su [aisuru.com](https://www.aisuru.com)
2. Un agente (memori) configurato in quell'account, due per la Demo 5
3. Un account [ngrok](https://ngrok.com), per le demo 1, 2, 3 e 6
4. Docker e Docker Compose installati

---

## Come ottenere gli ID dell'agente

1. Vai su [AIsuru](https://www.aisuru.com) e crea un agente
2. Apri l'agente e clicca **Dev docs** nella barra laterale a sinistra
3. Espandi la sezione **Altri riferimenti** ("Other references" nell'interfaccia in inglese)
4. Copia:
   - Secondary Memori (Agent) ID, usato come `memoriID`
   - Owner user ID, usato come `ownerUserID`

---

## Configurare ngrok

Le demo 1, 2, 3 e 6 hanno bisogno di ngrok per esporre pubblicamente un servizio locale. Le demo 4, 5, 7 e 8 no.

1. Crea un account su [ngrok.com](https://ngrok.com)
2. Prendi l'auth token dalla [dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Aggiungilo al file `.env` nella cartella `demo/`:
   ```
   NGROK_AUTHTOKEN=il_tuo_token
   ```

Il modo più semplice per avviare il tunnel giusto è il pulsante **"Avvia demo"** nella pagina della demo. Gli equivalenti manuali, dalla cartella `demo/`:

**Demo 1 (MongoDB):**
- `docker compose up -d ngrok-mongo` (tunnel TCP verso MongoDB, dashboard su http://localhost:4043)
- Usa host e porta TCP nella connection string MCP di AIsuru

**Demo 2 (MySQL):**
- `docker compose up -d ngrok-demo2` (tunnel TCP verso MySQL, dashboard su http://localhost:4044)
- Usa host e porta TCP come `MYSQL_HOST` e `MYSQL_PORT` nell'MCP server MySQL integrato

**Demo 3 (filesystem):**
- `docker compose up -d ngrok-mcp` (dashboard su http://localhost:4041)
- Usa l'URL HTTPS più l'endpoint `/mcp` in AIsuru

**Demo 6 (connettore OAuth / API):**
- `docker compose up -d ngrok-gestionale` (tunnel HTTP verso il gestionale FastAPI, dashboard su http://localhost:4045)
- Usa l'URL HTTPS come URL della specifica OpenAPI del connettore

Gli account ngrok gratuiti consentono un tunnel attivo alla volta: ferma prima gli altri con `docker compose stop ngrok-mongo ngrok-mcp ngrok-demo2 ngrok-gestionale`.

---

## Configurare gli MCP server in AIsuru

Questo passaggio serve sempre, comunque tu abbia avviato la demo: il pulsante "Avvia demo", come la guida manuale, tira su solo il tunnel. Non può registrare nulla nel tuo agente.

Apri le impostazioni dell'agente in AIsuru e vai nella sezione **MCP**. Cosa fare dipende dalla demo.

**Server integrati, dal catalogo.** MongoDB, MySQL, Scheduler, Persistence e Skills sono inclusi in AIsuru: scegli il server dalla lista e compila i dati di connessione, quando ne ha.

- Demo 1 (MongoDB): connection string `mongodb://admin:adminpassword@<NGROK_HOST>:<NGROK_PORT>/mcp_demo?authSource=admin`, database `mcp_demo`
- Demo 2 (MySQL): `MYSQL_HOST` e `MYSQL_PORT` dal tunnel TCP, `MYSQL_USER=mcpuser`, `MYSQL_PASS=mcppassword`, `MYSQL_DB=mcp_demo_mysql`. Lascia spenti `ALLOW_INSERT/UPDATE/DELETE/DDL_OPERATION` finché non vuoi che l'agente scriva.
- Demo 4 (Scheduler e Persistence) e Demo 8 (Skills): non c'è nulla da compilare, aggiungili e salva.

**Server personalizzato (Demo 3).** L'MCP server filesystem è tuo, quindi non è nel catalogo: usa **Aggiungi MCP Personalizzato** e incolla l'URL `https://tuo-url-ngrok/mcp`, endpoint `/mcp` incluso.

**Agent Link (Demo 5).** Sull'agente Esperto collega **AIsuru Agent Link** e clicca **Create MCP**, poi apri la sua dashboard, crea un token Consumer e copialo insieme all'endpoint MCP pubblico. Sull'agente Assistente registra quell'endpoint e quel token come MCP server personalizzato.

**Connettore OAuth/API (Demo 6).** Qui non costruisci né distribuisci alcun MCP server: l'API del gestionale entra tramite il connettore, che importa la specifica OpenAPI e genera l'MCP server al posto tuo. Una volta salvato compare fra gli MCP server dell'agente, con un tool per ogni endpoint importato. Compila questi sei parametri, che la pagina `/demo6` mostra già pronti da copiare:

| Parametro | Valore |
|---|---|
| `oauth_auth_type` | `oauth2_client_credentials` |
| `oauth_token_url` | `<URL ngrok>/token` |
| `oauth_client_id` | `aisuru-demo` |
| `oauth_client_secret` | `demo-secret-sys06` |
| `oauth_scope` | `commesse:read` |
| `oauth_openapi_url` | `<URL ngrok>/openapi.json` |

**Tre server su un agente (Demo 7).** Aggiungi allo stesso agente `Outlook MCP Server` (con `ms-tenant-id` e `ms-client-id`), `AIsuru Vibe Coder` e `MCP Persistence`.

Salva e prova la connessione chattando con il tuo agente.

---

## Struttura del modulo

```
SYS-06-mcp-server-integration/
└── manage-server-mcp/ # Demo app integrazione MCP server
    ├── README.md      # Guida completa (EN)
    ├── README-IT.md   # Questo file, guida completa (IT)
    ├── agents/        # Prompt e asset scaricati dalle demo 5, 7 e 8
    ├── img/           # Screenshot usati nella guida
    └── demo/          # Applicazione Rails, demo da 1 a 8
```

## Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Specifica del protocollo MCP](https://modelcontextprotocol.io/)
- [Documentazione ngrok](https://ngrok.com/docs)
- [Pacchetto NPM del web component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

[Home del corso](../../README-IT.md)
