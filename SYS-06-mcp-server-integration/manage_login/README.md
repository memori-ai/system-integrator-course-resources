# Embedded Web Component Authentication

> Complete guide to configuring the AIsuru web component with authentication for embedded scenarios

## 🎯 Overview

This guide covers how to embed the AIsuru web component in your applications and configure authentication to provide personalized AI experiences. You'll learn how to:

- Configure the web component with your agent credentials
- Pass authentication tokens for logged-in users
- Use context variables and initial questions
- Implement secure authentication flows

## 🚀 Try the Demos

This module includes **four live demo applications** that showcase different authentication approaches.

![Demo Selection Page](./img/home.png)

### Running the Demos

```bash
# Navigate to the demo folder
cd demo

# Build and start the application (single command)
npm run start

# Open in your browser
open http://localhost:3000
```

### Demo 1: Self-Managed Login (`showLogin="true"`)

The simplest approach where the web component handles authentication autonomously.

- Configure web component with agent credentials
- Users login through the built-in authentication panel
- No backend changes required

### Demo 2: Programmatic Auth with Trusted App

Backend authentication using the `LoginWithJWT` API for seamless SSO.

- Create and configure a Trusted App in your tenant
- Your backend authenticates users via `LoginWithJWT`
- Pass the token to web component via `additionalInfo.loginToken`
- Demo user: `demo@demo.com` / `demodemo`

### Demo 3: Microsoft SSO (Azure AD / Entra ID)

Complete Single Sign-On integration with Microsoft identity platform.

- Configure Azure App Registration with your `clientId`
- Use MSAL.js for Microsoft authentication in the browser
- Chain Microsoft auth → AIsuru `LoginWithJWT` for seamless SSO
- Users are pre-authenticated in the web component

### Demo 4: Login with Redirect

Authenticate users in your app, then redirect them to the AIsuru platform.

- Enterprise login flow with your own credentials
- Use `LoginWithJWT` to obtain an AIsuru token
- Redirect to `https://{tenant}/{lang}/magiclink/{token}`
- Users land on the full AIsuru interface, pre-authenticated

📁 **Demo Source Code**: [demo/](./demo/)

---

## 📋 Prerequisites

Before starting, you need:

1. An **AIsuru account** at [aisuru.com](https://www.aisuru.com)
2. A configured **AI Agent (Memori)** in your account
3. Access to the **Dev Docs** section of your agent
4. Basic knowledge of HTML and JavaScript

---

## 🔧 Basic Web Component Setup

### Step 1: Include the Web Component

Add these two lines to your HTML `<head>` or before your closing `</body>` tag:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Step 2: Get Your Agent Credentials

Navigate to your agent in AIsuru, then click on **Dev docs** in the left sidebar.

You'll find:

| Field | Description | Example |
|-------|-------------|---------|
| **Memori (Agente) ID** | Unique identifier for your agent | `a1b2c3d4-e5f6-7890-abcd-ef1234567890` |
| **Engine URL** | API endpoint for conversations | `https://engine.memori.ai/memori/v2` |
| **Backend URL** | API endpoint for backend operations | `https://backend.memori.ai/api/v2` |

Expand the **▼ Other references** section to find:

| Field | Description | Example |
|-------|-------------|---------|
| **Secondary Memori (Agent) ID** | Agent ID for web component | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
| **Owner user ID** | Owner user ID | `c3d4e5f6-a7b8-9012-cdef-123456789012` |

### Step 3: Configure the Web Component

Add the web component to your HTML:

```html
<memori-client
  memoriName="YourAgentName"
  ownerUserName="your.username"
  memoriID="YOUR_MEMORI_ID"
  ownerUserID="YOUR_OWNER_USER_ID"
  tenantID="www.aisuru.com"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://www.aisuru.com"
  layout="CHAT"
  uiLang="EN"
  spokenLang="EN"
  showLogin="true"
></memori-client>
```

---

## 🔐 Authentication Configuration

### Passing a Login Token

When you have authenticated users in your application, you can pass their authentication token to the web component using the `additionalInfo` attribute:

```html
<memori-client
  memoriName="YourAgentName"
  ownerUserName="your.username"
  memoriID="YOUR_MEMORI_ID"
  ownerUserID="YOUR_OWNER_USER_ID"
  tenantID="www.aisuru.com"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://www.aisuru.com"
  layout="CHAT"
  uiLang="EN"
  spokenLang="EN"
  showLogin="false"
  additionalInfo='{"loginToken":"YOUR_USER_LOGIN_TOKEN"}'
></memori-client>
```

> ⚠️ **Important**: When passing a login token, set `showLogin="false"` since the user is already authenticated.

### Dynamic Token Injection (JavaScript)

For dynamic applications, inject the token via JavaScript:

```html
<memori-client id="memori-widget"></memori-client>

<script>
  const memoriWidget = document.getElementById('memori-widget');
  
  // Get your user's token from your authentication system
  const userToken = await getUserAuthToken();
  
  // Configure the widget
  memoriWidget.setAttribute('memoriName', 'YourAgentName');
  memoriWidget.setAttribute('ownerUserName', 'your.username');
  memoriWidget.setAttribute('memoriID', 'YOUR_MEMORI_ID');
  memoriWidget.setAttribute('ownerUserID', 'YOUR_OWNER_USER_ID');
  memoriWidget.setAttribute('tenantID', 'www.aisuru.com');
  memoriWidget.setAttribute('engineURL', 'https://engine.memori.ai/memori/v2');
  memoriWidget.setAttribute('apiURL', 'https://backend.memori.ai/api/v2');
  memoriWidget.setAttribute('baseURL', 'https://www.aisuru.com');
  memoriWidget.setAttribute('layout', 'CHAT');
  memoriWidget.setAttribute('showLogin', 'false');
  memoriWidget.setAttribute('additionalInfo', JSON.stringify({
    loginToken: userToken
  }));
</script>
```

---

## 🎛️ Context Variables and Initial Questions

### Using Context Variables

Pass contextual information to your agent using the `context` attribute. This allows you to customize the agent's behavior based on user or application state:

```html
<memori-client
  ...
  context="ENVIRONMENT:PRODUCTION,LANGUAGE:EN,USER_ID:12345,DEMO:FALSE"
></memori-client>
```

Context variables are passed as comma-separated `KEY:VALUE` pairs.

**Common use cases:**
- `USER_ID`: Identify the current user
- `LANGUAGE`: Set preferred language
- `ENVIRONMENT`: Distinguish between dev/staging/production
- `DEMO`: Enable/disable demo mode
- `ROLE`: User role (admin, user, guest)

### Setting an Initial Question

Pre-populate the conversation with an initial question or instruction:

```html
<memori-client
  ...
  initialQuestion="Hello! I need help with my account."
></memori-client>
```

This can also be used to set instructions for the agent:

```html
<memori-client
  ...
  initialQuestion="Always use formal language and provide detailed explanations."
></memori-client>
```

---

## 🔑 Obtaining Login Tokens via API

To authenticate users programmatically, use the AIsuru Backend API.

### Option 1: Magic Link Login

Send a magic link to the user's email:

```bash
POST https://backend.memori.ai/api/v2/PwlLogin
Content-Type: application/json

{
  "tenant": "www.aisuru.com",
  "userName": "user@example.com",
  "eMail": "user@example.com"
}
```

### Option 2: JWT Login

For enterprise SSO integration, use JWT-based authentication:

```bash
POST https://backend.memori.ai/api/v2/LoginWithJWT
Content-Type: application/json

{
  "tenant": "www.aisuru.com",
  "jwt": "YOUR_SIGNED_JWT_TOKEN"
}
```

**Response:**

```json
{
  "user": {
    "userID": "c3d4e5f6-a7b8-9012-cdef-123456789012",
    "userName": "user@example.com",
    ...
  },
  "token": "f1e2d3c4-b5a6-9780-1234-567890abcdef",
  "resultCode": 0,
  "resultMessage": "OK"
}
```

Use the returned `token` value in the `additionalInfo.loginToken` attribute.

📖 **Full API Reference**: [PwlUser API Documentation](https://docs.aisuru.com/api/backend/pwluser)

---

## 🔐 Trusted Applications

To use `LoginWithJWT` for programmatic authentication, you need a **Trusted Application**.

### What is a Trusted App?

A Trusted Application is a secure way for your backend to communicate with AIsuru APIs. It allows you to:
- Authenticate users programmatically without them entering AIsuru credentials
- Create seamless SSO experiences
- Manage user sessions from your backend

### Creating a Trusted App

1. Login to your AIsuru tenant as an **administrator**
2. Go to **Admin → Trusted Apps** (or "Applicazioni Fidate" in Italian)
3. Click **+ Create** to add a new Trusted App
4. Fill in:
   - **Name**: A descriptive name (e.g., "My Production App")
   - **Base URL**: Your application's URL (for CORS validation)
5. Save and copy the **API Key**

### Using the Trusted App API Key

The authentication flow requires two steps:

#### Step 1: Create a signed JWT

Create a JWT token signed with the Trusted App API Key using HS256 algorithm:

```javascript
// Backend code (Node.js example)
const jwt = require('jsonwebtoken');

const trustedAppApiKey = process.env.AISURU_TRUSTED_APP_KEY;

const jwtToken = jwt.sign(
  {
    sub: user.email,
    email: user.email,
    name: user.name,
    tenant: 'www.aisuru.com',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 300  // 5 minutes
  },
  trustedAppApiKey,
  { algorithm: 'HS256' }
);
```

#### Step 2: Call the LoginWithJWT API

Make a POST request to the AIsuru backend with:
- **Header:** `X-Memori-Trusted-App` containing your API Key
- **Body:** JSON with `tenant` and `jwtToken` fields

```http
POST https://backend.memori.ai/api/v2/LoginWithJWT
Content-Type: application/json
X-Memori-Trusted-App: YOUR_TRUSTED_APP_API_KEY

{
  "tenant": "www.aisuru.com",
  "jwtToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Successful Response:**

```json
{
  "token": "183c7061-a5f5-4bea-ab2b-e4e6a7bbc3a4",
  "user": {
    "userID": "6057f403-777f-413b-b4f5-5b6ed4ef84b6",
    "userName": "Demo-User",
    "eMail": "demo@demo.com"
  },
  "resultCode": 0,
  "resultMessage": "Ok"
}
```

The returned `token` is what you pass to the web component via `additionalInfo.loginToken`.

> ⚠️ **Security Warning:** Never expose your Trusted App API Key in frontend code! Always call AIsuru APIs from your backend.

---

## 📝 Complete Example

Here's a complete example with authentication and context:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My AI Assistant</title>
  
  <!-- AIsuru Web Component -->
  <script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
</head>
<body>
  
  <h1>Welcome to My Application</h1>
  
  <!-- Authenticated AI Agent -->
  <memori-client
    memoriName="MyAssistant"
    ownerUserName="your.username"
    memoriID="YOUR_MEMORI_ID"
    ownerUserID="YOUR_OWNER_USER_ID"
    tenantID="www.aisuru.com"
    engineURL="https://engine.memori.ai/memori/v2"
    apiURL="https://backend.memori.ai/api/v2"
    baseURL="https://www.aisuru.com"
    layout="CHAT"
    uiLang="EN"
    spokenLang="EN"
    showLogin="false"
    additionalInfo='{"loginToken":"USER_AUTH_TOKEN"}'
    context="ENVIRONMENT:PRODUCTION,USER_ROLE:PREMIUM"
    initialQuestion="Welcome! How can I assist you today?"
  ></memori-client>

</body>
</html>
```

---

## 🎨 Layout Options

The `layout` attribute supports different display modes:

| Value | Description |
|-------|-------------|
| `CHAT` | Standard chat interface |
| `FULLPAGE` | Full-page immersive experience |
| `TOTEM` | Kiosk/totem mode |
| `WEBSITE_ASSISTANT` | Floating assistant widget |

---

## 🔗 Quick Reference

### Required Attributes

| Attribute | Description |
|-----------|-------------|
| `memoriName` | Name of your agent |
| `ownerUserName` | Your AIsuru username |
| `memoriID` | Agent ID from Dev Docs |
| `ownerUserID` | Owner ID from Dev Docs |
| `tenantID` | Your tenant (e.g., `www.aisuru.com`) |
| `engineURL` | Engine API URL |
| `apiURL` | Backend API URL |
| `baseURL` | Tenant base URL |

### Optional Attributes

| Attribute | Description | Default |
|-----------|-------------|---------|
| `layout` | Display mode | `CHAT` |
| `uiLang` | UI language | `EN` |
| `spokenLang` | Conversation language | `EN` |
| `showLogin` | Show login button | `true` |
| `additionalInfo` | JSON with loginToken and other data | - |
| `context` | Context variables | - |
| `initialQuestion` | Initial message/instruction | - |

---

## 📚 Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [PwlUser API Reference](https://docs.aisuru.com/api/backend/pwluser)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

📚 [Back to SYS-03 Module](../README.md) | 🏠 [Course Home](../../README.md)
