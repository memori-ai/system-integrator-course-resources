# MCP Server Integration

Guide to connecting AIsuru agents to external data sources and services through MCP (Model Context Protocol) servers.

[Versione italiana](./README-IT.md)

## Overview

This guide covers:

- Connecting an agent to MongoDB and MySQL through the MCP servers built into AIsuru
- Using the platform servers that need no infrastructure of your own (Scheduler, Persistence, Skills, Agent Link, Vibe Coder, Outlook)
- Building a custom MCP server in Node.js and deploying it with Docker Compose
- Turning an existing REST API into agent tools with the OAuth/API connector
- Exposing local services publicly with ngrok tunnels
- Configuring MCP server integrations in the AIsuru platform

---

## Demo application

The module ships one Rails application with eight demos.

### Quick start

```bash
cd demo
```

The first time, create a `.env` file in the `demo/` folder with this content:

```
NGROK_AUTHTOKEN=your_token_here
```

```bash
# Build and start the application
npm run start

# Open it in the browser
open http://localhost:13006
```

The `web` service is mapped to host port 13006 instead of 3000, so this demo can run at the same time as the others. Inside the container it still listens on 3000.

### One-click demo start

Each demo that needs a tunnel has a **"Start demo"** button: it stops the tunnel of any other demo (free ngrok accounts allow one active tunnel at a time), starts the right tunnel container and shows the value to paste into AIsuru, ready to copy. That value is the connection string for Demo 1, the MCP URL for Demos 2 and 3, and the connector parameters for Demo 6. A **"Stop all tunnels"** button shuts everything down when you are done.

No terminal needed. The manual step-by-step guide is still on each demo page as a fallback.

**How it works, and why it is safe:** the Rails app talks to Docker through a filtered socket proxy (`docker-socket-proxy` in `docker-compose.yml`) that only exposes the container start and stop APIs. The service names are hardcoded in `app/controllers/infra_controller.rb` and no user input ever reaches a command line. Keep tunnels running only while you are actually using a demo: they expose the demo services, with demo credentials, on the public internet.

### Available demos

| Demo | What it connects | Local infrastructure |
|------|------------------|----------------------|
| 1 | MongoDB through the built-in MCP server | Docker + ngrok TCP |
| 2 | MySQL through the built-in MCP server | Docker + ngrok TCP |
| 3 | A custom Node.js filesystem MCP server | Docker + ngrok HTTPS |
| 4 | MCP Scheduler and MCP Persistence | None |
| 5 | One agent exposed to another through Agent Link | None |
| 6 | A REST API through the OAuth/API connector | Docker + ngrok HTTPS |
| 7 | Outlook, Vibe Coder and Persistence on one agent | None |
| 8 | A skill through MCP Skills | None |

#### Demo 1: MongoDB via MCP server

Connect an agent to a MongoDB database using the MCP server built into the platform.

**What you will learn:**
- Run MongoDB locally with Docker
- Expose MongoDB over TCP with ngrok
- Configure the MCP server integration in AIsuru
- Chat with your agent and query live data

**Architecture:** `AIsuru Agent → MCP Server (AIsuru) → ngrok TCP → MongoDB (Docker)`

**Prerequisites:** an ngrok account and auth token, MongoDB running in Docker.

#### Demo 2: MySQL via MCP server

The same idea as Demo 1 on a different database, plus write access. Nothing to write or deploy: the MySQL MCP server is built into AIsuru. Once the write switches are on, the agent can also insert, update and delete rows.

**What you will learn:**
- Run MySQL with Docker
- Expose MySQL through an ngrok TCP tunnel
- Fill in the parameters of the built-in MySQL MCP server
- Turn on write access and watch the agent change the data

**Architecture:** `AIsuru Agent → Built-in MySQL MCP (AIsuru) → ngrok TCP → MySQL (Docker)`

**Prerequisites:** an ngrok account and auth token, Docker.

#### Demo 3: Filesystem MCP server

Connect an agent to a filesystem MCP server of your own, for file operations.

**What you will learn:**
- Build a custom MCP server in Node.js
- Expose filesystem operations over the MCP protocol
- Deploy the MCP server with Docker Compose
- See file changes happen in the shared workspace

**Architecture:** `AIsuru Agent → ngrok HTTPS → MCP Server (Node.js) → shared filesystem`

**Tools exposed:**
- `list_files`, list files and directories
- `read_file`, read the contents of a file
- `write_file`, update an existing file
- `create_file`, create a new file

**Prerequisites:** an ngrok account and auth token, Docker and Docker Compose.

#### Demo 4: MCP Scheduler + MCP Persistence

Two platform MCP servers with nothing to host: **MCP Scheduler** runs a tool call later, on a schedule, and **MCP Persistence** keeps structured data across turns and sessions.

