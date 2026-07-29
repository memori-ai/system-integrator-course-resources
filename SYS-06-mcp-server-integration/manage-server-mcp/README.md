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

This module includes **two live demo applications** that showcase different MCP server integration approaches.

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
open http://localhost:3006
```

> ℹ️ This demo's `web` service is mapped to host port **3006** (instead of 3000) so it can run at the same time as the SYS-03 and SYS-04 demos. Inside the container it still listens on 3000.

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
│   ├── mcp-server/                 # Filesystem MCP server (Node.js)
│   └── mcp-server-mysql/           # MySQL MCP server (Node.js)
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

**For Demo 1 (MongoDB):**
- ngrok TCP tunnel: `ngrok tcp 27017`
- Use the TCP URL in AIsuru MCP configuration

**For Demo 3 (Filesystem):**
- ngrok is automatically started via docker-compose
- Check URL at http://localhost:4041
- Use the HTTPS URL + `/mcp` endpoint in AIsuru

---

## Configure MCP Server in AIsuru

After starting the demo, configure the MCP server in the AIsuru platform:

1. Go to your agent settings in AIsuru
2. Navigate to **MCP Servers** section
3. Click **+ Add MCP Server**
4. Enter the ngrok URL for the corresponding demo:
   - Demo 1: `tcp://your-ngrok-url:port` (MongoDB)
   - Demo 3: `https://your-ngrok-url/mcp` (Filesystem)
5. Save and test the connection by chatting with your agent

---

## 📂 Module Structure

```
SYS-06-mcp-server-integration/
├── README.md          # Module overview (EN)
├── README-IT.md       # Module overview (IT)
└── manage-server-mcp/ # MCP server integration demo app
    ├── README.md      # This file — full guide (EN)
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
