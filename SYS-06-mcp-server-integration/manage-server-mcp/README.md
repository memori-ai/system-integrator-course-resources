# MCP Server Integration

> Complete guide to integrating MCP (Model Context Protocol) servers with AIsuru AI agents

## Overview

This guide covers how to connect AIsuru AI agents to external data sources and services using MCP servers. You'll learn how to:

- Connect agents to MongoDB databases via platform-integrated MCP server
- Build custom MCP servers in Node.js for filesystem operations
- Expose local services publicly using ngrok tunnels
- Configure MCP server integrations in the AIsuru platform

---

## Demo Application

This module includes **six live demo applications** that showcase different MCP server integration approaches.

### Quick Start

```bash
# Navigate to the demo folder
cd demo
```

Create a `.env` file in the `demo/` folder (first time only) with the following content:

```
NGROK_AUTHTOKEN=your_token_here
```

```bash
# Build and start the application (single command)
npm run start

# Open in your browser
open http://localhost:13006
```

> ℹ️ This demo's `web` service is mapped to host port **13006** (instead of 3000) so it can run at the same time as the other demos. Inside the container it still listens on 3000.

### One-Click Demo Start

Each demo page has a **"Start demo"** button: click it and the app automatically
stops the ngrok tunnel of any other demo (free ngrok accounts allow one active
tunnel at a time), starts the right tunnel container, and shows the value to
paste into AIsuru (connection string for Demo 1, MCP URL for Demos 2/3,
connector parameters for Demo 6), ready to copy. A **"Stop all tunnels"**
button shuts every tunnel down when you're done.

No terminal needed. The manual step-by-step guide is still available on each
demo page as a fallback.

**How it works (security note):** the Rails app talks to Docker through a
filtered socket proxy (`docker-socket-proxy` in `docker-compose.yml`) that only
exposes the container start/stop APIs; the service names are hardcoded in
`app/controllers/infra_controller.rb` and no user input ever reaches a command
line. Keep tunnels running only while you're actually using a demo: they expose
the demo services (with demo credentials) on the public internet.

### Available Demos

#### Demo 1: MongoDB via MCP Server

Connect an AIsuru AI agent to a MongoDB database using platform-integrated MCP server.

**What you'll learn:**
- Run MongoDB locally with Docker
- Expose MongoDB over TCP using ngrok
- Configure MCP server integration in AIsuru platform
- Chat with your agent to query live data

**Architecture:**
`AIsuru Agent → MCP Server (AIsuru) → ngrok TCP → MongoDB (Docker)`

**Prerequisites:**
- ngrok account and auth token
- MongoDB running in Docker

#### Demo 3: Filesystem MCP Server

Connect an AIsuru AI agent to a custom filesystem MCP server for file operations.

**What you'll learn:**
- Build a custom MCP server in Node.js
- Expose filesystem operations via MCP protocol
- Deploy MCP server with Docker Compose
- See real-time file changes in the workspace

**Architecture:**
`AIsuru Agent → ngrok HTTPS → MCP Server (Node.js) → Shared Filesystem`

**Available Tools:**
- `list_files` - List files and directories
- `read_file` - Read file contents
- `write_file` - Update existing files
- `create_file` - Create new files

**Prerequisites:**
- ngrok account and auth token
- Docker and Docker Compose

#### Demo 5: Agent as MCP

Expose an AIsuru agent as an MCP server through **AIsuru Agent Link**, then let a second
agent consume it as a tool. Two agents are involved: the **Expert** (agent A) knows a set of
invented ACME policy figures and is exposed as an MCP server; the **Assistant** (agent B)
knows none of them and is told to consult the Expert whenever a question touches them. The
demo page runs both chats side by side, so the answer before and after the MCP connection
can be compared directly.

**What you'll learn:**
- Generate the two MCP tokens of an agent
- Tell apart the Consumer token and the Builder token
- Register a custom MCP server on a second agent
- Watch one agent modify another agent's prompt

**Architecture:**
`Assistant Agent → MCP Server (AIsuru Agent Link) → Expert Agent`

