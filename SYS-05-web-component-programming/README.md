# SYS-05: Web Component Programming

> Learn how to integrate and customize the AIsuru web component in your applications

## Overview

This module covers web component programming techniques to create context-aware AI experiences embedded in web pages.

📁 **Full Guide**: [web_component/README.md](./web_component/README.md)

---

## Quick Start

```bash
# Navigate to the demo folder
cd web_component/demo
```

Create a file named `.env_dev` in the `demo/` folder (first time only) with the following content:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

```bash
# Build and start the application (single command)
npm run start

# Open in your browser
open http://localhost:13005
```

> ℹ️ This demo's `web` service is mapped to host port **13005** (instead of 3000) so it can run at the same time as the other demos.

> 💡 **Windows users — if `npm run start` fails:** Git on Windows may convert line endings to CRLF, which breaks shell scripts inside Docker. Run this command once in your terminal and then retry:
> ```bash
> git config --global core.autocrlf false
> ```

---

🏠 [Course Home](../README.md)