**What you will learn:**
- Schedule a recurring tool call, down to one minute
- Keep structured data outside the conversation history
- Read the stored data back, both through the agent and from the Persistence dashboard

**Architecture:** `AIsuru Agent → MCP Scheduler (AIsuru) + MCP Persistence (AIsuru)`

**Prerequisites:** an agent on AIsuru. Nothing local.

**Why there is no embedded chat:** a scheduled task fires minutes or hours later, and by then it still needs a conversation to reach and a store to write to. That requires the stable, signed-in identity of the agent chat on AIsuru. An embedded web component on a public page is a disposable session that may be gone by the time the task runs, so this demo runs inside AIsuru. The page holds the setup and the prompt to try.

Ask the agent for a task on a recurring schedule that saves each result with the persistence tool, then reload the Persistence dashboard: the saved value changes on its own, with nobody chatting.

#### Demo 5: Agent as MCP

Expose an AIsuru agent as an MCP server through **AIsuru Agent Link**, then let a second agent consume it as a tool. Two agents are involved: the **Expert** (agent A) knows a set of invented ACME policy figures and is exposed as an MCP server, the **Assistant** (agent B) knows none of them and is told to consult the Expert whenever a question touches them. The demo page runs both chats side by side, so the answer before and after the MCP connection can be compared directly.

**What you will learn:**
- Generate the two MCP tokens of an agent
- Tell apart the Consumer token and the Builder token
- Register a custom MCP server on a second agent
- Watch one agent modify another agent prompt

**Architecture:** `Assistant Agent → MCP Server (AIsuru Agent Link) → Expert Agent`

**Prerequisites:** two agents on AIsuru. Nothing local: no database, no ngrok tunnel, no self-hosted MCP server. Everything happens inside AIsuru, so the "Start demo" button does not apply here.

The two ready-made system prompts live in [`agents/`](agents/) and are also served as downloads by the demo page itself, since course attendees do not have this repository:

- `agents/esperto-policy-acme.md`, agent A, the ACME Internal Policy Expert
- `agents/assistente-onboarding.md`, agent B, the ACME Onboarding Assistant

The Expert figures are invented on purpose: a real regulation would already be known to the base model, and the "before and after" would prove nothing.

**The two token types**

| Token type | What it allows |
|---|---|
| Consumer | Query the agent as a tool. It answers, nothing else changes. |
| Builder | Everything the Consumer token allows, plus modifying the agent, including its prompt. |

The Builder token contains the Consumer one. Start with the narrower token and widen only when the task requires it.

**Security note:** no MCP token ever reaches this Rails app. The only agent identifiers that travel in the querystring are `memoriID` and `ownerUserID`, both already public in any web component embed. All token exchange happens directly between the two agents inside AIsuru.

#### Demo 6: OAuth / API connector

Connect an existing HTTP/REST API to an agent without writing a line of code. Point the connector at an OpenAPI spec and every endpoint becomes a tool, with the OAuth2 token requested, cached and renewed for you.

**What you will learn:**
- Run a REST API with OAuth2 client credentials in Docker
- Expose it over HTTPS with ngrok
- Import every endpoint from the OpenAPI spec, with no JSON written by hand
- Watch the agent read data and write it back

**Architecture:** `AIsuru Agent → OAuth/API connector → ngrok HTTPS → FastAPI gestionale (Docker)`

**Prerequisites:** an ngrok account and auth token, Docker and Docker Compose.

**Ports:** the FastAPI gestionale listens on `8100`, its ngrok tunnel dashboard is on `4045`.

**Stale data:** the seed dates are computed the first time the database is created, and the `gestionale_data` volume survives restarts. If the container has been up for weeks, "this month" and "in ritardo" will look wrong. Use the **Reset** button on `/demo6` (or `docker compose down -v`) to regenerate fresh seed dates before class.

#### Demo 7: From email to app

Three MCP servers on one agent: **Outlook MCP Server** reads the mailbox, **AIsuru Vibe Coder** generates a self-contained HTML/JavaScript app, and **MCP Persistence** keeps the project library. The attendee writes no code and no prompt: they send an email and get an application back.

**What you will learn:**
- Combine three MCP servers on a single agent
- Read a live mailbox through the Outlook MCP Server
- Generate a self-contained HTML/JavaScript app with AIsuru Vibe Coder
- Persist and list generated projects with MCP Persistence

**Architecture:** `Email → Outlook MCP Server → AIsuru Vibe Coder → MCP Persistence → generated app`

**Prerequisites:** an agent on AIsuru. Nothing local beyond the Rails page: no Docker service and no ngrok tunnel, same as Demos 4 and 5.

