# AIsuru AI System Integrator Course Resources

> **Learn to integrate conversational AI into enterprise applications** — Official training materials for the AIsuru System Integrator Certification Program by [Memori.ai](https://memori.ai)

[![AIsuru](https://img.shields.io/badge/Platform-AIsuru-blue)](https://www.aisuru.com)
[![Docs](https://img.shields.io/badge/Docs-docs.aisuru.com-green)](https://docs.aisuru.com)
[![AI Act Compliant](https://img.shields.io/badge/EU%20AI%20Act-Compliant-success)](https://www.aisuru.com)

## 📋 Enroll in the Course

<!-- 🔗 Course catalog link coming soon (January 2025) -->
**Course registration opening soon!** Stay tuned for the official course catalog.

---

## 🎯 About This Course

This **professional certification course** is designed for developers, software engineers, and technical professionals who want to become certified **AI System Integrators** for [AIsuru](https://www.aisuru.com), the European conversational AI platform developed by [Memori.ai](https://memori.ai).

### What You'll Learn

As an **AIsuru AI System Integrator**, you'll master how to:

- 🤖 **Integrate AI agents** into enterprise applications and workflows
- 🔗 **Connect AIsuru** with existing business systems (CRM, ERP, databases, APIs)
- 🔐 **Implement secure authentication** flows (SSO, Microsoft Auth, OAuth, JWT)
- ⚡ **Build custom integrations** using MCP Servers and advanced functions
- 🚀 **Deploy and configure** AIsuru PaaS solutions for enterprise clients
- 🛡️ **Apply security best practices** for production AI deployments

### Who Should Attend

- Backend and Frontend Developers
- Software Architects
- DevOps Engineers
- Technical Consultants
- IT Professionals working with AI integration

## 📚 Course Modules

| Code | Module | Duration | Topics |
|------|--------|----------|--------|
| **SYS-01** | System Integration Principles | 2h | AI integration strategies, data sources, RAG limitations, vector databases |
| **SYS-02** | Frontend & Backend Integration | 2h | Web components, REST API, embedding, use cases |
| **SYS-03** | Enterprise Authentication | 2h | SSO, Microsoft Auth, OAuth, JWT, embedded authentication |
| **SYS-04** | Advanced Functions | 2h | REST/GRPC/JSONRPC services, Swagger, MCP Gateway |
| **SYS-05** | Web Component Programming | 2h | Dialog API, custom UI, frontend integration |
| **SYS-06** | MCP Server Integration | 3h | Tools, Resources, Prompts, custom MCP Servers |
| **SYS-07** | Automation Integration | 2h | Workflow automation, API orchestration, case studies |
| **SYS-08** | Pre-Release Best Practices | 2h | Security, Red Teaming, audit logging, GDPR compliance |
| **SYS-09** | Hands-on Workshop | 1h | Practical exercises and real-world scenarios |

### Course Format

📅 **Duration:** 3 days × 6 hours (online webinar) + 1 day live workshop

## 📂 Repository Structure

```
system-integrator-course-resources/
├── SYS-03-integrating-enterprise-authentication/
│   ├── README.md          # Module overview (EN)
│   ├── README-IT.md       # Module overview (IT)
│   └── manage_login/      # Authentication demo app
│       ├── README.md      # Full guide: web component auth (EN)
│       ├── README-IT.md   # Full guide: web component auth (IT)
│       └── demo/          # Rails 8 app with all auth demos
├── SYS-04-advanced-functions/
│   ├── README.md          # Module overview (EN)
│   ├── README-IT.md       # Module overview (IT)
│   └── manage_functions/  # Advanced functions demo app
│       ├── README.md      # Full guide: advanced functions (EN)
│       ├── README-IT.md   # Full guide: advanced functions (IT)
│       └── demo/          # Rails app with function demos
├── SYS-05-web-component-programming/
│   └── README.md          # Web component and Dialog API examples
├── SYS-06-mcp-server-integration/
│   └── manage-server-mcp/ # MCP server integration demo app
│       ├── README.md      # Full guide: MCP server integration (EN)
│       ├── README-IT.md   # Full guide: MCP server integration (IT)
│       └── demo/          # Rails app with MCP demos
├── README.md              # This file
└── README-IT.md           # Italian version
```

## 🔗 Official Documentation & Resources

| Resource | Link | Description |
|----------|------|-------------|
| **AIsuru Platform** | [aisuru.com](https://www.aisuru.com) | Main platform website |
| **Documentation** | [docs.aisuru.com](https://docs.aisuru.com/) | Complete platform documentation |
| **API Reference** | [docs.aisuru.com/api](https://docs.aisuru.com/api) | Engine & Backend API docs |
| **Memori.ai** | [memori.ai](https://memori.ai) | Company website |

### API Overview

- **Engine API**: Session management, Dialog, Memories, Intents, Functions, WebHooks, NLP
- **Backend API**: User management, Memori CRUD, Integrations, Import/Export, Tenant management

## 🛠️ Prerequisites

Before starting the course, ensure you have:

- ✅ Basic knowledge of **web development** (HTML, CSS, JavaScript)
- ✅ Familiarity with **REST APIs** and HTTP protocols
- ✅ Understanding of **authentication concepts** (OAuth 2.0, JWT, SSO)
- ✅ **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** installed (includes Docker Engine and Docker Compose — required to run all demo applications)
- ✅ A code editor (VS Code recommended)

## 🚀 Getting Started

1. **Clone this repository**
   ```bash
   git clone https://github.com/memori-ai/system-integrator-course-resources.git
   cd system-integrator-course-resources
   ```

2. **Navigate to a module** you want to explore

3. **Follow the README** instructions in each module folder

4. **Run demos** — navigate to the `demo/` folder inside a module and run:
   ```bash
   npm run start
   ```

   Or, to start **all** demos at once (each on its own port) and browse them from a single page:
   ```bash
   ./start-all.sh
   open index.html   # demo hub — pick a module, jump straight to its demo
   ```
   Stop everything with `./stop-all.sh`.

## 📖 Module Details

### SYS-01: System Integration Principles
- Services to integrate and data source inventory
- How to provide context to AI (understanding internals to refine strategies)
- Data accessibility and update frequency
- RAG (Retrieval Augmented Generation) and vector database limitations

### SYS-02: Frontend & Backend Integration
- Web Component overview and embedding techniques
- API capabilities and integration patterns
- Real-world enterprise use cases

### SYS-03: Enterprise Authentication

Learn how to integrate enterprise authentication systems with AIsuru conversational AI agents. The module provides a complete demo Rails application covering four authentication approaches:

| Demo | Authentication Method | Description |
|------|----------------------|-------------|
| **Demo 1** | Self-Managed Login | Web component handles login via `showLogin="true"` — no backend required |
| **Demo 2** | Programmatic Auth (LoginWithJWT) | Backend authenticates users via Trusted App API for seamless SSO |
| **Demo 3** | Microsoft SSO (Azure AD / Entra ID) | Full Microsoft identity platform integration using MSAL.js |
| **Demo 4** | Login with Redirect | Authenticate users locally, then redirect to AIsuru via magic link |

**Learning objectives:**
- Implement authentication in embedded AIsuru web components
- Use the `LoginWithJWT` API for programmatic authentication
- Configure Trusted Applications for secure backend-to-backend communication
- Configure Microsoft Azure AD / Entra ID SSO
- Build redirect-based authentication flows

**Prerequisites:** Basic understanding of OAuth 2.0, JWT, SSO concepts; Docker installed.

📁 **Module resources:** [SYS-03 →](./SYS-03-integrating-enterprise-authentication/manage_login/README.md)

### SYS-04: Advanced Functions

Learn how to create advanced functions that connect AIsuru agents to external REST APIs and services. The module provides a complete demo Rails application covering two approaches:

| Demo | Function Type | Description |
|------|--------------|-------------|
| **Demo 1** | Weather API Integration | Connect agents to REST services using webhook functions and template variables |
| **Demo 2** | OpenAPI/Swagger Import | Auto-generate multiple functions at once from Swagger/OpenAPI specifications |

**Learning objectives:**
- Create advanced functions in AIsuru and configure webhook URLs
- Configure webhook integrations with external REST APIs
- Use OpenAPI/Swagger files to auto-generate functions
- Link functions to agents and configure their usage
- Debug and verify function calls in conversations
- Handle function parameters and responses
- Apply best practices for function design and error handling

**Prerequisites:** Basic understanding of REST APIs and HTTP methods; familiarity with AIsuru web components (SYS-03); access to AIsuru platform and agent credentials; basic knowledge of JSON and API parameters; Docker installed.

📁 **Module resources:** [SYS-04 →](./SYS-04-advanced-functions/manage_functions/README.md)

### SYS-05: Web Component Programming
- Full dialog management via Dialog API
- Custom UI development for AI agents
- Case study: AI4furn implementation

### SYS-06: MCP Server Integration

Learn how to connect AIsuru agents to external data sources and services using the Model Context Protocol (MCP). The module provides a complete demo Rails application covering two integration approaches:

| Demo | Integration Type | Description |
|------|-----------------|-------------|
| **Demo 1** | MongoDB via MCP | Connect agents to MongoDB using the built-in AIsuru MCP server and ngrok TCP tunnel |
| **Demo 3** | Filesystem MCP Server | Build and deploy a custom Node.js MCP server for real-time file operations |

**Learning objectives:**
- Understand the MCP (Model Context Protocol) architecture
- Connect AIsuru agents to MongoDB via the built-in MCP server
- Build custom MCP servers in Node.js
- Expose local services publicly using ngrok tunnels
- Configure MCP server integrations in the AIsuru platform
- Deploy MCP servers with Docker Compose

**Prerequisites:** Basic understanding of Docker and Docker Compose; familiarity with AIsuru web components (SYS-03); ngrok account; basic Node.js knowledge.

📁 **Module resources:** [SYS-06 →](./SYS-06-mcp-server-integration/manage-server-mcp/README.md)

### SYS-07: Automation Integration
- Meeting synthesizer implementation
- SharePoint and Microsoft 365 integration
- Enterprise workflow automation scenarios

### SYS-08: Pre-Release Best Practices
- Red Teaming strategies for AI systems
- Domain whitelisting and CORS configuration
- Secure configurations via AIsuru dashboard
- Authenticated functions (Bearer tokens, JWT validation)
- Data isolation policies per customer/context
- Audit logging and tool usage traceability
- GDPR compliance and data retention policies

## 🏢 About Memori.ai

[**Memori**](https://memori.ai) is an Italian AI company founded in 2017, headquartered in Bologna. We specialize in **conversational AI technology** with a strong focus on:

- 🇪🇺 **EU AI Act compliance** — fully compliant with European AI regulations
- 🔒 **Enterprise-grade security** — data privacy and protection by design
- 🎯 **Human-centric AI** — accessible and intuitive AI experiences

**AIsuru** is our flagship platform for creating, training, and deploying AI conversational agents that integrate seamlessly with enterprise systems.

## 🌐 Keywords

`AI integration` `conversational AI` `enterprise AI` `chatbot development` `MCP Server` `system integration` `AIsuru` `Memori.ai` `AI certification` `REST API integration` `SSO integration` `OAuth` `JWT` `web components` `AI agents` `RAG` `vector database` `GRPC` `JSONRPC` `automation` `EU AI Act`

## 📄 License

This educational material is provided for **AIsuru AI System Integrator** certification training purposes.

© 2025 Memori S.R.L. — All rights reserved.

---

<p align="center">
  <strong>Need help?</strong><br>
  📚 <a href="https://docs.aisuru.com/">Official Documentation</a> · 
  🌐 <a href="https://www.aisuru.com">AIsuru Platform</a> · 
  🏢 <a href="https://memori.ai">Memori.ai</a>
</p>
