# Debug: Integrazione MCP Server Remoto con Aisuru AI

## 📋 Sommario Problema

Il gateway MCP di Aisuru (`mcp-aisuru-gateway.slnode.net`) risponde con **503 Service Unavailable** quando tenta di connettersi a un server MCP custom esposto via HTTPS/ngrok, anche se il server MCP funziona correttamente con client MCP standard.

---

## 🔧 Setup Tecnico

### Server MCP Filesystem
- **Tecnologia**: Node.js con `@modelcontextprotocol/sdk` v1.0.0
- **Transport**: SSEServerTransport (Server-Sent Events)
- **Porta locale**: 8000
- **URL pubblico**: https://inviting-eminent-piglet.ngrok-free.app/mcp (via ngrok)

### Endpoints Esposti
- `GET /mcp` - Stabilisce connessione SSE
- `POST /messages?sessionId={id}` - Riceve messaggi JSON-RPC
- `GET /health` - Health check

### Tools Disponibili
1. `list_files` - Lista file nella workspace
2. `read_file` - Legge contenuto file
3. `write_file` - Modifica file esistente
4. `create_file` - Crea nuovo file

---

## ✅ Test Funzionanti

### 1. Health Check
```bash
curl https://inviting-eminent-piglet.ngrok-free.app/health
# Risposta: {"status":"ok","workspace":"/workspace"}
```

### 2. Client MCP Standard
Test con SDK MCP ufficiale:
```javascript
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { SSEClientTransport } from '@modelcontextprotocol/sdk/client/sse.js';

const client = new Client({ name: 'test', version: '1.0.0' }, { capabilities: {} });
const transport = new SSEClientTransport(new URL('https://inviting-eminent-piglet.ngrok-free.app/mcp'));
await client.connect(transport);

const tools = await client.listTools();
// ✅ SUCCESSO: Recupera lista di 4 tools
```

**Risultato**: ✅ Il server MCP funziona correttamente con client standard

---

## ❌ Errore con Aisuru

### Configurazione su Aisuru
```
Nome: Filesystem MCP Server
URL: https://inviting-eminent-piglet.ngrok-free.app/mcp
Token: [vuoto]
Prompt: [descrizione tools]
```

### Errore Gateway Aisuru
```
Function Call to "LISTA_TOOLS_FILESYSTEM_MCP_SERVER_MCP_PROD"
Result: Exception caught while executing function
Call to endpoint "https://mcp-aisuru-gateway.slnode.net:443/api/v1/mcp_servers/698449817930e4f0e4adcb86/tools"
Status: ServiceUnavailable - Service Unavailable (503)
```

### Osservazioni
1. **Nessuna richiesta arriva al server MCP** - I log del server non mostrano tentativi di connessione dal gateway Aisuru
2. **Il gateway non riesce a connettersi** - Risponde 503 senza tentare la connessione SSE
3. **L'ID server è generato**: `698449817930e4f0e4adcb86`

---

## 🔍 Analisi Problema

### Comportamento Gateway Aisuru
Il gateway Aisuru sembra:
1. Ricevere la configurazione del server MCP custom
2. Generare funzioni automatiche (LISTA_TOOLS, ESEGUI_TOOL)
3. **Fallire** nel tentativo di connessione SSE al server remoto
4. Rispondere 503 senza logging/debugging disponibile

### Differenze con Server MCP Locale
Il server `mcp-js-executor` (funzionante con Aisuru) usa:
- **StdioServerTransport** (stdin/stdout)
- Eseguito localmente sull'engine Aisuru
- **NON** esposto via HTTPS

Questo suggerisce che Aisuru supporta:
- ✅ Server MCP locali (stdio)
- ❓ Server MCP remoti (SSE/HTTPS) - **da verificare/implementare**

---

## 🐛 Debug Necessario