**Setup:**
- Create an agent.
- Add `Outlook MCP Server` (it needs `ms-tenant-id` and `ms-client-id`, provided by whoever runs the course).
- Add `AIsuru Vibe Coder`.
- Add `MCP Persistence`.
- Download the ready-made system prompt from the page and paste it into Agent, Personalization, Prompt.
- Open the agent chat on AIsuru, signed in as its owner.

**Why there is no embedded chat:** the Outlook MCP Server enables `IDENTITY_STRICT_MAILBOX` by default, which restricts mailbox access to the AIsuru account that owns the agent. A visitor arriving through an embedded web component is a different identity, so every mailbox call is refused. That is the protection working, not a misconfiguration. Demo 7 therefore keeps the flag on and runs the whole sequence inside AIsuru; the page holds the setup, the two downloads and the messages to paste.

**Run-through, in order:**
1. Initialise the project library.
2. Connect the mailbox.
3. Complete the Microsoft sign-in.
4. Send the downloadable project email to that mailbox.
5. Ask the agent to read the last 3 emails and build what it finds.
6. Ask what is in the library.

Every message in the run-through is pasted into the agent chat on AIsuru.

`MCP Scheduler` is deliberately not used here. It could poll the mailbox on a schedule, but that pattern is covered on its own in Demo 4.

The two ready-made downloads live in [`agents/`](agents/) and are also served by the demo page itself, at the route `demo7/asset/:kind`:

- `agents/vibe-project-builder.md`, the system prompt to paste into the agent
- `agents/email-flowsales-crm.md`, the project email to send to the mailbox

#### Demo 8: MCP Skills

Attach a **skill** to an agent: a markdown file that describes exactly how to handle one type of request, loaded on demand instead of being baked into the system prompt. The demo is a before and after on the same customer message.

**What you will learn:**
- Create and register a skill on the MCP Skills server
- Reference the skill in the agent system prompt, so the agent knows when to use it
- Compare the agent reply before and after the skill

**Architecture:** `AIsuru Agent → MCP Skills (AIsuru)`

**Prerequisites:** an agent on AIsuru. Nothing local.

**Run-through:** load the agent on the page and send the customer message (a return request) with no skill in place, then add the `MCP Skills` server, open its dashboard, create a new skill with "Modifica come SKILL.md" and paste in the file downloaded from the page. Add to Agent, Personalization, Prompt a section that tells the agent to apply the skill on refund requests, reload the agent and send the same message again.

Creating the skill is not enough by itself: without the line in the system prompt the skill is never picked up, and the reply stays the generic one.

The skill lives in [`agents/skill-refund-response.md`](agents/skill-refund-response.md); the page serves the fenced block of that file at the route `demo8/skill/:kind`, so what the attendee downloads pastes straight into AIsuru.

