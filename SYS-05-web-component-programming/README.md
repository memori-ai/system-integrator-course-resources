# SYS-05: Web Component Programming

How to embed and program the AIsuru web component in your own pages.

[Versione italiana](./README-IT.md)

## Overview

The module covers the techniques that make an embedded agent aware of the page it lives in, and that let its answers act on that page.

Full guide: [web_component/README.md](./web_component/README.md) ([Italian version](./web_component/README-IT.md))

## Quick start

```bash
cd web_component/demo
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

---

[Course home](../README.md)
