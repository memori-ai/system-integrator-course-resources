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
│   └── README.md          # Enterprise auth integration examples
├── SYS-04-advanced-functions/
│   └── README.md          # REST, GRPC, JSONRPC examples
├── SYS-05-web-component-programming/
│   └── README.md          # Web component and Dialog API examples
├── SYS-06-mcp-server-integration/
│   └── README.md          # MCP Server implementation guides
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
- ✅ **Docker** and **Docker Compose** installed (for running demos)
- ✅ A code editor (VS Code recommended)

## 🚀 Getting Started

1. **Clone this repository**
   ```bash
   git clone https://github.com/memori-ai/system-integrator-course-resources.git
   cd system-integrator-course-resources
   ```

2. **Navigate to a module** you want to explore

3. **Follow the README** instructions in each module folder

4. **Run demos** using Docker Compose where applicable
   ```bash
   docker compose up
   ```

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
- Web component embedded authentication
- Microsoft Azure AD / Entra ID integration
- LoginPWD API implementation
- OAuth 2.0 and redirect-based login flows

### SYS-04: Advanced Functions
- Connecting REST services with Swagger/OpenAPI
- GRPC and JSONRPC service integration
- Building REST to MCP Server Gateways

### SYS-05: Web Component Programming
- Full dialog management via Dialog API
- Custom UI development for AI agents
- Case study: AI4furn implementation

### SYS-06: MCP Server Integration
- Understanding Tools, Resources, and Prompts
- MCP Server examples: MySQL, MongoDB, Filesystem, WhatsApp, Blender, Zendesk
- AIsuru MCP and Data Analysis capabilities
- Transport types (stdio, HTTP, SSE) and selection criteria
- Skills configuration and practical use cases
- Building and deploying custom MCP Servers

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