### 1. Log Gateway Aisuru
**Domande per il team Aisuru:**
- Ci sono log del gateway quando tenta di connettersi?
- Quale errore specifico causa il 503?
- Il gateway tenta effettivamente la connessione GET al /mcp endpoint?

### 2. Configurazione Gateway
**Verificare:**
- Il gateway supporta connessioni SSE a server remoti?
- Ci sono timeout o limitazioni specifiche?
- Il gateway gestisce correttamente l'evento "endpoint" SSE?

### 3. Test con Server MCP Pubblico
**Proposta:**
- Testare con un server MCP pubblico noto funzionante
- Verificare se il problema è specifico al nostro server o generale

---

## 🛠️ CORS Headers (già configurati)

Il server espone correttamente gli header CORS:
```javascript
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, Cache-Control
Access-Control-Allow-Credentials: true
```

---

## 📊 Protocollo MCP SSE

### Flow Connessione Corretta
1. **Client → GET /mcp** (stabilisce stream SSE)
2. **Server → evento "endpoint"** con URL per messaggi
   ```
   event: endpoint
   data: https://inviting-eminent-piglet.ngrok-free.app/messages?sessionId=xxx
   ```
3. **Client → POST /messages?sessionId=xxx** (invia richieste JSON-RPC)
4. **Server → eventi SSE** con risposte

### Implementazione Server
Il server usa il pattern corretto:
- Crea una nuova istanza `Server` per ogni connessione
- Usa `SSEServerTransport` con endpoint "/messages"
- Riscrive l'endpoint da relativo ad assoluto per ngrok:
  ```javascript
  chunk.replace(/data: (\/messages[^\n]*)/, `data: https://${host}$1`);
  ```

---

## 🎯 Soluzioni Possibili

### Opzione 1: Fix Gateway Aisuru
Il gateway dovrebbe:
1. Fare GET all'URL configurato (/mcp)
2. Parsare l'evento SSE "endpoint"
3. Usare l'URL completo per POST ai messaggi
4. Mantenere la connessione SSE aperta per ricevere risposte

### Opzione 2: Wrapper HTTP REST
Creare un layer intermedio che:
- Si connette al server MCP via SSE
- Espone endpoint REST semplici per Aisuru
- Gestisce la complessità SSE internamente

### Opzione 3: Documentare Limitazioni
Se il gateway non supporta SSE remoti:
- Documentare che solo server MCP locali (stdio) sono supportati
- Fornire istruzioni per deploy locale di server custom

---

## 📝 Richieste al Team Aisuru

1. **Log completi** del tentativo di connessione dal gateway
2. **Conferma supporto** per server MCP remoti via SSE
3. **Documentazione** del protocollo che il gateway si aspetta
4. **Test endpoint** pubblico per verificare configurazione corretta

---

## 🔗 Risorse

### Server MCP Funzionante (test)
- URL: `https://inviting-eminent-piglet.ngrok-free.app/mcp`
- Health: `https://inviting-eminent-piglet.ngrok-free.app/health`
- Disponibile per test del team Aisuru

### Codice Sorgente
- Server: `/manage_login/demo/docker/mcp-server/server.js`
- SDK: `@modelcontextprotocol/sdk` v1.0.0
- Transport: SSEServerTransport

### Log Server MCP
```
[mcp-filesystem-server] Listening on port 8000
[mcp-filesystem-server] SSE session established: {sessionId}
[mcp-filesystem-server] Host header: inviting-eminent-piglet.ngrok-free.app
[mcp-filesystem-server] Endpoint rewrite: /messages?sessionId=xxx → https://inviting-eminent-piglet.ngrok-free.app/messages?sessionId=xxx
```

---

## 📞 Contatti

**Team**: SYS-06 MCP Server Integration
**Disponibilità**: Per call di debug/troubleshooting
**Obiettivo**: Documentare soluzione per corso e doc Aisuru

---

**Data Report**: 2026-02-05
**Status**: In attesa feedback team Aisuru su supporto SSE remoto