### Project structure

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Demo selection page
│   │   ├── demo1_controller.rb     # ... one controller per demo, demo1 to demo8
│   │   └── infra_controller.rb     # "Start demo" button: starts and stops the tunnels
│   └── views/
│       ├── home/index.html.erb     # Demo selection
│       ├── demo1/ ... demo8/       # One page per demo
│       └── shared/                 # Setup partials reused across demos
├── docker/
│   ├── mcp-server/                 # Demo 3: filesystem MCP server (Node.js)
│   ├── gestionale/                 # Demo 6: FastAPI API with OAuth2
│   ├── mongo-init/                 # Demo 1: MongoDB seed data
│   └── mysql-init/                 # Demo 2: MySQL seed data
├── docker-compose.yml              # web, databases, mcp-server, gestionale, ngrok tunnels, socket proxy
├── Dockerfile.dev
└── Gemfile
```

The `agents/` folder sits next to `demo/` and is mounted read-only into the container, which is how the pages of demos 5, 7 and 8 serve their downloads.

### Docker commands

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

1. An AIsuru account at [aisuru.com](https://www.aisuru.com)
2. An agent (memori) configured in that account, two of them for Demo 5
3. An [ngrok](https://ngrok.com) account, for demos 1, 2, 3 and 6
4. Docker and Docker Compose installed

---

## How to get your agent IDs

1. Go to [AIsuru](https://www.aisuru.com) and create an agent
2. Open the agent and click **Dev docs** in the left sidebar
3. Expand the **Other references** section ("Altri riferimenti" in the Italian interface)
4. Copy:
   - Secondary Memori (Agent) ID, used as `memoriID`
   - Owner user ID, used as `ownerUserID`

---

## Setting up ngrok

Demos 1, 2, 3 and 6 need ngrok to expose a local service publicly. Demos 4, 5, 7 and 8 do not.

1. Create an account at [ngrok.com](https://ngrok.com)
2. Get your auth token from the [dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Add it to the `.env` file in the `demo/` folder:
   ```
   NGROK_AUTHTOKEN=your_token_here
   ```

The easiest way to start the right tunnel is the **"Start demo"** button on the demo page. The manual equivalents, from the `demo/` folder:

**Demo 1 (MongoDB):**
- `docker compose up -d ngrok-mongo` (TCP tunnel to MongoDB, dashboard at http://localhost:4043)
- Use the TCP host and port in the AIsuru MCP connection string

**Demo 2 (MySQL):**
- `docker compose up -d ngrok-demo2` (TCP tunnel to MySQL, dashboard at http://localhost:4044)
- Use the TCP host and port as `MYSQL_HOST` and `MYSQL_PORT` in the built-in MySQL MCP server

**Demo 3 (filesystem):**
- `docker compose up -d ngrok-mcp` (dashboard at http://localhost:4041)
- Use the HTTPS URL plus the `/mcp` endpoint in AIsuru

**Demo 6 (OAuth / API connector):**
- `docker compose up -d ngrok-gestionale` (HTTP tunnel to the FastAPI gestionale, dashboard at http://localhost:4045)
- Use the HTTPS URL as the OpenAPI spec URL of the connector

Free ngrok accounts allow one active tunnel at a time, so stop the others first with `docker compose stop ngrok-mongo ngrok-mcp ngrok-demo2 ngrok-gestionale`.

---

## Configuring the MCP servers in AIsuru

This step is always required, no matter how you started the demo: the "Start demo" button, like the manual guide, only brings the tunnel up. It cannot register anything in your agent.

Open your agent settings in AIsuru and go to the **MCP** section. What you do there depends on the demo.

**Built-in servers, from the catalog.** MongoDB, MySQL, Scheduler, Persistence and Skills ship with AIsuru: pick the server from the list and fill in the connection details, when it has any.

- Demo 1 (MongoDB): connection string `mongodb://admin:adminpassword@<NGROK_HOST>:<NGROK_PORT>/mcp_demo?authSource=admin`, database `mcp_demo`
- Demo 2 (MySQL): `MYSQL_HOST` and `MYSQL_PORT` from the TCP tunnel, `MYSQL_USER=mcpuser`, `MYSQL_PASS=mcppassword`, `MYSQL_DB=mcp_demo_mysql`. Leave `ALLOW_INSERT/UPDATE/DELETE/DDL_OPERATION` off until you want the agent to write.
- Demo 4 (Scheduler and Persistence) and Demo 8 (Skills): nothing to fill in, add them and save.

**Custom server (Demo 3).** The filesystem MCP server is yours, so it is not in the catalog: use **Aggiungi MCP Personalizzato** (*Add Custom MCP*) and paste the URL `https://your-ngrok-url/mcp`, `/mcp` endpoint included.

**Agent Link (Demo 5).** On the Expert agent, connect **AIsuru Agent Link** and click **Create MCP**, then open its dashboard, create a Consumer token and copy it together with the public MCP endpoint. On the Assistant agent, register that endpoint and token as a custom MCP server.

**OAuth/API connector (Demo 6).** You never build or deploy an MCP server here: the gestionale API is plugged in through the connector, which imports the OpenAPI spec and generates the MCP server for you. Once saved, it appears among the agent MCP servers with one tool per imported endpoint. Fill in these six parameters, which the `/demo6` page also shows ready to copy:

| Parameter | Value |
|---|---|
| `oauth_auth_type` | `oauth2_client_credentials` |
| `oauth_token_url` | `<ngrok URL>/token` |
| `oauth_client_id` | `aisuru-demo` |
| `oauth_client_secret` | `demo-secret-sys06` |
| `oauth_scope` | `commesse:read` |
| `oauth_openapi_url` | `<ngrok URL>/openapi.json` |

**Three servers on one agent (Demo 7).** Add `Outlook MCP Server` (with `ms-tenant-id` and `ms-client-id`), `AIsuru Vibe Coder` and `MCP Persistence` to the same agent.

Save and test the connection by chatting with your agent.

---

## Module structure

```
SYS-06-mcp-server-integration/
└── manage-server-mcp/ # MCP server integration demo app
    ├── README.md      # This file, full guide (EN)
    ├── README-IT.md   # Full guide (IT)
    ├── agents/        # Prompts and assets downloaded by demos 5, 7 and 8
    ├── img/           # Screenshots used by the guide
    └── demo/          # Rails application, demos 1 to 8
```

## Resources

- [AIsuru documentation](https://docs.aisuru.com/)
- [MCP protocol specification](https://modelcontextprotocol.io/)
- [ngrok documentation](https://ngrok.com/docs)
- [Web component NPM package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

[Course home](../../README.md)