**Prerequisites:**
- Two agents on AIsuru. Nothing local: no database, no ngrok tunnel, no self-hosted MCP
  server. Everything happens inside AIsuru, so the "Start demo" button does not apply here.

The two ready-made system prompts live in [`agents/`](agents/) and are also served as
downloads by the demo page itself, since course attendees do not have this repository:

- `agents/esperto-policy-acme.md`: agent A, the ACME Internal Policy Expert
- `agents/assistente-onboarding.md`: agent B, the ACME Onboarding Assistant

The Expert's figures are invented on purpose: a real regulation would already be known to
the base model, and the "before and after" would prove nothing.

**The two token types**

| Token type | What it allows |
|---|---|
| Consumer | Query the agent as a tool. It answers, nothing else changes. |
| Builder | Everything the Consumer token allows, **plus** modifying the agent, including its prompt. |

The Builder token contains the Consumer one. Start with the narrower token and widen only
when the task requires it.

**Security note:** no MCP token ever reaches this Rails app. The only agent identifiers that
travel in the querystring are `memoriID` and `ownerUserID`, both already public in any web
component embed. All token exchange happens directly between the two agents inside AIsuru.

#### Demo 6: OAuth / API Connector

Connect an existing HTTP/REST API to an AIsuru agent without writing a line of code. Point
the connector at an OpenAPI spec and every endpoint becomes a tool, with the OAuth2 token
requested, cached and renewed for you.

**What you'll learn:**
- Run a REST API with OAuth2 client credentials in Docker
- Expose it over HTTPS using ngrok
- Import every endpoint from the OpenAPI spec, no JSON by hand
- Watch the agent read data and write it back

**Architecture:**
`AIsuru Agent → OAuth/API Connector → ngrok HTTPS → FastAPI ERP (Docker)`

**Prerequisites:**
- ngrok account and auth token
- Docker and Docker Compose

**Ports:** the FastAPI gestionale listens on `8100`; the ngrok tunnel dashboard is on `4045`.

⚠️ **Stale data:** the seed dates are computed the first time the database is created, and
the `gestionale_data` volume survives restarts. If the container has been up for weeks,
"this month" and "in ritardo" will look wrong. Use the **Reset** button on `/demo6` (or
`docker compose down -v`) to regenerate fresh seed dates before class.

### Project Structure

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Demo selection page
│   │   ├── demo1_controller.rb     # Demo 1: MongoDB MCP
│   │   └── demo3_controller.rb     # Demo 3: Filesystem MCP
│   └── views/
│       ├── home/index.html.erb     # Demo selection
│       ├── demo1/index.html.erb    # Demo 1 page
│       └── demo3/index.html.erb    # Demo 3 page
├── docker/
│   └── mcp-server/                 # Filesystem MCP server (Node.js)
├── docker-compose.yml
├── Dockerfile.dev
└── Gemfile
```

### Docker Commands

```bash
# Start the application
docker compose up

# Start in background
docker compose up -d

# Stop the application
docker compose down

# View logs
docker compose logs -f web

# Install/update gems
docker compose run --rm web bundle

