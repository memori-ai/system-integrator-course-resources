# Risorse del Corso AIsuru System Integrator

Risorse ufficiali di formazione per diventare un **System Integrator AIsuru**. Questo repository contiene demo, esempi di codice e documentazione a supporto del corso di certificazione.

## 🎯 Informazioni sul Corso

Questo corso è progettato per sviluppatori e professionisti tecnici che vogliono diventare **System Integrator** certificati per [AIsuru](https://www.aisuru.com), la piattaforma di IA conversazionale sviluppata da [Memori.ai](https://memori.ai).

Come System Integrator, imparerai a:
- Integrare agenti IA in applicazioni enterprise
- Connettere AIsuru con sistemi aziendali esistenti (CRM, database, API)
- Implementare flussi di autenticazione sicuri
- Costruire integrazioni personalizzate usando MCP Server
- Distribuire e configurare soluzioni AIsuru PaaS

## 📚 Moduli del Corso

| Codice | Modulo | Durata | Descrizione |
|--------|--------|--------|-------------|
| **SYS-01** | Principi di System Integration | 2h | Cosa può fare un'azienda quando integra AI nei propri prodotti e processi |
| **SYS-02** | Integrazione Frontend e Backend | 2h | Web component, panoramica API e casi d'uso |
| **SYS-03** | Autenticazione Aziendale | 2h | SSO, autenticazione Microsoft, autenticazione web component embedded |
| **SYS-04** | Funzioni Avanzate | 2h | Servizi REST, Swagger, GRPC, JSONRPC, Gateway REST-MCP |
| **SYS-05** | Programmazione Web Component | 2h | Gestione completa del dialogo tramite Dialog API |
| **SYS-06** | Integrazione MCP Server | 3h | Tool, Risorse, Prompt, Tipi di trasporto, MCP Server personalizzati |
| **SYS-07** | Integrazione Automazioni | 2h | Casi di studio con API e MCP Server |
| **SYS-08** | Best Practice Pre-Release | 2h | Sicurezza, Red Teaming, Isolamento dati, Audit logging |
| **SYS-09** | Workshop | 1h | Esercitazioni pratiche |

**Durata Totale: 18 ore** (Teoria + Workshop Live)

## 📂 Struttura del Repository

```
system-integrator-course-resources/
├── SYS-03-integrating-enterprise-authentication/
│   └── README.md
├── SYS-04-advanced-functions/
│   └── README.md
├── SYS-05-web-component-programming/
│   └── README.md
├── SYS-06-mcp-server-integration/
│   └── README.md
└── README.md
```

## 🔗 Documentazione Ufficiale

- **Documentazione AIsuru**: [docs.aisuru.com](https://docs.aisuru.com/)
- **Riferimento API**: [docs.aisuru.com/api](https://docs.aisuru.com/api)
- **Engine API**: Gestione sessioni, Dialog, Memories, Intents, Functions, WebHooks
- **Backend API**: Gestione utenti, CRUD Memori, Integrazioni, Import/Export

## 🛠️ Prerequisiti

- Conoscenza base di sviluppo web (HTML, CSS, JavaScript)
- Familiarità con le API REST
- Comprensione dei concetti di autenticazione (OAuth, JWT, SSO)
- Docker e Docker Compose (per eseguire le demo)

## 🚀 Come Iniziare

1. Clona questo repository
2. Naviga nel modulo che vuoi esplorare
3. Segui le istruzioni del README in ogni cartella del modulo
4. Esegui le demo usando Docker Compose dove applicabile

## 📖 Dettagli dei Moduli

### SYS-01: Principi di System Integration
- Servizi da integrare e censimento fonti dati
- Come fornire contesto all'AI (comprendere gli internals per affinare le strategie)
- Accessibilità dei dati e frequenza di aggiornamento
- Limiti della RAG e dei database vettoriali

### SYS-02: Integrazione Frontend e Backend
- Panoramica Web Component ed embedding
- Panoramica API e funzionalità
- Casi d'uso reali

### SYS-03: Autenticazione Aziendale
- Autenticazione web component embedded
- Integrazione autenticazione Microsoft
- API LoginPWD con esempi
- Login con redirect

### SYS-04: Funzioni Avanzate
- Connessione servizi REST
- Integrazione Swagger file
- Connessioni GRPC e JSONRPC
- Gateway REST verso MCP Server

### SYS-05: Programmazione Web Component
- Gestione completa del dialogo tramite Dialog API
- Simulazione del comportamento del web component a livello frontend
- Caso di studio: AI4furn

### SYS-06: Integrazione MCP Server
- Tool, Risorse e Prompt
- Esempi di MCP Server (MySQL, MongoDB, Filesystem, WhatsApp, Blender, Zendesk)
- AIsuru MCP e Data Analysis
- Tipi di trasporto e quando usarli
- Skill: cosa sono e casi d'uso pratici
- Costruire il proprio MCP Server

### SYS-07: Integrazione Automazioni
- Caso di studio: sintetizzatore riunioni
- Integrazione SharePoint
- Scenari di automazione aggiuntivi

### SYS-08: Best Practice Pre-Release
- Strategie di Red Teaming
- Configurazione domini whitelisted
- Configurazioni sicure (tramite AIsuru invece del widget generator)
- Funzioni avanzate autenticate (Bearer token, JWT)
- Policy di isolamento dati per cliente/contesto
- Audit logging e tracciabilità dell'uso dei tool
- Retention e Privacy compliance

## 🏢 Chi è Memori.ai

[Memori](https://memori.ai) è un'azienda italiana fondata nel 2017, specializzata in tecnologie di IA conversazionale. AIsuru è la loro piattaforma principale per creare e gestire agenti conversazionali IA, pienamente conforme all'AI Act europeo.

## 📄 Licenza

Questo materiale didattico è fornito per scopi di formazione alla certificazione AIsuru System Integrator.

---

**Hai bisogno di aiuto?** Consulta la [documentazione ufficiale AIsuru](https://docs.aisuru.com/) o contatta il team Memori.

