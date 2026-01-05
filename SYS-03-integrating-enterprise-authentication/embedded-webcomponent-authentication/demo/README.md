# Embedded Web Component Authentication Demo

This demo shows how to embed the AIsuru web component with built-in authentication (`showLogin="true"`).

## 🚀 Quick Start

```bash
# Install dependencies (first time only)
docker compose run --rm web bundle install

# Build and start the application
docker compose up

# Visit the application
open http://localhost:3000
```

## 📋 What This Demo Shows

1. **Configuration Form**: Enter your AIsuru agent credentials (Memori ID and Owner User ID)
2. **Web Component**: The AIsuru chat widget loads with your agent
3. **Built-in Login**: The `showLogin="true"` attribute enables the authentication panel

## 🔧 How to Get Your Agent IDs

1. Go to [AIsuru](https://www.aisuru.com) and create an agent (or use your PaaS tenant)
2. Open your agent and navigate to **Dev Docs**
3. Go to **"Accesso alle API"** tab
4. Expand **"Altri riferimenti"** section
5. Copy:
   - **Memori (Agente) ID secondario** → `memoriID`
   - **ID Utente proprietario** → `ownerUserID`

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

## 📁 Key Files

- `app/views/home/index.html.erb` - Main page with form and web component
- `app/controllers/home_controller.rb` - Controller logic
- `app/views/layouts/application.html.erb` - Layout with AIsuru scripts

## 🔗 Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)
- [PwlUser API Reference](https://docs.aisuru.com/api/backend/pwluser)

---

📚 Part of the [AIsuru System Integrator Course](https://github.com/memori-ai/system-integrator-course-resources)

