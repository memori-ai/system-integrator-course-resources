# AIsuru AI System Integrator Course Resources

Training material for the AIsuru System Integrator certification program by [Memori.ai](https://memori.ai).

[![AIsuru](https://img.shields.io/badge/Platform-AIsuru-blue)](https://www.aisuru.com)
[![Docs](https://img.shields.io/badge/Docs-docs.aisuru.com-green)](https://docs.aisuru.com)
[![AI Act Compliant](https://img.shields.io/badge/EU%20AI%20Act-Compliant-success)](https://www.aisuru.com)

[Versione italiana](./README-IT.md)

## Enrollment

Registration is not open yet. The link to the course catalog will be published here.

## About this course

The course is aimed at developers, software engineers and technical staff who want to be certified as System Integrators for [AIsuru](https://www.aisuru.com), the conversational AI platform built by [Memori.ai](https://memori.ai).

### What you will learn

- Integrate AI agents into enterprise applications and workflows
- Connect AIsuru to existing business systems (CRM, ERP, databases, APIs)
- Implement authentication flows (SSO, Microsoft Auth, OAuth, JWT)
- Build integrations with MCP servers and advanced functions
- Deploy and configure AIsuru PaaS installations
- Apply security practices to production deployments

### Who should attend

- Backend and frontend developers
- Software architects
- DevOps engineers
- Technical consultants
- IT staff working on AI integrations

## Course modules

| Code | Module | Duration | Topics |
|------|--------|----------|--------|
| **SYS-01** | System Integration Principles | 2h | AI integration strategies, data sources, RAG limitations, vector databases |
| **SYS-02** | Frontend & Backend Integration | 2h | Web components, REST API, embedding, use cases |
| **SYS-03** | Enterprise Authentication | 2h | SSO, Microsoft Auth, OAuth, JWT, embedded authentication |
| **SYS-04** | Advanced Functions | 2h | REST/GRPC/JSONRPC services, Swagger, MCP Gateway |
| **SYS-05** | Web Component Programming | 2h | Dialog API, custom UI, frontend integration |
| **SYS-06** | MCP Server Integration | 3h | Tools, Resources, Prompts, custom MCP servers |
| **SYS-07** | Automation Integration | 2h | Workflow automation, API orchestration, case studies |
| **SYS-08** | Pre-Release Best Practices | 2h | Security, Red Teaming, audit logging, GDPR compliance |
| **SYS-09** | Hands-on Workshop | 1h | Practical exercises and real-world scenarios |

**Format:** 3 days of 6 hours each (online webinar), plus 1 day of live workshop.

## Repository structure

```
system-integrator-course-resources/
├── SYS-03-integrating-enterprise-authentication/
│   └── manage_login/            # Authentication demo app
│       ├── README.md            # Full guide (EN)
│       ├── README-IT.md         # Full guide (IT)
│       ├── img/                 # Screenshots used by the guide
│       └── demo/                # Rails app, demos 1-4
├── SYS-04-advanced-functions/
│   └── manage_functions/        # Advanced functions demo app
│       ├── README.md            # Full guide (EN)
│       ├── README-IT.md         # Full guide (IT)
│       └── demo/                # Rails app, demos 1-2
├── SYS-05-web-component-programming/
│   ├── README.md                # Module overview (EN)
│   ├── README-IT.md             # Module overview (IT)
│   └── web_component/           # Web component / Dialog API demo app
│       ├── README.md            # Full guide (EN)
│       ├── README-IT.md         # Full guide (IT)
│       └── demo/                # Rails app, demo 1
├── SYS-06-mcp-server-integration/
│   └── manage-server-mcp/       # MCP server integration demo app
│       ├── README.md            # Full guide (EN)
│       ├── README-IT.md         # Full guide (IT)
│       ├── agents/              # System prompts and assets for demos 5, 7, 8
│       ├── img/                 # Screenshots used by the guide
│       └── demo/                # Rails app, demos 1-8
├── index.html                   # Demo hub opened by the launchers
├── start-all.js, stop-all.js    # Scripts behind npm run start:all and stop:all
├── avvia.bat, ferma.bat         # Double-click launchers for Windows
├── avvia.command, ferma.command # Double-click launchers for macOS
├── README.md                    # This file
└── README-IT.md                 # Italian version
```

## Prerequisites

- Basic web development knowledge (HTML, CSS, JavaScript)
- Familiarity with REST APIs and HTTP
- Understanding of authentication concepts (OAuth 2.0, JWT, SSO)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed, which includes Docker Engine and Docker Compose and is required by every demo
- [Node.js](https://nodejs.org/) installed, needed by `npm run start` in each demo and by the `npm run start:all` launcher in the repository root
- A code editor (VS Code recommended)

## Getting started

### Quick start with one double-click

If you would rather not use a terminal, download the repository and double-click the file that matches your computer, in the top-level folder:

| System | Start the demos | Stop the demos |
|--------|-----------------|----------------|
| Windows | `avvia.bat` | `ferma.bat` |
| macOS | `avvia.command` | `ferma.command` |

The launcher checks that Node.js and Docker Desktop are installed, starts Docker Desktop if it is not running, prepares every demo and opens the demo hub. The first run can take about ten minutes: leave the window open until it says "Tutto pronto" (all set). The demos keep running after the window is closed. These launchers speak Italian, the language the course is delivered in.

The first time, your operating system may ask for confirmation:

- On Windows, if a security warning appears, click *More info*, then *Run anyway*.
- On macOS, if you see *"cannot be opened because it is from an unidentified developer"*, right-click the file, then *Open*, then *Open* again. Once is enough.

If something goes wrong, the same folder contains `avvio.log` with the technical details to attach to a bug report.

### Terminal setup

1. Clone this repository:
   ```bash
   git clone https://github.com/memori-ai/system-integrator-course-resources.git
   cd system-integrator-course-resources
   ```

2. Start a single demo from its `demo/` folder:
   ```bash
   cd SYS-06-mcp-server-integration/manage-server-mcp/demo
   npm run start
   ```

3. Or start all of them at once, each on its own port:
   ```bash
   npm run start:all
   ```
   This builds and starts SYS-03, SYS-04, SYS-05 and SYS-06 in the background, then opens the demo hub (`index.html`) in your default browser. It behaves the same way on macOS, Linux and Windows, and requires [Node.js](https://nodejs.org/) in addition to Docker.

4. Stop everything with:
   ```bash
   npm run stop:all
   ```

Each module has its own guide with the platform-side configuration (agent credentials, MCP servers, tunnels). Read it before running the demo.

### Demo ports

| Module | URL |
|--------|-----|
| SYS-03 Enterprise Authentication | http://localhost:13000 |
| SYS-04 Advanced Functions | http://localhost:13004 |
| SYS-05 Web Component Programming | http://localhost:13005 |
| SYS-06 MCP Server Integration | http://localhost:13006 |

The ports differ from the Rails default (3000) so that all demos can run at the same time.

## Module details

### SYS-01: System Integration Principles

- Services to integrate and inventory of data sources
- How to provide context to the AI, and what the internals imply for the integration strategy
- Data accessibility and update frequency
- Limitations of RAG (Retrieval Augmented Generation) and vector databases

### SYS-02: Frontend & Backend Integration

- Web component overview and embedding techniques
- API capabilities and integration patterns
- Enterprise use cases

### SYS-03: Enterprise Authentication

How to connect enterprise authentication systems to AIsuru agents. The module ships a Rails demo app with four authentication approaches:

| Demo | Authentication method | Description |
|------|-----------------------|-------------|
| **Demo 1** | Self-managed login | The web component handles the login itself via `showLogin="true"`, with no backend involved |
| **Demo 2** | Programmatic auth (LoginWithJWT) | The backend authenticates the user through the Trusted App API |
| **Demo 3** | Microsoft SSO (Azure AD / Entra ID) | Microsoft identity platform integration with MSAL.js |
| **Demo 4** | Login with redirect | Users authenticate locally, then reach AIsuru through a magic link |

Learning objectives:

- Add authentication to an embedded AIsuru web component
- Use the `LoginWithJWT` API for programmatic authentication
- Configure a Trusted Application for backend-to-backend calls
- Configure Microsoft Azure AD / Entra ID SSO
- Build redirect-based authentication flows

Prerequisites: OAuth 2.0, JWT and SSO basics; Docker installed.

Module resources: [SYS-03](./SYS-03-integrating-enterprise-authentication/manage_login/README.md)

### SYS-04: Advanced Functions

How to write advanced functions that connect AIsuru agents to external REST APIs. The module ships a Rails demo app with two approaches:

| Demo | Function type | Description |
|------|---------------|-------------|
| **Demo 1** | Weather API integration | Connect an agent to a REST service using a webhook function and template variables |
| **Demo 2** | OpenAPI/Swagger import | Generate several functions at once from a Swagger/OpenAPI specification |

Learning objectives:

- Create advanced functions in AIsuru and configure their webhook URL
- Configure webhook integrations with external REST APIs
- Import OpenAPI/Swagger files to generate functions
- Link functions to an agent and configure their usage
- Debug and verify function calls inside a conversation
- Handle function parameters and responses
- Apply function design and error handling practices

Prerequisites: REST API and HTTP basics; familiarity with the AIsuru web component (SYS-03); access to the AIsuru platform and agent credentials; JSON basics; Docker installed.

Module resources: [SYS-04](./SYS-04-advanced-functions/manage_functions/README.md)

### SYS-05: Web Component Programming

How to program the AIsuru web component beyond plain embedding: let the agent answers trigger real actions on the page, and pass the page context to the agent. The module ships a Rails demo app.

| Demo | Feature | Description |
|------|---------|-------------|
| **Demo 1** | Agent controlling the page | The agent closes its answer with a hidden output tag that the page reads on the `MemoriNewDialogState` event, then highlights an element, shows an alert or flashes the background |

Learning objectives:

- Embed and configure the web component with the credentials of an agent
- Trigger DOM actions from the agent answers using structured output tags
- Pass the page context at session start with `initialQuestion`
- Manage the dialog through the Dialog API and build a custom UI
- Case study: AI4furn

Prerequisites: HTML and JavaScript basics, familiarity with the AIsuru web component (SYS-03); Docker installed.

Module resources: [SYS-05](./SYS-05-web-component-programming/web_component/README.md)

### SYS-06: MCP Server Integration

How to connect AIsuru agents to external data sources and services through the Model Context Protocol (MCP). The module ships a Rails demo app with eight demos, from the MCP servers built into the platform to custom ones:

| Demo | Integration type | Description |
|------|------------------|-------------|
| **Demo 1** | MongoDB via MCP | Built-in AIsuru MCP server reaching a local MongoDB through an ngrok TCP tunnel |
| **Demo 2** | MySQL via MCP | The same built-in server on MySQL, with the write switches turned on |
| **Demo 3** | Filesystem MCP server | A custom Node.js MCP server exposing file operations |
| **Demo 4** | MCP Scheduler + Persistence | Platform MCP servers that schedule later tool calls and keep structured data across sessions |
| **Demo 5** | Agent as MCP | An agent exposed as an MCP server through Agent Link and consumed by a second agent |
| **Demo 6** | OAuth / API connector | An OpenAPI spec turned into agent tools, with the OAuth2 token requested and renewed by the connector |
| **Demo 7** | From email to app | Outlook MCP Server, AIsuru Vibe Coder and MCP Persistence on a single agent: an email in, a working app out |
| **Demo 8** | MCP Skills | A markdown skill registered on an agent, with the same request compared before and after |

Demos 4, 5, 7 and 8 run entirely inside AIsuru and need no local service. Demos 1, 2, 3 and 6 need Docker and an ngrok authtoken, which is pasted on the demo page: the **Start demo** button on each page starts the right tunnel, stops the others (a free ngrok account allows one active tunnel at a time) and shows the value to paste into AIsuru. The manual procedure is still available on the page as a fallback.

The ready-made system prompts and the downloadable assets for demos 5, 7 and 8 live in [`agents/`](./SYS-06-mcp-server-integration/manage-server-mcp/agents/) and are also served by the demo pages, since attendees do not have this repository.

Learning objectives:

- Understand the MCP architecture and the role of tools, resources and prompts
- Use the MCP servers built into AIsuru (MongoDB, MySQL, Scheduler, Persistence, Skills)
- Build and deploy a custom MCP server in Node.js
- Expose local services publicly with ngrok tunnels
- Expose an agent as an MCP server, and tell the Consumer token from the Builder token
- Turn an existing REST API into agent tools with the OAuth/API connector
- Combine several MCP servers on the same agent

Prerequisites: Docker and Docker Compose basics; familiarity with the AIsuru web component (SYS-03); an ngrok account for demos 1, 2, 3 and 6; Node.js basics.

Module resources: [SYS-06](./SYS-06-mcp-server-integration/manage-server-mcp/README.md)

### SYS-07: Automation Integration

- Meeting synthesizer implementation
- SharePoint and Microsoft 365 integration
- Enterprise workflow automation scenarios

### SYS-08: Pre-Release Best Practices

- Red Teaming strategies for AI systems
- Domain whitelisting and CORS configuration
- Secure configuration from the AIsuru dashboard
- Authenticated functions (Bearer tokens, JWT validation)
- Data isolation policies per customer and context
- Audit logging and traceability of tool usage
- GDPR compliance and data retention policies

## Documentation and resources

| Resource | Link | Description |
|----------|------|-------------|
| AIsuru platform | [aisuru.com](https://www.aisuru.com) | Platform website |
| Documentation | [docs.aisuru.com](https://docs.aisuru.com/) | Platform documentation |
| API reference | [docs.aisuru.com/api](https://docs.aisuru.com/api) | Engine and Backend API |
| Memori.ai | [memori.ai](https://memori.ai) | Company website |

The Engine API covers session management, dialog, memories, intents, functions, webhooks and NLP. The Backend API covers user management, memori CRUD, integrations, import/export and tenant management.

## About Memori.ai

[Memori](https://memori.ai) is an Italian AI company founded in 2017 and based in Bologna. It works on conversational AI with a focus on EU AI Act compliance, enterprise security and data protection by design. AIsuru is its platform for building, training and deploying conversational agents integrated with enterprise systems.

## License

This material is provided for AIsuru System Integrator certification training.

© 2025 Memori S.R.L. All rights reserved.

Need help? See the [documentation](https://docs.aisuru.com/), the [AIsuru platform](https://www.aisuru.com) or [memori.ai](https://memori.ai).