# Rails console
docker compose run --rm web rails console
```

---

## Prerequisites

Before starting, you need:

1. An **AIsuru account** at [aisuru.com](https://www.aisuru.com)
2. A configured **AI Agent (Memori)** in your account
3. A **ngrok account** at [ngrok.com](https://ngrok.com)
4. **Docker** and **Docker Compose** installed

---

## How to Get Your Agent IDs

1. Go to [AIsuru](https://www.aisuru.com) and create an agent (or use your PaaS tenant)
2. Open your agent and click on **Dev docs** in the left sidebar
3. Expand **"▼ Other references"** section
4. Copy:
   - **Secondary Memori (Agent) ID** → `memoriID`
   - **Owner user ID** → `ownerUserID`

---

## Setup ngrok

Both demos require ngrok to expose local services publicly:

1. Create an account at [ngrok.com](https://ngrok.com)
2. Get your auth token from the [dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Add your token to the `.env` file in the `demo/` folder:
   ```
   NGROK_AUTHTOKEN=your_token_here
   ```

The easiest way to start the right tunnel is the **"Start demo"** button on each
demo page. Manual equivalents (from the `demo/` folder):

**For Demo 1 (MongoDB):**
- `docker compose up -d ngrok-mongo` (TCP tunnel to MongoDB; dashboard at http://localhost:4043)
- Use the TCP host/port in the AIsuru MCP connection string

**For Demo 2 (MySQL):**
- `docker compose up -d ngrok-demo2` (TCP tunnel to MySQL; dashboard at http://localhost:4044)
- Use the TCP host/port as `MYSQL_HOST` / `MYSQL_PORT` in AIsuru's built-in MySQL MCP server

**For Demo 3 (Filesystem):**
- `docker compose up -d ngrok-mcp` (dashboard at http://localhost:4041)
- Use the HTTPS URL + `/mcp` endpoint in AIsuru

**For Demo 6 (OAuth / API Connector):**
- `docker compose up -d ngrok-gestionale` (HTTP tunnel to the FastAPI gestionale; dashboard at http://localhost:4045)
- Use the HTTPS URL in the OAuth/API connector's OpenAPI spec URL

⚠️ Free ngrok accounts allow **one active tunnel at a time**: stop the other
tunnels first with `docker compose stop ngrok-mongo ngrok-mcp ngrok-demo2 ngrok-gestionale`.

---

## Configure MCP Server in AIsuru

This step is **always required**, no matter how you started the demo: the
"Start demo" button (or the manual guide) only brings the tunnel up, it cannot
register anything in your agent.

Go to your agent settings in AIsuru, then to the **MCP Servers** section. What
you do there depends on the demo:

**Demos 1 and 2, built-in servers.** MongoDB and MySQL ship with AIsuru: pick
the ready-made server from the list and fill in the connection details.
- Demo 1 (MongoDB): connection string
  `mongodb://admin:adminpassword@<NGROK_HOST>:<NGROK_PORT>/mcp_demo?authSource=admin`,
  database `mcp_demo`
- Demo 2 (MySQL): `MYSQL_HOST` / `MYSQL_PORT` from the TCP tunnel,
  `MYSQL_USER=mcpuser`, `MYSQL_PASS=mcppassword`, `MYSQL_DB=mcp_demo_mysql`.
  Leave `ALLOW_INSERT/UPDATE/DELETE/DDL_OPERATION` off until you want the agent
  to write.

**Demo 3, custom server.** The filesystem MCP server is yours, so it is not in
the catalog: use the **"Aggiungi MCP Personalizzato"** (*Add Custom MCP*)
section and paste the URL `https://your-ngrok-url/mcp`, `/mcp` endpoint included.

Save and test the connection by chatting with your agent.

**Demo 6: an MCP server you do not have to write.** You never build or deploy
an MCP server here: the gestionale API is plugged in through AIsuru's
**OAuth/API connector**, which imports the OpenAPI spec and generates the MCP
server for you. Once saved, it appears among your agent's **MCP servers**, with
one tool per imported endpoint. Add the OAuth/API connector to your agent and
fill in these six parameters (the `/demo6` page shows the same values, ready to
copy):

| Parameter | Value |
|---|---|
| `oauth_auth_type` | `oauth2_client_credentials` |
| `oauth_token_url` | `<ngrok URL>/token` |
| `oauth_client_id` | `aisuru-demo` |
| `oauth_client_secret` | `demo-secret-sys06` |
| `oauth_scope` | `commesse:read` |
| `oauth_openapi_url` | `<ngrok URL>/openapi.json` |

---

## 📂 Module Structure

```
SYS-06-mcp-server-integration/
├── README.md          # Module overview (EN)
├── README-IT.md       # Module overview (IT)
└── manage-server-mcp/ # MCP server integration demo app
    ├── README.md      # This file, full guide (EN)
    ├── README-IT.md   # Full guide (IT)
    └── demo/          # Rails application with MCP demos
```

## Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [ngrok Documentation](https://ngrok.com/docs)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

🏠 [Course Home](../../README.md)
