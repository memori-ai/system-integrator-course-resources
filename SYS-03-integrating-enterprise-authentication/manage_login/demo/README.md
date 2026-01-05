# Embedded Web Component Authentication Demo

This demo application showcases two approaches to integrate AIsuru authentication in embedded web components.

## 🚀 Quick Start

```bash
# Install dependencies (first time only)
docker compose run --rm web bundle install

# Build and start the application
docker compose up

# Visit the application
open http://localhost:3000
```

## 📋 Available Demos

### Demo 1: Self-Managed Login (`showLogin="true"`)

The simplest approach where the web component handles authentication autonomously.

**What you'll learn:**
- Configure web component with agent credentials
- Use `showLogin="true"` for built-in auth
- CSS techniques for embedding the component

**Best for:** Public websites, quick integration, no backend changes required.

### Demo 2: Programmatic Auth with Trusted App

Backend authentication using `LoginWithJWT` API - seamless SSO experience.

**What you'll learn:**
- Create and configure a Trusted App
- Use `LoginWithJWT` API for backend auth
- Pass `loginToken` to web component via `additionalInfo`

**Best for:** Enterprise applications, existing user systems, SSO requirements.

**Demo credentials:**
- Email: `demo@demo.com`
- Password: `demodemo`

## 🔧 How to Get Your Agent IDs

1. Go to [AIsuru](https://www.aisuru.com) and create an agent (or use your PaaS tenant)
2. Open your agent and click on **Dev docs** in the left sidebar
3. Expand **"▼ Other references"** section
4. Copy:
   - **Secondary Memori (Agent) ID** → `memoriID`
   - **Owner user ID** → `ownerUserID`

## 🔑 Creating a Trusted App (Demo 2)

1. Login to your AIsuru tenant as an administrator
2. Go to **Admin → Trusted Apps** (or "Applicazioni Fidate" in Italian)
3. Click **+ Create** to add a new Trusted App
4. Fill in:
   - **Name**: A descriptive name (e.g., "My Demo App")
   - **Base URL**: Your application's URL (e.g., `http://localhost:3000`)
5. Save and copy the **API Key**

⚠️ **Security Note:** Never expose your API Key in frontend code! Always call AIsuru APIs from your backend.

## 🔄 How LoginWithJWT Works (Demo 2)

The programmatic authentication flow:

1. **User logs in** to your application with their credentials
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

## 📁 Project Structure

```
app/
├── controllers/
│   ├── home_controller.rb      # Demo selection page
│   ├── demo1_controller.rb     # Demo 1: showLogin
│   └── demo2_controller.rb     # Demo 2: Trusted App auth
├── models/
│   └── user.rb                 # User model for Demo 2
├── services/
│   └── aisuru_auth_service.rb  # AIsuru API integration
└── views/
    ├── home/
    │   └── index.html.erb      # Demo selection
    ├── demo1/
    │   └── index.html.erb      # Demo 1 page
    └── demo2/
        ├── index.html.erb      # Demo 2 main page
        └── login.html.erb      # Demo 2 login page
```

## 🔗 Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [PwlUser API Reference](https://docs.aisuru.com/api/backend/pwluser)
- [Trusted Application API](https://docs.aisuru.com/api/backend/trustedapplication)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

📚 Part of the [AIsuru System Integrator Course](https://github.com/memori-ai/system-integrator-course-resources)
