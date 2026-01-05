# Manage Login - Authentication Demo

This demo application showcases three approaches to integrate AIsuru authentication in embedded web components.

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

### Demo 3: Microsoft SSO (Azure AD / Entra ID)

Complete Single Sign-On integration with Microsoft identity platform.

**What you'll learn:**
- Create Azure App Registration
- Use MSAL.js for Microsoft authentication
- Chain Microsoft auth → AIsuru auth
- Pre-authenticate users in the web component

**Best for:** Corporate environments using Microsoft 365, Azure AD-integrated applications.

## 🔧 How to Get Your Agent IDs

1. Go to [AIsuru](https://www.aisuru.com) and create an agent (or use your PaaS tenant)
2. Open your agent and click on **Dev docs** in the left sidebar
3. Expand **"▼ Other references"** section
4. Copy:
   - **Secondary Memori (Agent) ID** → `memoriID`
   - **Owner user ID** → `ownerUserID`

## 🔑 Creating a Trusted App (Demo 2 & 3)

1. Login to your AIsuru tenant as an administrator
2. Go to **Admin → Trusted Apps** (or "Applicazioni Fidate" in Italian)
3. Click **+ Create** to add a new Trusted App
4. Fill in:
   - **Name**: A descriptive name (e.g., "My Demo App")
   - **Base URL**: Your application's URL (e.g., `http://localhost:3000`)
5. Save and copy the **API Key**

⚠️ **Security Note:** Never expose your API Key in frontend code! Always call AIsuru APIs from your backend.

## 🔄 How LoginWithJWT Works (Demo 2 & 3)

The programmatic authentication flow:

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

## 📁 Project Structure

```
app/
├── controllers/
│   ├── home_controller.rb      # Demo selection page
│   ├── demo1_controller.rb     # Demo 1: showLogin
│   ├── demo2_controller.rb     # Demo 2: Trusted App auth
│   └── demo3_controller.rb     # Demo 3: Microsoft SSO
├── models/
│   └── user.rb                 # User model (Demo 2 & 3)
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
    └── demo3/
        └── index.html.erb      # Demo 3 MS SSO page
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
