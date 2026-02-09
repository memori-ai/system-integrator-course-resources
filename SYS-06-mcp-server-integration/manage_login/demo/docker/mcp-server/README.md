# MCP Filesystem Server

Server MCP (Model Context Protocol) che espone operazioni filesystem via SSE (Server-Sent Events).

## 🚀 Avvio Rapido

```bash
cd manage_login/demo
docker-compose up --build mcp-server
```

Il server sarà disponibile su `http://localhost:8000`

## 🛠️ Tool Disponibili

### 1. list_files
Lista file e directory nella workspace.

**Parametri:**
- `path` (string, opzionale): percorso relativo (default: root)

**Esempio:**
```json
{
  "tool": "list_files",
  "arguments": { "path": "." }
}
```

### 2. read_file
Legge il contenuto di un file.

**Parametri:**
- `path` (string, obbligatorio): percorso del file

**Esempio:**
```json
{
  "tool": "read_file",
  "arguments": { "path": "notes.md" }
}
```

### 3. write_file
Sovrascrive un file esistente.

**Parametri:**
- `path` (string, obbligatorio): percorso del file
- `content` (string, obbligatorio): nuovo contenuto

**Esempio:**
```json
{
  "tool": "write_file",
  "arguments": {
    "path": "notes.md",
    "content": "Nuovo contenuto"
  }
}
```

### 4. create_file
Crea un nuovo file.

**Parametri:**
- `path` (string, obbligatorio): percorso del file
- `content` (string, obbligatorio): contenuto iniziale

**Esempio:**
```json
{
  "tool": "create_file",
  "arguments": {
    "path": "nuovo.txt",
    "content": "Contenuto iniziale"
  }
}
```

## 🌐 Endpoint

### GET /mcp
Stabilisce connessione SSE per il protocollo MCP.

### POST /messages?sessionId={id}
Riceve messaggi JSON-RPC dal client MCP.

### GET /health
Health check del server.

**Risposta:**
```json
{"status": "ok", "workspace": "/workspace"}
```

## 🔧 Configurazione

### Variabili Ambiente

- `WORKSPACE_ROOT`: Directory workspace (default: `/workspace`)
- `PORT`: Porta server (default: `8000`)

### Docker Compose

```yaml
mcp-server:
  build:
    context: ./docker/mcp-server
  ports:
    - "8000:8000"
  volumes:
    - ./test:/workspace
  environment:
    - WORKSPACE_ROOT=/workspace
    - PORT=8000
```

## 📡 Esposizione Pubblica con Ngrok

### Con Docker Compose
Il `docker-compose.yml` include già ngrok:

```bash
docker-compose up --build
docker-compose logs ngrok | grep "started tunnel"
```

Copia l'URL pubblico (es: `https://xxx.ngrok-free.dev`)

### Manualmente
```bash
ngrok http 8000
```

## 🔌 Integrazione con Aisuru AI

### 1. Configurazione Server MCP

Su Aisuru.com:
1. Vai su **Agent Settings → MCP Servers**
2. Clicca **"Aggiungi Server MCP Personalizzato"**
3. Compila:
   - **Nome**: `Filesystem MCP Server`
   - **URL**: `https://[ngrok-url]/mcp`
   - **Prompt**:
     ```
     This MCP server provides filesystem operations:
     - list_files(path): List files and directories
     - read_file(path): Read file content
     - write_file(path, content): Update existing file
     - create_file(path, content): Create new file

     All paths are relative to workspace root.
     ```

### 2. Test

Chiedi all'agente Aisuru:
```
"List the files in the workspace"
"Read the file notes.md"
"Create a file called test.txt with content 'Hello World'"
```

## 🔒 Sicurezza

- ✅ Path traversal protection: impedisce accesso a `../../`
- ✅ Workspace isolata: accesso solo a `/workspace`
- ✅ CORS configurato per connessioni esterne
- ⚠️ **NON esporre** directory sensibili nella workspace

## 🐛 Troubleshooting

### Server non risponde
```bash
docker-compose logs mcp-server
```

### Ngrok non funziona
```bash
# Verifica che NGROK_AUTHTOKEN sia configurato in .env_dev
docker-compose logs ngrok
```

### Test locale
```bash
curl http://localhost:8000/health
# Risposta attesa: {"status":"ok","workspace":"/workspace"}
```

## 📚 Riferimenti

- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Aisuru MCP Integration](https://aisuru.com)
- [SDK MCP](https://github.com/modelcontextprotocol/sdk)
