# AIsuru System Integrator Course Resources

Official training resources for becoming an **AIsuru System Integrator**. This repository contains demos, code examples, and documentation to support the certification course.

## 🎯 About This Course

This course is designed for developers and technical professionals who want to become certified **System Integrators** for [AIsuru](https://www.aisuru.com), the conversational AI platform developed by [Memori.ai](https://memori.ai).

As a System Integrator, you'll learn how to:
- Integrate AI agents into enterprise applications
- Connect AIsuru with existing business systems (CRM, databases, APIs)
- Implement secure authentication flows
- Build custom integrations using MCP Servers
- Deploy and configure AIsuru PaaS solutions

## 📚 Course Modules

| Code | Module | Duration | Description |
|------|--------|----------|-------------|
| **SYS-01** | System Integration Principles | 2h | What companies can do when integrating AI into their products and processes |
| **SYS-02** | Frontend & Backend Integration | 2h | Web components, API overview, and use cases |
| **SYS-03** | Enterprise Authentication | 2h | SSO, Microsoft auth, embedded web component authentication |
| **SYS-04** | Advanced Functions | 2h | REST services, Swagger, GRPC, JSONRPC, REST-MCP Gateway |
| **SYS-05** | Web Component Programming | 2h | Full dialog management via Dialog API |
| **SYS-06** | MCP Server Integration | 3h | Tools, Resources, Prompts, Transport types, Custom MCP Servers |
| **SYS-07** | Automation Integration | 2h | Case studies with APIs and MCP Servers |
| **SYS-08** | Pre-Release Best Practices | 2h | Security, Red Teaming, Data isolation, Audit logging |
| **SYS-09** | Workshop | 1h | Hands-on practical exercises |

**Total Duration:** 3 days x 6 hours (online webinar) + 1 day live workshop

## 📂 Repository Structure

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

## 🔗 Official Documentation

- **AIsuru Docs**: [docs.aisuru.com](https://docs.aisuru.com/)
- **API Reference**: [docs.aisuru.com/api](https://docs.aisuru.com/api)
- **Engine API**: Session management, Dialog, Memories, Intents, Functions, WebHooks
- **Backend API**: User management, Memori CRUD, Integrations, Import/Export

## 🛠️ Prerequisites

- Basic knowledge of web development (HTML, CSS, JavaScript)
- Familiarity with REST APIs
- Understanding of authentication concepts (OAuth, JWT, SSO)
- Docker and Docker Compose (for running demos)

## 🚀 Getting Started

1. Clone this repository
2. Navigate to the module you want to explore
3. Follow the README instructions in each module folder
4. Run demos using Docker Compose where applicable

## 📖 Module Details

### SYS-01: System Integration Principles
- Services to integrate and data source inventory
- How to provide context to AI (understanding internals to refine strategies)
- Data accessibility and update frequency
- RAG and vector database limitations

### SYS-02: Frontend & Backend Integration
- Web Component overview and embedding
- API panorama and capabilities
- Real-world use cases

### SYS-03: Enterprise Authentication
- Web component embedded authentication
- Microsoft authentication integration
- LoginPWD API with examples
- Login with redirect flows

### SYS-04: Advanced Functions
- Connecting REST services
- Swagger file integration
- GRPC and JSONRPC connections
- REST to MCP Server Gateway

### SYS-05: Web Component Programming
- Full dialog management via Dialog API
- Simulating web component behavior at frontend level
- Case study: AI4furn

### SYS-06: MCP Server Integration
- Tools, Resources, and Prompts
- MCP Server examples (MySQL, MongoDB, Filesystem, WhatsApp, Blender, Zendesk)
- AIsuru MCP and Data Analysis
- Transport types and when to use them
- Skills: what they are and practical use cases
- Building your own MCP Server

### SYS-07: Automation Integration
- Meeting synthesizer case study
- SharePoint integration
- Additional automation scenarios

### SYS-08: Pre-Release Best Practices
- Red Teaming strategies
- Whitelisted domains configuration
- Secure configurations (via AIsuru instead of widget generator)
- Authenticated advanced functions (Bearer token, JWT)
- Data isolation policies per customer/context
- Audit logging and tool usage traceability
- Retention & Privacy compliance

## 🏢 About Memori.ai

[Memori](https://memori.ai) is an Italian company founded in 2017, specializing in conversational AI technology. AIsuru is their flagship platform for creating and managing AI conversational agents, fully compliant with the European AI Act.

## 📄 License

This educational material is provided for AIsuru System Integrator certification training purposes.

---

**Need help?** Refer to the [official AIsuru documentation](https://docs.aisuru.com/) or contact the Memori team.
