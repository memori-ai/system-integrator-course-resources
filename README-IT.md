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
│   └── README.md          # Esempi integrazione autenticazione enterprise
├── SYS-04-advanced-functions/
│   └── README.md          # Esempi REST, GRPC, JSONRPC
├── SYS-05-web-component-programming/
│   └── README.md          # Esempi Web Component e Dialog API
├── SYS-06-mcp-server-integration/
│   └── README.md          # Guide implementazione MCP Server
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
- ✅ **Docker** e **Docker Compose** installati (per eseguire le demo)
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
- Autenticazione web component embedded
- Integrazione Microsoft Azure AD / Entra ID
- Implementazione API LoginPWD
- Flussi OAuth 2.0 e login con redirect

### SYS-04: Funzioni Avanzate
- Connessione servizi REST con Swagger/OpenAPI
- Integrazione servizi GRPC e JSONRPC
- Costruzione Gateway REST verso MCP Server

### SYS-05: Programmazione Web Component
- Gestione completa del dialogo tramite Dialog API
- Sviluppo UI personalizzata per agenti AI
- Caso studio: implementazione AI4furn

### SYS-06: Integrazione MCP Server
- Comprensione di Tool, Risorse e Prompt
- Esempi MCP Server: MySQL, MongoDB, Filesystem, WhatsApp, Blender, Zendesk
- Capacità AIsuru MCP e Data Analysis
- Tipi di trasporto (stdio, HTTP, SSE) e criteri di selezione
- Configurazione Skill e casi d'uso pratici
- Costruzione e deployment di MCP Server personalizzati

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
