# Web Component Programming with AIsuru

> Complete guide to integrating and customizing the AIsuru web component in your applications

## Overview

This guide covers how to embed and program the AIsuru web component to create context-aware AI experiences. You'll learn how to:

- Embed the AIsuru web component in a web page
- Pass page content to the agent at session start
- Enable context-aware conversations tied to what the user is currently seeing
- Trigger DOM actions from agent responses

---

## Prerequisites

Before starting, you need:

1. An **AIsuru account** at [aisuru.com](https://www.aisuru.com)
2. A configured **AI Agent (Memori)** in your account
3. Access to the **Dev Docs** section of your agent
4. Basic knowledge of HTML and JavaScript

> ⚠️ **Docker Desktop required** — The demo application runs entirely inside Docker containers. Make sure you have [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running on your machine before executing `npm run start`.

---

## Demo Application

This module includes **one live demo application** built with Ruby on Rails that showcases web component programming techniques.

### Quick Start

```bash
# Navigate to the demo folder
cd demo
```

Create a file named `.env_dev` in the `demo/` folder (first time only) with the following content:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

```bash
# Build and start the application (single command)
npm run start

# Open in your browser
open http://localhost:3000
```

> 💡 **Windows users — if `npm run start` fails:** Git on Windows may convert line endings to CRLF, which breaks shell scripts inside Docker. Run this command once in your terminal and then retry:
> ```bash
> git config --global core.autocrlf false
> ```

### Available Demos

#### Demo 1: Agent to Control Page Content

Learn how to make your AIsuru agent aware of the web page it is embedded in, enabling it to answer questions about what the user is currently seeing and to trigger actions on the page.

- Embed an AIsuru agent in a web page
- Pass page content to the agent at session start
- Enable context-aware conversations tied to the current page
- Trigger DOM actions from agent responses

**Best for:** Interactive pages where the agent needs awareness of on-screen content.

### Project Structure

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Demo selection page
│   │   └── demo1_controller.rb     # Demo 1: Agent to Control Page Content
│   └── views/
│       ├── home/index.html.erb     # Demo selection
│       └── demo1/index.html.erb    # Demo 1 page
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

## How to Get Your Agent IDs

Navigate to your agent in AIsuru, then click on **Dev docs** in the left sidebar.

Expand the **▼ Other references** section to find:

| Field | Description | Example |
|-------|-------------|---------|
| **Secondary Memori (Agent) ID** | Agent ID for the web component | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
| **Owner user ID** | Owner user ID | `c3d4e5f6-a7b8-9012-cdef-123456789012` |

---

## Basic Web Component Setup

### Step 1: Include the Web Component

Add these two lines to your HTML `<head>` or before your closing `</body>` tag:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Step 2: Configure the Web Component

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

## Passing Page Context to the Agent

Use the `initialQuestion` attribute to pass information about the current page to the agent at session start:

```html
<memori-client
  ...
  initialQuestion="The user is currently viewing the following page content: [page content here]"
></memori-client>
```

This allows the agent to answer questions about what the user is seeing without the user having to repeat it.

---

## Triggering DOM Actions from Agent Responses

The web component emits a `MemoriNewDialogState` event every time the agent responds. You can listen for this event and parse special output tags to trigger actions on the page:

```javascript
document.addEventListener('MemoriNewDialogState', (event) => {
  const emission = event.detail?.emission || '';
  const match = emission.match(/<output class="memori-test">([\s\S]*?)<\/output>/);
  if (!match) return;

  const actions = JSON.parse(match[1]);
  actions.forEach(action => {
    if (action === 'highlight_home_button') highlightHomeButton();
    if (action === 'show_alert') showAlert();
    if (action === 'flash_background_temp') flashBackground();
  });
});
```

The agent emits structured output tags containing JSON arrays of action names, which your JavaScript then executes.

---

## 📂 Module Structure

```
SYS-05-web-component-programming/
├── README.md          # Module overview
└── web_component/     # Web component programming demo app
    ├── README.md      # This file — full guide (EN)
    ├── README-IT.md   # Full guide (IT)
    └── demo/          # Rails application with web component demos
```

## Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [Advanced Functions Guide](https://docs.aisuru.com/advanced-functions)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

🏠 [Course Home](../../README.md)
