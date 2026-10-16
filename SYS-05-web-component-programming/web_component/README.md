# Web Component Programming with AIsuru

Guide to embedding and programming the AIsuru web component in your own applications.

[Versione italiana](./README-IT.md)

## Overview

This guide covers:

- Embedding the AIsuru web component in a web page
- Configuring the component with the credentials of your agent
- Triggering DOM actions from the agent answers through a structured output tag
- Passing information about the current page to the agent at session start

---

## Prerequisites

1. An AIsuru account at [memori.aclambda.online](https://memori.aclambda.online)
2. An agent (memori) configured in that account
3. Access to the **Dev docs** section of the agent
4. Basic HTML and JavaScript knowledge

**Docker Desktop is required.** The demo application runs inside Docker containers, so install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and make sure it is running before you launch `npm run start`.

---

## Demo application

The module ships one Rails demo application.

### Quick start

```bash
cd demo
```

The first time, create a file named `.env_dev` in the `demo/` folder with this content:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

(The `npm run start:all` launcher in the repository root writes this file by itself.)

```bash
# Build and start the application
npm run start

# Open it in the browser
open http://localhost:13005
```

The `web` service is mapped to host port 13005 instead of 3000, so this demo can run at the same time as the others. Inside the container it still listens on 3000.

**Windows, if `npm run start` fails:** Git on Windows may convert line endings to CRLF, which breaks the shell scripts inside the container. Run this once, then retry:

```bash
git config --global core.autocrlf false
```

### Available demos

#### Demo 1: agent controlling the page

The agent answers in the chat and, at the same time, acts on the page it is embedded in: it highlights a button, shows an alert or flashes the background. Nothing special happens on the platform side: the behaviour comes from the agent prompt plus a listener in the page.

Three actions are wired in the demo:

| Action | Effect on the page |
|--------|--------------------|
| `highlight_home_button` | Yellow outline around the "Back to Demo Selection" button |
| `show_alert` | Dismissible alert at the top of the page, gone after 4 seconds |
| `flash_background_temp` | Page background turns warm yellow for 1.5 seconds |

The demo page walks through the whole setup:

1. Download `agent_prompt.txt` from the page and paste it into the prompt of your agent (Agent settings, AI section). The prompt declares the three actions and the output tag format.
2. Copy the agent IDs from **Dev docs** and paste them in the form on the page, which loads the web component.
3. Ask the agent for an action ("highlight the back button", "show me an alert", "flash the background") and watch the page react.

### Project structure

```
demo/
├── agent_prompt.txt                # Prompt to paste into the agent, served by the download button
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Demo selection page
│   │   └── demo1_controller.rb     # Demo 1, including the prompt download
│   └── views/
│       ├── home/index.html.erb     # Demo selection
│       └── demo1/index.html.erb    # Demo 1 page, component and listener
├── docker-compose.yml
├── Dockerfile.dev
└── Gemfile
```

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

## How to get your agent IDs

Open your agent in AIsuru, then click **Dev docs** in the left sidebar and expand **Other references** ("Altri riferimenti" in the Italian interface):

| Field | Used as | Example |
|-------|---------|---------|
| Secondary Memori (Agent) ID | `memoriID` | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
| Owner user ID | `ownerUserID` | `c3d4e5f6-a7b8-9012-cdef-123456789012` |

---

## Basic web component setup

### Step 1: include the web component

Add these two lines to the `<head>` of your page, or right before the closing `</body>`:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Step 2: configure the web component

```html
<memori-client
  memoriName="YourAgentName"
  ownerUserName="your.username"
  memoriID="YOUR_MEMORI_ID"
  ownerUserID="YOUR_OWNER_USER_ID"
  tenantID="memori.aclambda.online"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://memori.aclambda.online"
  layout="CHAT"
  uiLang="EN"
  spokenLang="EN"
  showLogin="true"
></memori-client>
```

---

## Triggering DOM actions from agent answers

This is what Demo 1 implements, and it takes two pieces.

**On the agent side**, the prompt declares the available actions and tells the agent to close its answer with a hidden tag containing a JSON array of action names:

```
<output class="memori-test">["highlight_home_button"]</output>
```

Several actions can travel in the same tag. The tag is never explained to the user: the page strips it and reacts to it.

**On the page side**, the web component fires a `MemoriNewDialogState` event on every answer. The listener parses the tag and dispatches the actions:

```javascript
document.addEventListener('MemoriNewDialogState', (e) => {
  const emission = e.detail.emission;
  if (!emission) return;

  const match = emission.match(/<output class="memori-test">([\s\S]*?)<\/output>/);
  if (!match) return;

  const actions = JSON.parse(match[1].trim());

  actions.forEach((action) => {
    if (action === 'highlight_home_button') highlightHomeButton();
    else if (action === 'show_alert') showAlert();
    else if (action === 'flash_background_temp') flashBackground();
  });
});
```

The class name of the tag and the action names are a convention between your prompt and your page: pick your own, as long as the two sides agree.

---

## Passing page context to the agent

A related technique, not used by Demo 1: the `initialQuestion` attribute sends a message to the agent when the session opens, which is a place to describe what the user is looking at.

```html
<memori-client
  ...
  initialQuestion="The user is viewing the following page content: [page content here]"
></memori-client>
```

The agent can then answer questions about the current page without the user having to describe it.

---

## Module structure

```
SYS-05-web-component-programming/
├── README.md          # Module overview (EN)
├── README-IT.md       # Module overview (IT)
└── web_component/     # Web component programming demo app
    ├── README.md      # This file, full guide (EN)
    ├── README-IT.md   # Full guide (IT)
    └── demo/          # Rails application, demo 1
```

## Resources

- [AIsuru documentation](https://docs.aisuru.com/)
- [Advanced functions guide](https://docs.aisuru.com/advanced-functions)
- [Web component NPM package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

[Course home](../../README.md)
