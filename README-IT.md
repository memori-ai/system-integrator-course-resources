# AIsuru AI System Integrator Course Resources

> **Impara a integrare l'intelligenza artificiale conversazionale nelle applicazioni enterprise** — Materiali ufficiali di formazione per il Programma di Certificazione AIsuru System Integrator di [Memori.ai](https://memori.ai)

[![AIsuru](https://img.shields.io/badge/Piattaforma-AIsuru-blue)](https://www.aisuru.com)
[![Docs](https://img.shields.io/badge/Docs-docs.aisuru.com-green)](https://docs.aisuru.com)
[![AI Act Compliant](https://img.shields.io/badge/EU%20AI%20Act-Conforme-success)](https://www.aisuru.com)

## 📋 Iscriviti al Corso

<!-- 🔗 Link al catalogo corsi in arrivo (Gennaio 2025) -->
**Iscrizioni al corso in apertura!** Resta aggiornato per il catalogo ufficiale dei corsi.

---

## 🎯 Informazioni sul Corso

Questo **corso di certificazione professionale** è progettato per sviluppatori, software engineer e professionisti tecnici che vogliono diventare **AI System Integrator** certificati per [AIsuru](https://www.aisuru.com), la piattaforma europea di intelligenza artificiale conversazionale sviluppata da [Memori.ai](https://memori.ai).

### Cosa Imparerai

Come **AIsuru AI System Integrator**, imparerai a:

- 🤖 **Integrare agenti AI** in applicazioni e workflow aziendali
- 🔗 **Connettere AIsuru** con sistemi aziendali esistenti (CRM, ERP, database, API)
- 🔐 **Implementare autenticazione sicura** (SSO, Microsoft Auth, OAuth, JWT)
- ⚡ **Costruire integrazioni personalizzate** usando MCP Server e funzioni avanzate
- 🚀 **Distribuire e configurare** soluzioni AIsuru PaaS per clienti enterprise
- 🛡️ **Applicare best practice di sicurezza** per deployment AI in produzione

### A Chi è Rivolto

- Sviluppatori Backend e Frontend
- Software Architect
- DevOps Engineer
- Consulenti Tecnici
- Professionisti IT che lavorano con integrazioni AI

## 📚 Moduli del Corso

| Codice | Modulo | Durata | Argomenti |
|--------|--------|--------|-----------|
| **SYS-01** | Principi di System Integration | 2h | Strategie di integrazione AI, fonti dati, limiti RAG, database vettoriali |
| **SYS-02** | Integrazione Frontend e Backend | 2h | Web component, API REST, embedding, casi d'uso |
| **SYS-03** | Autenticazione Aziendale | 2h | SSO, Microsoft Auth, OAuth, JWT, autenticazione embedded |
| **SYS-04** | Funzioni Avanzate | 2h | Servizi REST/GRPC/JSONRPC, Swagger, Gateway MCP |
| **SYS-05** | Programmazione Web Component | 2h | Dialog API, UI personalizzata, integrazione frontend |
| **SYS-06** | Integrazione MCP Server | 3h | Tool, Risorse, Prompt, MCP Server personalizzati |
| **SYS-07** | Integrazione Automazioni | 2h | Automazione workflow, orchestrazione API, casi studio |
| **SYS-08** | Best Practice Pre-Release | 2h | Sicurezza, Red Teaming, audit logging, conformità GDPR |
| **SYS-09** | Workshop Pratico | 1h | Esercitazioni pratiche e scenari reali |

### Formato del Corso

📅 **Durata:** 3 giorni × 6 ore (webinar online) + 1 giorno di workshop live

## 📂 Struttura del Repository

```
system-integrator-course-resources/
├── SYS-03-integrating-enterprise-authentication/
│   ├── README.md          # Panoramica modulo (EN)
│   ├── README-IT.md       # Panoramica modulo (IT)
│   └── manage_login/      # Demo app autenticazione
│       ├── README.md      # Guida completa: auth web component (EN)
│       ├── README-IT.md   # Guida completa: auth web component (IT)
│       └── demo/          # App Rails 8 con tutte le demo auth
├── SYS-04-advanced-functions/
│   └── manage_functions/  # Demo app funzioni avanzate
│       ├── README.md      # Guida completa: funzioni avanzate (EN)
│       ├── README-IT.md   # Guida completa: funzioni avanzate (IT)
│       └── demo/          # App Rails con demo funzioni
├── SYS-05-web-component-programming/
│   ├── README.md          # Panoramica modulo
│   └── web_component/     # Demo app web component / Dialog API
│       ├── README.md      # Guida completa: programmazione web component (EN)
│       ├── README-IT.md   # Guida completa: programmazione web component (IT)
│       └── demo/          # App Rails con la demo Dialog API
├── SYS-06-mcp-server-integration/
│   └── manage-server-mcp/ # Demo app integrazione MCP server
│       ├── README.md      # Guida completa: integrazione MCP server (EN)
│       ├── README-IT.md   # Guida completa: integrazione MCP server (IT)
│       └── demo/          # App Rails con demo MCP
├── README.md              # Versione inglese
└── README-IT.md           # Questo file
```

## 🔗 Documentazione Ufficiale e Risorse

| Risorsa | Link | Descrizione |
|---------|------|-------------|
| **Piattaforma AIsuru** | [aisuru.com](https://www.aisuru.com) | Sito web della piattaforma |
| **Documentazione** | [docs.aisuru.com](https://docs.aisuru.com/) | Documentazione completa |
| **Riferimento API** | [docs.aisuru.com/api](https://docs.aisuru.com/api) | Documentazione API Engine e Backend |
| **Memori.ai** | [memori.ai](https://memori.ai) | Sito web aziendale |

### Panoramica API

- **Engine API**: Gestione sessioni, Dialog, Memories, Intents, Functions, WebHooks, NLP
- **Backend API**: Gestione utenti, CRUD Memori, Integrazioni, Import/Export, gestione Tenant

## 🛠️ Prerequisiti

Prima di iniziare il corso, assicurati di avere:

- ✅ Conoscenza base di **sviluppo web** (HTML, CSS, JavaScript)
- ✅ Familiarità con **API REST** e protocolli HTTP
- ✅ Comprensione dei **concetti di autenticazione** (OAuth 2.0, JWT, SSO)
- ✅ **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** installato (include Docker Engine e Docker Compose — necessario per eseguire tutte le demo)
- ✅ **[Node.js](https://nodejs.org/)** installato (serve per `npm run start` in ogni demo, e per il launcher `npm run start:all` in root)
- ✅ Un editor di codice (VS Code consigliato)

## 🚀 Come Iniziare

1. **Clona questo repository**
   ```bash
   git clone https://github.com/memori-ai/system-integrator-course-resources.git
   cd system-integrator-course-resources
   ```

2. **Naviga nel modulo** che vuoi esplorare

3. **Segui le istruzioni del README** in ogni cartella del modulo

4. **Esegui le demo** usando Docker Compose dove applicabile
   ```bash
   docker compose up
   ```

   Oppure, per avviare **tutte** le demo insieme (ognuna sulla propria porta) e navigarle da un'unica pagina:
   ```bash
   npm run start:all
   ```
   Questo comando compila e avvia SYS-03, SYS-04, SYS-05 e SYS-06 in background, poi apre in automatico l'hub delle demo (`index.html`) nel tuo browser predefinito — scegli un modulo, apri subito la sua demo. Funziona allo stesso modo su macOS, Linux e Windows (richiede [Node.js](https://nodejs.org/) oltre a Docker).

   Ferma tutto con:
   ```bash
   npm run stop:all
   ```

## 📖 Dettagli dei Moduli

### SYS-01: Principi di System Integration
- Servizi da integrare e censimento fonti dati
- Come fornire contesto all'AI (comprendere gli internals per affinare le strategie)
- Accessibilità dei dati e frequenza di aggiornamento
- Limiti della RAG (Retrieval Augmented Generation) e dei database vettoriali

### SYS-02: Integrazione Frontend e Backend
- Panoramica Web Component e tecniche di embedding
- Capacità API e pattern di integrazione
- Casi d'uso enterprise reali

### SYS-03: Autenticazione Aziendale

Impara a integrare sistemi di autenticazione enterprise con gli agenti AI conversazionali di AIsuru. Il modulo include una demo completa in Rails che copre quattro approcci di autenticazione:

| Demo | Metodo di Autenticazione | Descrizione |
|------|--------------------------|-------------|
| **Demo 1** | Login Autonomo | Il web component gestisce il login via `showLogin="true"` — nessun backend richiesto |
| **Demo 2** | Auth Programmatica (LoginWithJWT) | Il backend autentica gli utenti via Trusted App API per un SSO seamless |
| **Demo 3** | Microsoft SSO (Azure AD / Entra ID) | Integrazione completa con Microsoft identity platform tramite MSAL.js |
| **Demo 4** | Login con Redirect | Autentica gli utenti localmente, poi li reindirizza ad AIsuru via magic link |

**Obiettivi di apprendimento:**
- Implementare l'autenticazione in web component AIsuru embedded
- Usare l'API `LoginWithJWT` per l'autenticazione programmatica
- Configurare Trusted Application per la comunicazione sicura backend-to-backend
- Configurare Microsoft Azure AD / Entra ID SSO
- Costruire flussi di autenticazione con redirect

**Prerequisiti:** Conoscenza base di OAuth 2.0, JWT, SSO; Docker installato.

📁 **Risorse del modulo:** [SYS-03 →](./SYS-03-integrating-enterprise-authentication/manage_login/README-IT.md)

### SYS-04: Funzioni Avanzate

Impara come creare funzioni avanzate che collegano gli agenti AIsuru a REST API e servizi esterni. Il modulo include una demo completa in Rails che copre due approcci:

| Demo | Tipo di Funzione | Descrizione |
|------|-----------------|-------------|
| **Demo 1** | Integrazione Weather API | Collega agenti a servizi REST usando webhook e variabili template |
| **Demo 2** | Import OpenAPI/Swagger | Auto-genera multiple funzioni da specifiche Swagger/OpenAPI |

**Obiettivi di apprendimento:**
- Creare funzioni avanzate in AIsuru e configurare URL webhook
- Configurare integrazioni webhook con REST API esterne
- Usare file OpenAPI/Swagger per auto-generare funzioni
- Collegare funzioni agli agenti e configurare il loro utilizzo
- Debuggare e verificare le chiamate alle funzioni nelle conversazioni
- Gestire parametri e risposte delle funzioni
- Applicare best practice per il design delle funzioni e la gestione errori

**Prerequisiti:** Comprensione base di REST API e metodi HTTP; familiarità con i web component AIsuru (SYS-03); accesso alla piattaforma AIsuru e credenziali agente; conoscenza base di JSON e parametri API; Docker installato.

📁 **Risorse del modulo:** [SYS-04 →](./SYS-04-advanced-functions/manage_functions/README-IT.md)

### SYS-05: Programmazione Web Component

Impara a programmare il web component AIsuru oltre l'integrazione di base: passa il contesto della pagina all'agente e lascia che le sue risposte attivino azioni reali sulla pagina. Il modulo include una demo Rails funzionante.

| Demo | Funzionalità | Descrizione |
|------|--------------|-------------|
| **Demo 1** | Dialog API context-aware | L'agente riceve il contesto della pagina e può attivare azioni sul DOM (evidenziare elementi, mostrare alert, far lampeggiare lo sfondo) tramite un tag di output strutturato nelle sue risposte |

**Obiettivi di apprendimento:**
- Gestione completa del dialogo tramite Dialog API
- Sviluppo UI personalizzata per agenti AI
- Attivare azioni sul DOM dalle risposte dell'agente tramite tag di output strutturati
- Caso studio: implementazione AI4furn

**Prerequisiti:** Comprensione base di HTML/JavaScript e dei web component AIsuru (SYS-03); Docker installato.

📁 **Risorse del modulo:** [SYS-05 →](./SYS-05-web-component-programming/web_component/README-IT.md)

### SYS-06: Integrazione MCP Server

Impara a connettere gli agenti AIsuru a sorgenti dati e servizi esterni usando il Model Context Protocol (MCP). Il modulo include una demo completa in Rails che copre due approcci di integrazione:

| Demo | Tipo di Integrazione | Descrizione |
|------|---------------------|-------------|
| **Demo 1** | MongoDB via MCP | Connette agenti a MongoDB usando il server MCP integrato nella piattaforma AIsuru e tunnel ngrok TCP |
| **Demo 3** | Filesystem MCP Server | Costruisce e distribuisce un server MCP personalizzato in Node.js per operazioni sui file in tempo reale |

**Obiettivi di apprendimento:**
- Comprendere l'architettura MCP (Model Context Protocol)
- Connettere agenti AIsuru a MongoDB via server MCP integrato nella piattaforma
- Costruire server MCP personalizzati in Node.js
- Esporre servizi locali pubblicamente usando tunnel ngrok
- Configurare le integrazioni MCP server nella piattaforma AIsuru
- Distribuire server MCP con Docker Compose

**Prerequisiti:** Comprensione base di Docker e Docker Compose; familiarità con i web component AIsuru (SYS-03); account ngrok; conoscenza base di Node.js.

📁 **Risorse del modulo:** [SYS-06 →](./SYS-06-mcp-server-integration/manage-server-mcp/README-IT.md)

### SYS-07: Integrazione Automazioni
- Implementazione sintetizzatore riunioni
- Integrazione SharePoint e Microsoft 365
- Scenari di automazione workflow aziendali

### SYS-08: Best Practice Pre-Release
- Strategie di Red Teaming per sistemi AI
- Whitelisting domini e configurazione CORS
- Configurazioni sicure tramite dashboard AIsuru
- Funzioni autenticate (Bearer token, validazione JWT)
- Policy di isolamento dati per cliente/contesto
- Audit logging e tracciabilità uso tool
- Conformità GDPR e policy di data retention

## 🏢 Chi è Memori.ai

[**Memori**](https://memori.ai) è un'azienda italiana di intelligenza artificiale fondata nel 2017, con sede a Bologna. Siamo specializzati in **tecnologia AI conversazionale** con forte focus su:

- 🇪🇺 **Conformità EU AI Act** — pienamente conforme alle normative europee sull'AI
- 🔒 **Sicurezza enterprise-grade** — privacy e protezione dati by design
- 🎯 **AI human-centric** — esperienze AI accessibili e intuitive

**AIsuru** è la nostra piattaforma principale per creare, addestrare e distribuire agenti conversazionali AI che si integrano perfettamente con i sistemi aziendali.

## 🌐 Keywords

`integrazione AI` `intelligenza artificiale conversazionale` `AI enterprise` `sviluppo chatbot` `MCP Server` `system integration` `AIsuru` `Memori.ai` `certificazione AI` `integrazione API REST` `integrazione SSO` `OAuth` `JWT` `web component` `agenti AI` `RAG` `database vettoriali` `GRPC` `JSONRPC` `automazione` `EU AI Act`

## 📄 Licenza

Questo materiale didattico è fornito per scopi di formazione alla certificazione **AIsuru AI System Integrator**.

© 2025 Memori S.R.L. — Tutti i diritti riservati.

---

<p align="center">
  <strong>Hai bisogno di aiuto?</strong><br>
  📚 <a href="https://docs.aisuru.com/">Documentazione Ufficiale</a> · 
  🌐 <a href="https://www.aisuru.com">Piattaforma AIsuru</a> · 
  🏢 <a href="https://memori.ai">Memori.ai</a>
</p>
