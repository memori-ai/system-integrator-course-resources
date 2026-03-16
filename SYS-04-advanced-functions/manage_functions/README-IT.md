# Funzioni Avanzate con AIsuru

> Guida completa alla creazione e integrazione di funzioni avanzate per estendere le capacità del tuo agente AIsuru

## 🎯 Panoramica

Questa guida spiega come creare funzioni avanzate che permettono ai tuoi agenti AIsuru di interagire con REST API e servizi esterni. Imparerai a:

- Creare funzioni personalizzate che recuperano dati in tempo reale da API esterne
- Configurare webhook e parametri HTTP
- Auto-generare multiple funzioni da specifiche OpenAPI/Swagger
- Collegare funzioni ai tuoi agenti e configurare il loro utilizzo
- Debuggare e verificare le chiamate alle funzioni nelle conversazioni

## 🚀 Prova le Demo

Questo modulo include **demo applicative funzionanti** che mostrano diversi approcci alla creazione e utilizzo di funzioni avanzate.

### Avviare le Demo

```bash
# Naviga nella cartella demo
cd demo
```

Crea un file chiamato `.env_dev` nella cartella `demo/` (solo la prima volta) con il seguente contenuto:

```
MONGO_URI=mongodb://mongodb:27017/sys_04_advanced_functions_development
```

```bash
# Costruisci e avvia l'applicazione (comando unico)
npm run start

# Apri nel browser
open http://localhost:3000
```

### Demo 1: Collegare Agenti a Servizi REST

Impara come collegare il tuo agente a REST API esterne usando un esempio di dati meteo.

- Creare una funzione avanzata nella piattaforma AIsuru
- Configurare URL webhook e parametri HTTP
- Usare variabili template per dati dinamici
- Collegare la funzione al tuo agente
- Testare e verificare le chiamate API nelle conversazioni

**Caso d'uso:** Agenti che necessitano di recuperare dati in tempo reale da servizi esterni (meteo, prezzi azioni, notizie, ecc.)

### Demo 2: Usare File Swagger

Impara come auto-generare multiple funzioni da specifiche OpenAPI/Swagger.

- Scaricare e preparare file Swagger/OpenAPI
- Importare specifiche in AIsuru
- Auto-generare multiple funzioni contemporaneamente
- Rivedere e selezionare funzioni rilevanti
- Configurare e testare funzioni importate

**Caso d'uso:** Integrare rapidamente API complesse con documentazione esistente

📁 **Codice Sorgente Demo**: [demo/](./demo/)

---

## 📋 Prerequisiti

Prima di iniziare, hai bisogno di:

1. Un **account AIsuru** su [aisuru.com](https://www.aisuru.com)
2. Un **Agente AI (Memori)** configurato nel tuo account
3. Accesso alla sezione **Funzioni Avanzate** nelle impostazioni del tuo agente
4. Conoscenza base di REST API e metodi HTTP

---

## 🔧 Creare la Tua Prima Funzione Avanzata

### Step 1: Navigare nelle Funzioni Avanzate

Nel tuo dashboard agente AIsuru:

1. Clicca su **Funzioni Avanzate** nel menu laterale sinistro
2. Clicca **Crea Nuova Funzione**

### Step 2: Configurare la Funzione

Compila i dettagli della funzione:

| Campo           | Descrizione                   | Esempio                                               |
| --------------- | ----------------------------- | ----------------------------------------------------- |
| **Nome**        | Identificatore della funzione | `FUNZIONE_RECUPERA_DATI_METEO`                        |
| **Descrizione** | Cosa fa la funzione           | "Recupera informazioni meteo per una città specifica" |
| **URL Webhook** | Endpoint API esterno          | `https://api.open-meteo.com/v1/forecast`              |
| **Metodo HTTP** | Metodo HTTP                   | `GET` o `POST`                                        |

### Step 3: Configurare i Parametri

Usa variabili template nella query string o nel body della richiesta:

```
latitude={lat}&longitude={lon}&hourly=temperature_2m,precipitation&forecast_days=3
```

**Variabili Template:**

- Usa il formato `{nome_variabile}`
- L'agente popolerà queste variabili in base alle richieste degli utenti
- Le variabili devono essere spiegate nel prompt dell'agente

### Step 4: Collegare al Tuo Agente

1. Vai su **Impostazioni Agente → Funzioni Avanzate**
2. Aggiungi la funzione appena creata
3. Salva la configurazione

### Step 5: Aggiornare il Prompt dell'Agente

Istruisci il tuo agente su come usare la funzione nel prompt:

```
Sei un assistente meteo. Quando gli utenti chiedono del meteo:
1. Estrai il nome della città dalla richiesta
2. Determina le coordinate di latitudine e longitudine
3. Usa FUNZIONE_RECUPERA_DATI_METEO con i parametri lat e lon
4. Presenta le informazioni meteo in modo chiaro
```

---

## 📊 Usare File OpenAPI/Swagger

### Perché Usare File Swagger?

Le specifiche OpenAPI (Swagger) offrono diversi vantaggi:

- ✅ **Generazione automatica**: Crea multiple funzioni in una volta sola
- ✅ **Consistenza**: Tutti gli endpoint e i parametri sono standardizzati
- ✅ **Risparmio di tempo**: Perfetto per API complesse con molti endpoint
- ✅ **Accuratezza**: Usa specifiche API ufficiali

### Importare un File Swagger

1. **Ottenere il file Swagger/OpenAPI**
   - Scarica dalla documentazione API
   - Oppure esporta dalla tua API

2. **Navigare nelle Funzioni Avanzate**
   - Clicca su **"Converti OpenAPI in funzioni"**

3. **Configurare l'importazione**
   - **URL base webhook**: es. `https://engine.memori.ai`
   - **Carica file**: Seleziona il tuo file `.json` o `.yaml`

4. **Rivedere le funzioni generate**
   - AIsuru crea una funzione per ogni endpoint API
   - Ogni funzione include parametri e descrizioni
   - Seleziona quali funzioni abilitare

5. **Collegare agli agenti**
   - Aggiungi funzioni rilevanti ai tuoi agenti
   - Aggiorna i prompt per spiegare quando usare ogni funzione

---

## 🔐 Testare il Tuo Agente

### Ottenere le Credenziali dell'Agente

Naviga al tuo agente in AIsuru, poi clicca su **Dev docs** nel menu laterale sinistro.

Troverai:

| Campo                      | Posizione           | Esempio                                |
| -------------------------- | ------------------- | -------------------------------------- |
| **Memori (Agente) ID**     | Sezione principale  | `a1b2c3d4-e5f6-7890-abcd-ef1234567890` |
| **ID Utente proprietario** | ▼ Altri riferimenti | `c3d4e5f6-a7b8-9012-cdef-123456789012` |
| **Engine URL**             | Sezione principale  | `https://engine.memori.ai/memori/v2`   |
| **Backend URL**            | Sezione principale  | `https://backend.memori.ai/api/v2`     |

### Testare nel Web Component

Usa queste credenziali per configurare il web component nelle applicazioni demo:

```html
<memori-client
  memoriName="NomeDelTuoAgente"
  ownerUserName="tuo.username"
  memoriID="IL_TUO_MEMORI_ID"
  ownerUserID="IL_TUO_OWNER_USER_ID"
  tenantID="www.aisuru.com"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://www.aisuru.com"
  layout="CHAT"
  uiLang="IT"
  spokenLang="IT"
  showLogin="true"
></memori-client>
```

---

## 🎛️ Configurazione Avanzata delle Funzioni

### Struttura JSON delle Funzioni

Quando crei funzioni avanzate, AIsuru le memorizza in questo formato:

```json
{
  "name": "FUNZIONE_RECUPERA_DATI_METEO",
  "description": "Recupera informazioni meteo per coordinate specifiche",
  "webhook": "https://api.open-meteo.com/v1/forecast",
  "method": "GET",
  "queryParams": "latitude={lat}&longitude={lon}&hourly=temperature_2m,precipitation",
  "headers": {},
  "bodyTemplate": null,
  "timeout": 30000
}
```

### Parametri HTTP Supportati

#### Query Parameters (GET)

Aggiungi parametri nella query string:

```
?param1={var1}&param2={var2}&param3=valore_fisso
```

**Esempio:**
```
?city={city_name}&units=metric&appid=your_api_key
```

#### Request Body (POST/PUT)

Per richieste POST/PUT, usa il template body in formato JSON:

```json
{
  "query": "{user_query}",
  "filters": {
    "category": "{category}",
    "limit": 10
  }
}
```

#### Headers Personalizzati

Configura headers per autenticazione e content-type:

```
Authorization: Bearer {api_token}
Content-Type: application/json
X-Custom-Header: valore
```

**Note di sicurezza:**
- Non includere mai chiavi API nel prompt dell'agente
- Usa la sezione Headers nelle impostazioni della funzione
- Per produzione, usa variabili d'ambiente o vault

### Variabili Template

Le variabili template seguono il formato `{nome_variabile}`:

| Variabile | Descrizione | Esempio di valore |
|-----------|-------------|-------------------|
| `{query}` | Query utente completa | "Cerca hotel a Roma" |
| `{city}` | Nome città estratto | "Roma" |
| `{date}` | Data estratta | "2024-03-15" |
| `{user_id}` | ID utente (se autenticato) | "user_12345" |

**L'agente popola automaticamente queste variabili** basandosi su:
1. Input dell'utente
2. Contesto della conversazione
3. Istruzioni nel prompt sistema

---

## 📡 Schema delle Funzioni REST

### Anatomia di una Chiamata Funzione

```
1. Input Utente
   ↓
2. Agente analizza e estrae parametri
   ↓
3. Popola template con variabili
   ↓
4. Invia richiesta HTTP all'endpoint
   ↓
5. Riceve risposta API
   ↓
6. Processa e presenta dati all'utente
```

### Formato Richiesta

**GET Request:**
```http
GET /v1/forecast?latitude=41.9&longitude=12.5&hourly=temperature_2m HTTP/1.1
Host: api.open-meteo.com
User-Agent: AIsuru-Agent/1.0
```

**POST Request:**
```http
POST /v1/search HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer abc123

{
  "query": "hotel Roma",
  "filters": {
    "stars": 4,
    "price_max": 150
  }
}
```

### Formato Risposta

AIsuru supporta risposte JSON standard:

**Successo (200-299):**
```json
{
  "status": "success",
  "data": {
    "temperature": 22.5,
    "humidity": 65,
    "forecast": [...]
  }
}
```

**Errore (400-599):**
```json
{
  "status": "error",
  "message": "Parametro mancante: latitude",
  "code": "MISSING_PARAMETER"
}
```

L'agente riceve **l'intera risposta** e può:
- Estrarre dati rilevanti
- Gestire errori
- Formattare output per l'utente

---

## ⚙️ Gestione Errori e Timeout

### Timeout Configuration

Configura timeout personalizzati nelle impostazioni funzione:

| Timeout | Uso Consigliato |
|---------|-----------------|
| 5-10s | API veloci (geocoding, cache) |
| 10-30s | API standard (meteo, notizie) |
| 30-60s | API lente (elaborazione dati, ML) |

**Default:** 30 secondi

### Gestire Errori nell'Agente

Istruisci l'agente nel prompt su come gestire fallimenti:

```
Quando chiami FUNZIONE_RECUPERA_DATI_METEO:

SE la funzione restituisce un errore:
- Informati l'utente gentilmente
- Suggerisci alternative (es. "Prova con una città vicina")
- Non mostrare dettagli tecnici all'utente

SE timeout:
- Dì: "Il servizio meteo sta impiegando più tempo del solito, riprova tra poco"

SE 404/Non trovato:
- Dì: "Non ho trovato informazioni meteo per quella posizione"
- Chiedi di verificare l'ortografia o provare con una città vicina
```

### Codici di Stato HTTP Comuni

| Codice | Significato | Azione Agente |
|--------|-------------|---------------|
| 200-299 | Successo | Processa e presenta dati |
| 400 | Bad Request | Controlla parametri richiesta |
| 401 | Unauthorized | Verifica autenticazione |
| 404 | Not Found | Risorsa non esiste |
| 429 | Too Many Requests | Rate limit, riprova dopo |
| 500-599 | Server Error | Servizio temporaneamente non disponibile |

### Retry Logic

Per API critiche, istruisci l'agente a ritentare:

```
Se la chiamata alla funzione fallisce con 500 o timeout:
1. Attendi 2 secondi
2. Riprova una volta
3. Se fallisce ancora, informa l'utente del problema temporaneo
```

---

## 🐛 Debuggare le Chiamate alle Funzioni

### Usare la Vista Debug

Dopo aver testato il tuo agente, verifica le chiamate alle funzioni:

1. Naviga su **"Conversazioni"** nel tuo dashboard AIsuru
2. Trova la conversazione dove la funzione è stata chiamata
3. Cerca l'**icona bug rossa** 🐛 accanto alla risposta dell'agente
4. Cliccaci sopra per vedere:
   - Parametri della richiesta inviati all'API
   - Codice di stato HTTP
   - Dati completi della risposta
   - Messaggi di errore (se presenti)

### Problemi Comuni

| Problema              | Causa                              | Soluzione                                                           |
| --------------------- | ---------------------------------- | ------------------------------------------------------------------- |
| Funzione non chiamata | L'agente non capisce quando usarla | Aggiorna il prompt con istruzioni più chiare                        |
| Parametri mancanti    | Variabili template non popolate    | Assicurati che l'agente estragga i dati richiesti dall'input utente |
| Errori HTTP (4xx/5xx) | Richiesta API non valida           | Controlla URL webhook, parametri e autenticazione                   |
| Risposta vuota        | L'API non ha restituito dati       | Verifica che endpoint e parametri API siano corretti                |

---

## 💡 Best Practices

### Design delle Funzioni

- **Nomi chiari**: Usa nomi funzione descrittivi (es. `GET_WEATHER_DATA` non `FUNC1`)
- **Scopo specifico**: Ogni funzione dovrebbe fare una cosa bene
- **Gestione errori**: Considera cosa succede quando le API falliscono
- **Documentazione**: Scrivi descrizioni chiare per ogni funzione

### Configurazione Agente

- **Istruzioni esplicite**: Dì all'agente esattamente quando usare ogni funzione
- **Estrazione parametri**: Spiega come estrarre parametri dall'input utente
- **Formattazione risposta**: Istruisci su come presentare i dati API agli utenti
- **Comportamento di fallback**: Definisci cosa fare quando le funzioni falliscono

### Strategia di Testing

1. **Inizia semplice**: Testa prima con input conosciuti
2. **Controlla vista debug**: Verifica sempre le chiamate alle funzioni
3. **Testa casi limite**: Prova input non validi, fallimenti API, ecc.
4. **Monitora conversazioni**: Rivedi come gli utenti interagiscono con le funzioni

---

## 📝 Esempio Completo: Funzione Meteo

Ecco un esempio completo dalla creazione al test:

### 1. Creare la Funzione

```
Nome: FUNZIONE_RECUPERA_DATI_METEO
Descrizione: Recupera le previsioni meteo per una città
Webhook: https://api.open-meteo.com/v1/forecast
Metodo: GET
Query String: latitude={lat}&longitude={lon}&hourly=temperature_2m,precipitation&forecast_days=3
```

### 2. Aggiornare il Prompt dell'Agente

```
Sei un assistente meteo utile. Quando gli utenti chiedono del meteo:

1. Estrai il nome della città dalla loro domanda
2. Usa la tua conoscenza per determinare la latitudine e longitudine approssimative
3. Chiama FUNZIONE_RECUPERA_DATI_METEO con le coordinate
4. Presenta le previsioni di temperatura e precipitazioni in modo amichevole

Esempio:
Utente: "Che tempo fa a Roma?"
Tu: [Estrai città: Roma → Coordinate: lat=41.9, lon=12.5 → Chiama funzione → Presenta risultati]
"A Roma, la temperatura attuale è 22°C con una probabilità di pioggia del 30% oggi..."
```

### 3. Testare l'Agente

```
Utente: "Che tempo fa a Londra?"
Atteso: L'agente chiama la funzione con lat≈51.5, lon≈-0.1 e restituisce le previsioni
```

### 4. Verificare nella Vista Debug

Controlla che:

- ✅ La funzione è stata chiamata
- ✅ I parametri erano corretti (lat e lon)
- ✅ L'API ha restituito 200 OK
- ✅ La risposta contiene dati meteo

---

## 🎨 Tecniche Avanzate

### Concatenamento Funzioni

Chiama multiple funzioni in sequenza:

```
1. GET_CITY_COORDINATES (city_name) → restituisce {lat, lon}
2. GET_WEATHER_DATA (lat, lon) → restituisce meteo
3. GET_TIMEZONE (lat, lon) → restituisce timezone
```

### Funzioni Context-Aware

Usa il contesto della conversazione per popolare i parametri:

```
Utente: "Sono a Milano"
Agente: [memorizza contesto posizione]
Utente: "Che tempo fa?"
Agente: [usa Milano dal contesto → chiama funzione meteo]
```

### Header di Autenticazione

Per API che richiedono autenticazione:

```
Headers:
Authorization: Bearer {api_key}
X-API-Key: {api_key}
```

Configurali nelle impostazioni della funzione, non nel prompt dell'agente.

---

## 📂 Struttura del Modulo

```
SYS-04-advanced-functions/
├── README.md          # Panoramica modulo (EN)
├── README-IT.md       # Panoramica modulo (IT)
└── manage_functions/  # Demo app funzioni avanzate
    ├── README.md      # Guida completa (EN)
    ├── README-IT.md   # Questo file — guida completa (IT)
    └── demo/          # Applicazione Rails con demo funzioni
```

## 🔗 Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Guida Funzioni Avanzate](https://docs.aisuru.com/advanced-functions)
- [Riferimento API](https://docs.aisuru.com/api-reference)
- [Specifica OpenAPI](https://swagger.io/specification/)
- [Pacchetto NPM Web Component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

🏠 [Home del Corso](../../README.md)
