# AIsuru AI System Integrator Course Resources

Materiale di formazione per il programma di certificazione AIsuru System Integrator di [Memori.ai](https://memori.ai).

[![AIsuru](https://img.shields.io/badge/Piattaforma-AIsuru-blue)](https://www.aisuru.com)
[![Docs](https://img.shields.io/badge/Docs-docs.aisuru.com-green)](https://docs.aisuru.com)
[![AI Act Compliant](https://img.shields.io/badge/EU%20AI%20Act-Conforme-success)](https://www.aisuru.com)

[English version](./README.md)

## Iscrizioni

Le iscrizioni non sono ancora aperte. Il link al catalogo corsi sarà pubblicato qui.

## Il corso

Il corso è rivolto a sviluppatori, software engineer e tecnici che vogliono certificarsi come System Integrator per [AIsuru](https://www.aisuru.com), la piattaforma di AI conversazionale sviluppata da [Memori.ai](https://memori.ai).

### Cosa imparerai

- Integrare agenti AI in applicazioni e workflow aziendali
- Collegare AIsuru ai sistemi aziendali esistenti (CRM, ERP, database, API)
- Implementare flussi di autenticazione (SSO, Microsoft Auth, OAuth, JWT)
- Costruire integrazioni con MCP server e funzioni avanzate
- Installare e configurare soluzioni AIsuru PaaS
- Applicare pratiche di sicurezza ai deployment in produzione

### A chi è rivolto

- Sviluppatori backend e frontend
- Software architect
- DevOps engineer
- Consulenti tecnici
- Personale IT che lavora su integrazioni AI

## Moduli del corso

| Codice | Modulo | Durata | Argomenti |
|--------|--------|--------|-----------|
| **SYS-01** | Principi di System Integration | 2h | Strategie di integrazione AI, fonti dati, limiti della RAG, database vettoriali |
| **SYS-02** | Integrazione Frontend e Backend | 2h | Web component, API REST, embedding, casi d'uso |
| **SYS-03** | Autenticazione Aziendale | 2h | SSO, Microsoft Auth, OAuth, JWT, autenticazione embedded |
| **SYS-04** | Funzioni Avanzate | 2h | Servizi REST/GRPC/JSONRPC, Swagger, Gateway MCP |
| **SYS-05** | Programmazione Web Component | 2h | Dialog API, UI personalizzata, integrazione frontend |
| **SYS-06** | Integrazione MCP Server | 3h | Tool, resource, prompt, MCP server personalizzati |
| **SYS-07** | Integrazione Automazioni | 2h | Automazione workflow, orchestrazione API, casi studio |
| **SYS-08** | Best Practice Pre-Release | 2h | Sicurezza, Red Teaming, audit logging, conformità GDPR |
| **SYS-09** | Workshop Pratico | 1h | Esercitazioni pratiche e scenari reali |

**Formato:** 3 giornate da 6 ore (webinar online), più 1 giornata di workshop live.

## Struttura del repository

```
system-integrator-course-resources/
├── SYS-03-integrating-enterprise-authentication/
│   └── manage_login/            # Demo app autenticazione
│       ├── README.md            # Guida completa (EN)
│       ├── README-IT.md         # Guida completa (IT)
│       ├── img/                 # Screenshot usati nella guida
│       └── demo/                # App Rails, demo 1-4
├── SYS-04-advanced-functions/
│   └── manage_functions/        # Demo app funzioni avanzate
│       ├── README.md            # Guida completa (EN)
│       ├── README-IT.md         # Guida completa (IT)
│       └── demo/                # App Rails, demo 1-2
├── SYS-05-web-component-programming/
│   ├── README.md                # Panoramica del modulo (EN)
│   ├── README-IT.md             # Panoramica del modulo (IT)
│   └── web_component/           # Demo app web component / Dialog API
│       ├── README.md            # Guida completa (EN)
│       ├── README-IT.md         # Guida completa (IT)
│       └── demo/                # App Rails, demo 1
├── SYS-06-mcp-server-integration/
│   └── manage-server-mcp/       # Demo app integrazione MCP server
│       ├── README.md            # Guida completa (EN)
│       ├── README-IT.md         # Guida completa (IT)
│       ├── agents/              # Prompt di sistema e asset per le demo 5, 7, 8
│       ├── img/                 # Screenshot usati nella guida
│       └── demo/                # App Rails, demo 1-8
├── index.html                   # Hub delle demo aperto dai launcher
├── start-all.js, stop-all.js    # Script dietro npm run start:all e stop:all
├── avvia.bat, ferma.bat         # Launcher a doppio clic per Windows
├── avvia.command, ferma.command # Launcher a doppio clic per macOS
├── README.md                    # Versione inglese
└── README-IT.md                 # Questo file
```

## Prerequisiti

- Conoscenza base di sviluppo web (HTML, CSS, JavaScript)
- Familiarità con le API REST e con HTTP
- Comprensione dei concetti di autenticazione (OAuth 2.0, JWT, SSO)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installato: include Docker Engine e Docker Compose, richiesti da tutte le demo
- [Node.js](https://nodejs.org/) installato: serve per `npm run start` in ogni demo e per il launcher `npm run start:all` nella root del repository
- Un editor di codice (VS Code consigliato)

## Come iniziare

### Avvio rapido con un doppio clic

Se non hai dimestichezza con il terminale, dopo aver scaricato il repository fai doppio clic sul file adatto al tuo computer, nella cartella principale:

| Sistema | Avvia le demo | Ferma le demo |
|---------|---------------|---------------|
| Windows | `avvia.bat` | `ferma.bat` |
| macOS | `avvia.command` | `ferma.command` |

Il launcher controlla che Node.js e Docker Desktop siano installati, avvia Docker Desktop se è spento, prepara tutte le demo e apre l'hub con l'elenco. La prima volta può richiedere una decina di minuti: basta non chiudere la finestra finché non compare "Tutto pronto". Le demo restano attive anche dopo aver chiuso la finestra.

Al primo avvio il sistema operativo può chiedere una conferma:

- Su Windows, se compare un avviso di sicurezza, clicca *Ulteriori informazioni*, poi *Esegui comunque*.
- Su macOS, se compare *"impossibile aprire perché proviene da uno sviluppatore non identificato"*, fai clic destro sul file, poi *Apri*, poi di nuovo *Apri*. Serve solo la prima volta.

Se qualcosa non funziona, nella stessa cartella trovi il file `avvio.log` con i dettagli tecnici da allegare a una segnalazione.

### Avvio da terminale

1. Clona il repository:
   ```bash
   git clone https://github.com/memori-ai/system-integrator-course-resources.git
   cd system-integrator-course-resources
   ```

2. Avvia una singola demo dalla sua cartella `demo/`:
   ```bash
   cd SYS-06-mcp-server-integration/manage-server-mcp/demo
   npm run start
   ```

3. Oppure avviale tutte insieme, ognuna sulla propria porta:
   ```bash
   npm run start:all
   ```
   Il comando compila e avvia SYS-03, SYS-04, SYS-05 e SYS-06 in background, poi apre l'hub delle demo (`index.html`) nel browser predefinito. Funziona allo stesso modo su macOS, Linux e Windows, e richiede [Node.js](https://nodejs.org/) oltre a Docker.

4. Ferma tutto con:
   ```bash
   npm run stop:all
   ```

Ogni modulo ha la propria guida con la configurazione lato piattaforma (credenziali agente, MCP server, tunnel). Leggila prima di avviare la demo.

### Porte delle demo

| Modulo | URL |
|--------|-----|
| SYS-03 Autenticazione Aziendale | http://localhost:13000 |
| SYS-04 Funzioni Avanzate | http://localhost:13004 |
| SYS-05 Programmazione Web Component | http://localhost:13005 |
| SYS-06 Integrazione MCP Server | http://localhost:13006 |

Le porte sono diverse da quella di default di Rails (3000) così che tutte le demo possano girare insieme.

## Dettaglio dei moduli

### SYS-01: Principi di System Integration

- Servizi da integrare e censimento delle fonti dati
- Come fornire contesto all'AI e cosa implicano gli internals per la strategia di integrazione
- Accessibilità dei dati e frequenza di aggiornamento
- Limiti della RAG (Retrieval Augmented Generation) e dei database vettoriali

### SYS-02: Integrazione Frontend e Backend

- Panoramica del web component e tecniche di embedding
- Capacità delle API e pattern di integrazione
- Casi d'uso enterprise

### SYS-03: Autenticazione Aziendale

Come collegare i sistemi di autenticazione aziendali agli agenti AIsuru. Il modulo include una demo Rails con quattro approcci:

| Demo | Metodo di autenticazione | Descrizione |
|------|--------------------------|-------------|
| **Demo 1** | Login autonomo | Il web component gestisce da solo il login con `showLogin="true"`, senza backend |
| **Demo 2** | Auth programmatica (LoginWithJWT) | Il backend autentica l'utente tramite la Trusted App API |
| **Demo 3** | Microsoft SSO (Azure AD / Entra ID) | Integrazione con Microsoft identity platform tramite MSAL.js |
| **Demo 4** | Login con redirect | L'utente si autentica localmente, poi arriva su AIsuru con un magic link |

Obiettivi di apprendimento:

- Aggiungere l'autenticazione a un web component AIsuru embedded
- Usare l'API `LoginWithJWT` per l'autenticazione programmatica
- Configurare una Trusted Application per le chiamate backend-to-backend
- Configurare Microsoft Azure AD / Entra ID SSO
- Costruire flussi di autenticazione con redirect

Prerequisiti: basi di OAuth 2.0, JWT e SSO; Docker installato.

Risorse del modulo: [SYS-03](./SYS-03-integrating-enterprise-authentication/manage_login/README-IT.md)

### SYS-04: Funzioni Avanzate

Come scrivere funzioni avanzate che collegano gli agenti AIsuru a REST API esterne. Il modulo include una demo Rails con due approcci:

| Demo | Tipo di funzione | Descrizione |
|------|------------------|-------------|
| **Demo 1** | Integrazione Weather API | Collega un agente a un servizio REST con una funzione webhook e variabili template |
| **Demo 2** | Import OpenAPI/Swagger | Genera più funzioni insieme da una specifica Swagger/OpenAPI |

Obiettivi di apprendimento:

- Creare funzioni avanzate in AIsuru e configurarne l'URL webhook
- Configurare integrazioni webhook con REST API esterne
- Importare file OpenAPI/Swagger per generare funzioni
- Collegare le funzioni a un agente e configurarne l'uso
- Fare debug e verificare le chiamate alle funzioni in conversazione
- Gestire parametri e risposte delle funzioni
- Applicare pratiche di design delle funzioni e gestione degli errori

Prerequisiti: basi di REST API e metodi HTTP; familiarità con il web component AIsuru (SYS-03); accesso alla piattaforma AIsuru e credenziali agente; basi di JSON; Docker installato.

Risorse del modulo: [SYS-04](./SYS-04-advanced-functions/manage_functions/README-IT.md)

### SYS-05: Programmazione Web Component

Come programmare il web component AIsuru oltre l'embedding di base: far sì che le risposte dell'agente attivino azioni reali sulla pagina e passargli il contesto della pagina. Il modulo include una demo Rails.

| Demo | Funzionalità | Descrizione |
|------|--------------|-------------|
| **Demo 1** | L'agente controlla la pagina | L'agente chiude la risposta con un tag di output nascosto che la pagina legge sull'evento `MemoriNewDialogState`, poi evidenzia un elemento, mostra un alert o fa lampeggiare lo sfondo |

Obiettivi di apprendimento:

- Integrare e configurare il web component con le credenziali di un agente
- Attivare azioni sul DOM dalle risposte dell'agente con tag di output strutturati
- Passare il contesto della pagina all'avvio della sessione con `initialQuestion`
- Gestire il dialogo tramite Dialog API e costruire una UI personalizzata
- Caso studio: AI4furn

Prerequisiti: basi di HTML e JavaScript, familiarità con il web component AIsuru (SYS-03); Docker installato.

Risorse del modulo: [SYS-05](./SYS-05-web-component-programming/web_component/README-IT.md)

### SYS-06: Integrazione MCP Server

Come collegare gli agenti AIsuru a fonti dati e servizi esterni tramite il Model Context Protocol (MCP). Il modulo include una demo Rails con otto demo, dagli MCP server integrati nella piattaforma a quelli scritti da zero:

| Demo | Tipo di integrazione | Descrizione |
|------|----------------------|-------------|
| **Demo 1** | MongoDB via MCP | MCP server integrato in AIsuru che raggiunge un MongoDB locale attraverso un tunnel TCP ngrok |
| **Demo 2** | MySQL via MCP | Lo stesso server integrato su MySQL, con gli switch di scrittura attivi |
| **Demo 3** | Filesystem MCP server | Un MCP server personalizzato in Node.js che espone operazioni sui file |
| **Demo 4** | MCP Scheduler + Persistence | MCP server di piattaforma che pianificano chiamate a tool e conservano dati strutturati tra le sessioni |
| **Demo 5** | Agent come MCP | Un agente esposto come MCP server tramite Agent Link e consumato da un secondo agente |
| **Demo 6** | Connettore OAuth / API | Una specifica OpenAPI trasformata in tool dell'agente, con il token OAuth2 richiesto e rinnovato dal connettore |
| **Demo 7** | Dall'email all'app | Outlook MCP Server, AIsuru Vibe Coder e MCP Persistence su un solo agente: entra una email, esce un'applicazione funzionante |
| **Demo 8** | MCP Skills | Una skill in markdown registrata su un agente, con la stessa richiesta confrontata prima e dopo |

Le demo 4, 5, 7 e 8 girano interamente dentro AIsuru e non richiedono servizi locali. Le demo 1, 2, 3 e 6 richiedono Docker e un authtoken ngrok, da incollare nella pagina della demo: il pulsante **Avvia demo** presente in ogni pagina fa partire il tunnel giusto, ferma gli altri (un account ngrok gratuito consente un tunnel attivo alla volta) e mostra il valore da incollare in AIsuru. La procedura manuale resta disponibile nella pagina come fallback.

I prompt di sistema pronti e gli asset scaricabili per le demo 5, 7 e 8 si trovano in [`agents/`](./SYS-06-mcp-server-integration/manage-server-mcp/agents/) e sono serviti anche dalle pagine delle demo, dato che i partecipanti al corso non hanno questo repository.

Obiettivi di apprendimento:

- Capire l'architettura MCP e il ruolo di tool, resource e prompt
- Usare gli MCP server integrati in AIsuru (MongoDB, MySQL, Scheduler, Persistence, Skills)
- Costruire e distribuire un MCP server personalizzato in Node.js
- Esporre pubblicamente servizi locali con i tunnel ngrok
- Esporre un agente come MCP server e distinguere il token Consumer da quello Builder
- Trasformare una REST API esistente in tool dell'agente con il connettore OAuth/API
- Combinare più MCP server sullo stesso agente

Prerequisiti: basi di Docker e Docker Compose; familiarità con il web component AIsuru (SYS-03); un account ngrok per le demo 1, 2, 3 e 6; basi di Node.js.

Risorse del modulo: [SYS-06](./SYS-06-mcp-server-integration/manage-server-mcp/README-IT.md)

### SYS-07: Integrazione Automazioni

- Implementazione del sintetizzatore di riunioni
- Integrazione SharePoint e Microsoft 365
- Scenari di automazione dei workflow aziendali

### SYS-08: Best Practice Pre-Release

- Strategie di Red Teaming per sistemi AI
- Whitelisting dei domini e configurazione CORS
- Configurazioni sicure dalla dashboard AIsuru
- Funzioni autenticate (Bearer token, validazione JWT)
- Policy di isolamento dei dati per cliente e contesto
- Audit logging e tracciabilità dell'uso dei tool
- Conformità GDPR e policy di data retention

## Documentazione e risorse

| Risorsa | Link | Descrizione |
|---------|------|-------------|
| Piattaforma AIsuru | [aisuru.com](https://www.aisuru.com) | Sito della piattaforma |
| Documentazione | [docs.aisuru.com](https://docs.aisuru.com/) | Documentazione della piattaforma |
| Riferimento API | [docs.aisuru.com/api](https://docs.aisuru.com/api) | API Engine e Backend |
| Memori.ai | [memori.ai](https://memori.ai) | Sito aziendale |

L'Engine API copre gestione sessioni, dialog, memories, intent, function, webhook e NLP. La Backend API copre gestione utenti, CRUD dei memori, integrazioni, import/export e gestione tenant.

## Chi è Memori.ai

[Memori](https://memori.ai) è un'azienda italiana di intelligenza artificiale fondata nel 2017, con sede a Bologna. Lavora sull'AI conversazionale con attenzione alla conformità all'EU AI Act, alla sicurezza enterprise e alla protezione dei dati by design. AIsuru è la sua piattaforma per creare, addestrare e distribuire agenti conversazionali integrati con i sistemi aziendali.

## Licenza

Questo materiale è fornito per la formazione alla certificazione AIsuru System Integrator.

© 2025 Memori S.R.L. Tutti i diritti riservati.

Serve aiuto? Consulta la [documentazione](https://docs.aisuru.com/), la [piattaforma AIsuru](https://www.aisuru.com) o [memori.ai](https://memori.ai).
