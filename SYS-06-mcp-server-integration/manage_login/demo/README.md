# MCP Server Integration - Demo

This demo application showcases MCP (Model Context Protocol) server integrations with AIsuru AI agents.

## 🚀 Quick Start

```bash
docker compose build

# Install dependencies (first time only)
docker compose run --rm web bundle install

# Build and start the application
docker compose up

# Visit the application
open http://localhost:3000
```

## 📋 Available Demos

### Demo 1: MongoDB via MCP Server

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

### Demo 3: Filesystem MCP Server

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

## 🔧 How to Get Your Agent IDs

1. Go to [AIsuru](https://www.aisuru.com) and create an agent (or use your PaaS tenant)
2. Open your agent and click on **Dev docs** in the left sidebar
3. Expand **"▼ Other references"** section
4. Copy:
   - **Secondary Memori (Agent) ID** → `memoriID`
   - **Owner user ID** → `ownerUserID`

## 🔧 Setup ngrok

Both demos require ngrok to expose local services publicly:

1. Create an account at [ngrok.com](https://ngrok.com)
2. Get your auth token from [dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Create a `.env` file in the demo directory:
   ```
   NGROK_AUTHTOKEN=your_token_here
   ```
4. Start services: `docker-compose up -d`

**For Demo 1 (MongoDB):**
- ngrok TCP tunnel: `ngrok tcp 27017`
- Use the TCP URL in AIsuru MCP configuration

**For Demo 3 (Filesystem):**
- ngrok is automatically started via docker-compose
- Check URL at http://localhost:4041
- Use the HTTPS URL + `/mcp` endpoint in AIsuru

## 🔧 Configure MCP Server in AIsuru

The integration flow:

1. **User logs in** to your application (via your form or Microsoft SSO)
2. **Your backend creates a JWT** signed with the Trusted App API Key (HS256)
3. **Your backend calls** `POST /api/v2/LoginWithJWT` with:
   - Header: `X-Memori-Trusted-App: YOUR_API_KEY`
   - Body: `{ "tenant": "www.aisuru.com", "jwtToken": "..." }`
4. **AIsuru returns** a `token` that identifies the authenticated user
5. **Pass the token** to the web component via `additionalInfo='{"loginToken":"..."}'`
6. **User is automatically logged in** to the AI agent!

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Your User     │────▶│   Your Backend  │────▶│  AIsuru API     │
│   (Browser)     │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       │                       │
        │ 1. Login              │ 2. Create JWT         │
        │                       │ 3. Call LoginWithJWT  │
        │                       │◀──────────────────────│
        │                       │ 4. Receive token      │
        │◀──────────────────────│                       │
        │ 5. Page with          │                       │
        │    loginToken set     │                       │
        ▼                       │                       │
┌─────────────────┐             │                       │
│ Web Component   │─────────────┼──────────────────────▶│
│ (authenticated) │             │                       │
└─────────────────┘             │                       │
```

## 🔷 Microsoft Azure App Registration (Demo 3)

To use Demo 3, you need an Azure App Registration:

### Step 1: Create App Registration

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **"Microsoft Entra ID"** (formerly Azure AD)
3. Navigate to **App registrations** → **+ New registration**
4. Configure:
   - **Name**: e.g., "AIsuru Demo App"
   - **Supported account types**:
     - "Accounts in any organizational directory" for multi-tenant
     - "Accounts in this organizational directory only" for single-tenant
   - **Redirect URI**: Select **"Single-page application (SPA)"** and enter `http://localhost:3000`

### Step 2: Get Credentials

1. After registration, go to **Overview**
2. Copy the **Application (client) ID** - this is your `clientId`
3. Note the **Directory (tenant) ID** if using single-tenant mode

### Step 3: Configure API Permissions (optional)

Default permissions usually work, but you can verify:
1. Go to **API permissions**
2. Ensure these are present:
   - `User.Read` (delegated)
   - `openid`, `profile`, `email` (delegated)

### How Demo 3 Works

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   User       │───▶│  MSAL.js     │───▶│  Your        │───▶│  AIsuru      │
│   Browser    │    │  (MS Auth)   │    │  Backend     │    │  API         │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │ 1. Click          │                   │                   │
       │ "Login with MS"   │                   │                   │
       │──────────────────▶│                   │                   │
       │                   │ 2. MS Login       │                   │
       │                   │    Popup          │                   │
       │◀──────────────────│                   │                   │
       │ 3. Email/Name     │                   │                   │
       │    from MS        │                   │                   │
       │───────────────────┼──────────────────▶│                   │
       │                   │                   │ 4. Create JWT     │
       │                   │                   │    + LoginWithJWT │
       │                   │                   │──────────────────▶│
       │                   │                   │◀──────────────────│
       │                   │                   │ 5. AIsuru token   │
       │◀──────────────────┼───────────────────│                   │
       │ 6. Redirect with  │                   │                   │
       │    loginToken     │                   │                   │
       ▼                   │                   │                   │
┌──────────────┐           │                   │                   │
│ Web Component│           │                   │                   │
│ (pre-auth'd) │           │                   │                   │
└──────────────┘           │                   │                   │
```

## 🐳 Docker Commands

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

## 🔗 Magic Link URL (Demo 4)

After obtaining the `token` from `LoginWithJWT`, you can redirect users to AIsuru using the magic link URL format:

```
https://{TENANT_BASE_URL}/{LANGUAGE}/magiclink/{TOKEN}
```

**Examples:**
```
https://www.aisuru.com/en/magiclink/183c7061-a5f5-4bea-ab2b-e4e6a7bbc3a4
https://www.aisuru.com/it/magiclink/183c7061-a5f5-4bea-ab2b-e4e6a7bbc3a4
https://your-tenant.aisuru.com/en/magiclink/YOUR_TOKEN
```

**Parameters:**
- `{TENANT_BASE_URL}` - Your AIsuru tenant URL (e.g., `www.aisuru.com`)
- `{LANGUAGE}` - UI language code (`en`, `it`, etc.)
- `{TOKEN}` - The `token` value from `LoginWithJWT` response

## 📁 Project Structure

```
app/
├── controllers/
│   ├── home_controller.rb      # Demo selection page
│   ├── demo1_controller.rb     # Demo 1: showLogin
│   ├── demo2_controller.rb     # Demo 2: Trusted App auth
│   ├── demo3_controller.rb     # Demo 3: Microsoft SSO
│   └── demo4_controller.rb     # Demo 4: Redirect to AIsuru
├── models/
│   └── user.rb                 # User model (Demo 2, 3, 4)
├── services/
│   └── aisuru_auth_service.rb  # AIsuru API integration
└── views/
    ├── home/
    │   └── index.html.erb      # Demo selection
    ├── demo1/
    │   └── index.html.erb      # Demo 1 page
    ├── demo2/
    │   ├── index.html.erb      # Demo 2 main page
    │   └── login.html.erb      # Demo 2 login page
    ├── demo3/
    │   └── index.html.erb      # Demo 3 MS SSO page
    └── demo4/
        ├── index.html.erb      # Demo 4 main page
        └── login.html.erb      # Demo 4 login page
```

## 🔗 Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [PwlUser API Reference](https://docs.aisuru.com/api/backend/pwluser)
- [Trusted Application API](https://docs.aisuru.com/api/backend/trustedapplication)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)
- [Microsoft Identity Platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/)
- [MSAL.js Documentation](https://github.com/AzureAD/microsoft-authentication-library-for-js)

---

📚 Part of the [AIsuru System Integrator Course](https://github.com/memori-ai/system-integrator-course-resources)
