# Autenticazione Web Component Embedded

> Guida completa alla configurazione del web component AIsuru con autenticazione per scenari embedded

## Panoramica

Questa guida spiega come integrare il web component AIsuru nelle tue applicazioni e configurare l'autenticazione per fornire esperienze AI personalizzate. Imparerai a:

- Configurare il web component con le credenziali del tuo agente
- Passare token di autenticazione per utenti loggati
- Usare variabili di contesto e domande iniziali
- Implementare flussi di autenticazione sicuri

---

## Prerequisiti

Prima di iniziare, hai bisogno di:

1. Un **account AIsuru** su [aisuru.com](https://www.aisuru.com)
2. Un **Agente AI (Memori)** configurato nel tuo account
3. Accesso alla sezione **Dev Docs** del tuo agente
4. Conoscenza base di HTML e JavaScript

> ⚠️ **Docker Desktop obbligatorio** — L'applicazione demo gira interamente in container Docker. Assicurati di avere [Docker Desktop](https://www.docker.com/products/docker-desktop/) installato e avviato sulla tua macchina prima di eseguire `npm run start`.

---

## Applicazione Demo

Questo modulo include **quattro demo applicative funzionanti** realizzate con Ruby on Rails 8 + MongoDB che mostrano diversi approcci all'autenticazione.

![Pagina di Selezione Demo](./img/home.png)

### Quick Start

```bash
# Naviga nella cartella demo
cd demo
```

Crea un file chiamato `.env_dev` nella cartella `demo/` (solo la prima volta) con il seguente contenuto:

```
MONGO_URI=mongodb://mongodb:27017/embedded_webcomponent_auth_development
```

```bash
# Costruisci e avvia l'applicazione (comando unico)
npm run start

# Apri nel browser
open http://localhost:3000
```

> 💡 **Utenti Windows — se `npm run start` non funziona:** Git su Windows può convertire automaticamente i line endings in CRLF, causando errori negli script shell dentro Docker. Esegui questo comando una volta dal terminale e poi riprova:
> ```bash
> git config --global core.autocrlf false
> ```

### Demo Disponibili

#### Demo 1: Login Autonomo (`showLogin="true"`)

L'approccio più semplice dove il web component gestisce l'autenticazione autonomamente.

- Configura il web component con le credenziali dell'agente
- Gli utenti accedono tramite il pannello di autenticazione integrato
- Non richiede modifiche al backend

**Ideale per:** Siti pubblici, integrazione rapida, nessuna modifica al backend richiesta.

#### Demo 2: Autenticazione Programmatica con Trusted App

Autenticazione backend usando l'API `LoginWithJWT` per un'esperienza SSO senza interruzioni.

- Crea e configura una Trusted App nel tuo tenant
- Il tuo backend autentica gli utenti via `LoginWithJWT`
- Passa il token al web component tramite `additionalInfo.loginToken`
- Credenziali demo: `demo@demo.com` / `demodemo`

**Ideale per:** Applicazioni enterprise, sistemi utente esistenti, requisiti SSO.

#### Demo 3: Microsoft SSO (Azure AD / Entra ID)

Integrazione completa Single Sign-On con la piattaforma di identità Microsoft.

- Configura una Azure App Registration con il tuo `clientId`
- Usa MSAL.js per l'autenticazione Microsoft nel browser
- Concatena autenticazione Microsoft → `LoginWithJWT` AIsuru per un SSO seamless
- Gli utenti sono pre-autenticati nel web component

**Ideale per:** Ambienti aziendali che usano Microsoft 365, applicazioni integrate con Azure AD.

#### Demo 4: Login con Redirect

Autentica gli utenti nella tua app, poi reindirizzali alla piattaforma AIsuru.

- Flusso di login aziendale con le tue credenziali
- Usa `LoginWithJWT` per ottenere un token AIsuru
- Redirect a `https://{tenant}/{lang}/magiclink/{token}`
- Gli utenti arrivano sull'interfaccia completa AIsuru, già autenticati
- Credenziali demo: `demo@demo.com` / `demodemo`

**Ideale per:** Portali enterprise, siti intranet, quando vuoi gli utenti sull'interfaccia completa AIsuru.

### Struttura del Progetto

```
demo/
├── app/
│   ├── controllers/
│   │   ├── home_controller.rb      # Pagina di selezione demo
│   │   ├── demo1_controller.rb     # Demo 1: showLogin
│   │   ├── demo2_controller.rb     # Demo 2: autenticazione Trusted App
│   │   ├── demo3_controller.rb     # Demo 3: Microsoft SSO
│   │   └── demo4_controller.rb     # Demo 4: Redirect ad AIsuru
│   ├── models/
│   │   └── user.rb                 # Modello utente (Demo 2, 3, 4)
│   ├── services/
│   │   └── aisuru_auth_service.rb  # Integrazione API AIsuru
│   └── views/
│       ├── home/index.html.erb     # Selezione demo
│       ├── demo1/index.html.erb    # Pagina Demo 1
│       ├── demo2/
│       │   ├── index.html.erb      # Pagina principale Demo 2
│       │   └── login.html.erb      # Pagina login Demo 2
│       ├── demo3/index.html.erb    # Pagina Demo 3 MS SSO
│       └── demo4/
│           ├── index.html.erb      # Pagina principale Demo 4
│           └── login.html.erb      # Pagina login Demo 4
├── docker-compose.yml
├── Dockerfile.dev
└── Gemfile
```

### Comandi Docker

```bash
# Avvia l'applicazione
docker compose up

# Avvia in background
docker compose up -d

# Ferma l'applicazione
docker compose down

# Visualizza i log
docker compose logs -f web

# Installa/aggiorna le gem
docker compose run --rm web bundle

# Rails console
docker compose run --rm web rails console
```

---

## Configurazione Base del Web Component

### Step 1: Includere il Web Component

Aggiungi queste due righe nel tuo HTML `<head>` o prima del tag di chiusura `</body>`:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Step 2: Ottenere le Credenziali del Tuo Agente

Naviga al tuo agente in AIsuru, poi clicca su **Dev docs** nel menu laterale sinistro.

Troverai:

| Campo | Descrizione | Esempio |
|-------|-------------|---------|
| **Memori (Agente) ID** | Identificatore univoco del tuo agente | `a1b2c3d4-e5f6-7890-abcd-ef1234567890` |
| **Engine URL** | Endpoint API per le conversazioni | `https://engine.memori.ai/memori/v2` |
| **Backend URL** | Endpoint API per operazioni backend | `https://backend.memori.ai/api/v2` |

Espandi la sezione **▼ Altri riferimenti** per trovare:

| Campo | Descrizione | Esempio |
|-------|-------------|---------|
| **Memori (Agente) ID secondario** | ID agente per il web component | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
| **ID Utente proprietario** | ID dell'utente proprietario | `c3d4e5f6-a7b8-9012-cdef-123456789012` |

### Step 3: Configurare il Web Component

Aggiungi il web component al tuo HTML:

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

## Configurazione dell'Autenticazione

### Passare un Token di Login

Quando hai utenti autenticati nella tua applicazione, puoi passare il loro token di autenticazione al web component usando l'attributo `additionalInfo`:

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
  showLogin="false"
  additionalInfo='{"loginToken":"IL_TOKEN_DI_LOGIN_UTENTE"}'
></memori-client>
```

> ⚠️ **Importante**: Quando passi un token di login, imposta `showLogin="false"` dato che l'utente è già autenticato.

### Iniezione Dinamica del Token (JavaScript)

Per applicazioni dinamiche, inietta il token via JavaScript:

```html
<memori-client id="memori-widget"></memori-client>

<script>
  const memoriWidget = document.getElementById('memori-widget');

  // Ottieni il token dell'utente dal tuo sistema di autenticazione
  const userToken = await getUserAuthToken();

  // Configura il widget
  memoriWidget.setAttribute('memoriName', 'NomeDelTuoAgente');
  memoriWidget.setAttribute('ownerUserName', 'tuo.username');
  memoriWidget.setAttribute('memoriID', 'IL_TUO_MEMORI_ID');
  memoriWidget.setAttribute('ownerUserID', 'IL_TUO_OWNER_USER_ID');
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

## Variabili di Contesto e Domande Iniziali

### Usare le Variabili di Contesto

Passa informazioni contestuali al tuo agente usando l'attributo `context`. Questo ti permette di personalizzare il comportamento dell'agente in base allo stato dell'utente o dell'applicazione:

```html
<memori-client
  ...
  context="AMBIENTE:PRODUZIONE,LINGUA:IT,USER_ID:12345,DEMO:FALSE"
></memori-client>
```

Le variabili di contesto sono passate come coppie `CHIAVE:VALORE` separate da virgola.

**Casi d'uso comuni:**
- `USER_ID`: Identificare l'utente corrente
- `LINGUA`: Impostare la lingua preferita
- `AMBIENTE`: Distinguere tra dev/staging/produzione
- `DEMO`: Abilitare/disabilitare modalità demo
- `RUOLO`: Ruolo utente (admin, user, guest)

### Impostare una Domanda Iniziale

Pre-popola la conversazione con una domanda o istruzione iniziale:

```html
<memori-client
  ...
  initialQuestion="Ciao! Ho bisogno di aiuto con il mio account."
></memori-client>
```

Può essere usato anche per dare istruzioni all'agente:

```html
<memori-client
  ...
  initialQuestion="Usa sempre un linguaggio formale e fornisci spiegazioni dettagliate."
></memori-client>
```

---

## Ottenere Token di Login via API

Per autenticare utenti programmaticamente, usa l'API Backend di AIsuru.

### Opzione 1: Login con Magic Link

Invia un magic link all'email dell'utente:

```bash
POST https://backend.memori.ai/api/v2/PwlLogin
Content-Type: application/json

{
  "tenant": "www.aisuru.com",
  "userName": "utente@esempio.com",
  "eMail": "utente@esempio.com"
}
```

### Opzione 2: Login con JWT (Trusted App)

Per integrazioni SSO aziendali, usa l'autenticazione basata su JWT. Richiede una **Trusted Application** (vedi sezione sotto):

```http
POST https://backend.memori.ai/api/v2/LoginWithJWT
Content-Type: application/json
X-Memori-Trusted-App: LA_TUA_CHIAVE_API_TRUSTED_APP

{
  "tenant": "www.aisuru.com",
  "jwtToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Risposta:**

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

Usa il valore `token` restituito nell'attributo `additionalInfo.loginToken`.

📖 **Riferimento API Completo**: [Documentazione API PwlUser](https://docs.aisuru.com/api/backend/pwluser)

---

## Applicazioni Fidate (Trusted Applications)

Per usare `LoginWithJWT` per l'autenticazione programmatica, hai bisogno di una **Trusted Application**.

### Cos'è una Trusted App?

Una Trusted Application è un modo sicuro per il tuo backend di comunicare con le API di AIsuru. Ti permette di:
- Autenticare utenti programmaticamente senza che inseriscano credenziali AIsuru
- Creare esperienze SSO senza interruzioni
- Gestire le sessioni utente dal tuo backend

### Creare una Trusted App

1. Accedi al tuo tenant AIsuru come **amministratore**
2. Vai su **Admin → Applicazioni Fidate** (o "Trusted Apps" in inglese)
3. Clicca **+ Crea** per aggiungere una nuova Trusted App
4. Compila:
   - **Nome**: Un nome descrittivo (es. "La Mia App Production")
   - **URL Base**: L'URL della tua applicazione (es. `http://localhost:3000`)
5. Salva e copia la **Chiave API**

> ⚠️ **Avviso di Sicurezza:** Non esporre mai la Chiave API della Trusted App nel codice frontend! Chiama sempre le API AIsuru dal tuo backend.

### Usare la Chiave API della Trusted App

Il flusso di autenticazione richiede due passaggi:

#### Passaggio 1: Creare un JWT firmato

Crea un token JWT firmato con la Chiave API della Trusted App usando l'algoritmo HS256. Nella demo app, questo è gestito da `app/services/aisuru_auth_service.rb`:

```javascript
// Codice backend (esempio Node.js)
const jwt = require('jsonwebtoken');

const trustedAppApiKey = process.env.AISURU_TRUSTED_APP_KEY;

const jwtToken = jwt.sign(
  {
    sub: user.email,
    email: user.email,
    name: user.name,
    tenant: 'www.aisuru.com',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 300  // 5 minuti
  },
  trustedAppApiKey,
  { algorithm: 'HS256' }
);
```

```ruby
# Codice backend (esempio Ruby - come usato nella demo app)
require 'jwt'

jwt_payload = {
  sub: user.email,
  email: user.email,
  name: user.name,
  tenant: tenant_id,
  iat: Time.now.to_i,
  exp: Time.now.to_i + 300  # 5 minuti
}

jwt_token = JWT.encode(jwt_payload, trusted_app_api_key, 'HS256')
```

#### Passaggio 2: Chiamare l'API LoginWithJWT

Effettua una richiesta POST al backend AIsuru con:
- **Header:** `X-Memori-Trusted-App` contenente la tua Chiave API
- **Body:** JSON con i campi `tenant` e `jwtToken`

```http
POST https://backend.memori.ai/api/v2/LoginWithJWT
Content-Type: application/json
X-Memori-Trusted-App: LA_TUA_CHIAVE_API_TRUSTED_APP

{
  "tenant": "www.aisuru.com",
  "jwtToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### Come Funziona LoginWithJWT (Demo 2 & 3)

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Il Tuo Utente │────▶│   Il Tuo Backend│────▶│  AIsuru API     │
│   (Browser)     │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       │                       │
        │ 1. Login              │ 2. Crea JWT           │
        │                       │ 3. Chiama LoginWithJWT│
        │                       │◀──────────────────────│
        │                       │ 4. Ricevi token       │
        │◀──────────────────────│                       │
        │ 5. Pagina con         │                       │
        │    loginToken impostato                       │
        ▼                       │                       │
┌─────────────────┐             │                       │
│ Web Component   │─────────────┼──────────────────────▶│
│ (autenticato)   │             │                       │
└─────────────────┘             │                       │
```

---

## Registrazione App Microsoft Azure (Demo 3)

Per usare la Demo 3, hai bisogno di una Azure App Registration.

### Step 1: Creare la App Registration

1. Vai al [Azure Portal](https://portal.azure.com)
2. Cerca **"Microsoft Entra ID"** (ex Azure AD)
3. Naviga su **Registrazioni app** → **+ Nuova registrazione**
4. Configura:
   - **Nome**: es. "AIsuru Demo App"
   - **Tipi di account supportati**:
     - "Account in qualsiasi directory organizzativa" per multi-tenant
     - "Account solo in questa directory organizzativa" per single-tenant
   - **URI di reindirizzamento**: Seleziona **"Applicazione a pagina singola (SPA)"** e inserisci `http://localhost:3000`

### Step 2: Ottenere le Credenziali

1. Dopo la registrazione, vai su **Panoramica**
2. Copia l'**ID applicazione (client)** — questo è il tuo `clientId`
3. Annota l'**ID directory (tenant)** se usi la modalità single-tenant

### Step 3: Configurare le Autorizzazioni API (opzionale)

Le autorizzazioni predefinite di solito funzionano, ma puoi verificare:
1. Vai su **Autorizzazioni API**
2. Assicurati che siano presenti:
   - `User.Read` (delegato)
   - `openid`, `profile`, `email` (delegato)

### Come Funziona la Demo 3

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Utente     │───▶│  MSAL.js     │───▶│  Il Tuo      │───▶│  AIsuru      │
│   Browser    │    │  (Auth MS)   │    │  Backend     │    │  API         │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │ 1. Click          │                   │                   │
       │ "Login con MS"    │                   │                   │
       │──────────────────▶│                   │                   │
       │                   │ 2. Login MS       │                   │
       │                   │    Popup          │                   │
       │◀──────────────────│                   │                   │
       │ 3. Email/Nome     │                   │                   │
       │    da MS          │                   │                   │
       │───────────────────┼──────────────────▶│                   │
       │                   │                   │ 4. Crea JWT       │
       │                   │                   │    + LoginWithJWT │
       │                   │                   │──────────────────▶│
       │                   │                   │◀──────────────────│
       │                   │                   │ 5. Token AIsuru   │
       │◀──────────────────┼───────────────────│                   │
       │ 6. Redirect con   │                   │                   │
       │    loginToken     │                   │                   │
       ▼                   │                   │                   │
┌──────────────┐           │                   │                   │
│ Web Component│           │                   │                   │
│ (pre-auth)   │           │                   │                   │
└──────────────┘           │                   │                   │
```

---

## URL Magic Link (Demo 4)

Dopo aver ottenuto il `token` da `LoginWithJWT`, puoi reindirizzare gli utenti ad AIsuru usando il formato URL magic link. Nella demo app, questo è costruito da `demo4_controller.rb`:

```
https://{TENANT_BASE_URL}/{LINGUA}/magiclink/{TOKEN}
```

**Esempi:**
```
https://www.aisuru.com/en/magiclink/183c7061-a5f5-4bea-ab2b-e4e6a7bbc3a4
https://www.aisuru.com/it/magiclink/183c7061-a5f5-4bea-ab2b-e4e6a7bbc3a4
https://your-tenant.aisuru.com/it/magiclink/IL_TUO_TOKEN
```

**Parametri:**
- `{TENANT_BASE_URL}` — L'URL del tuo tenant AIsuru (es. `www.aisuru.com`)
- `{LINGUA}` — Codice lingua interfaccia (`en`, `it`, ecc.)
- `{TOKEN}` — Il valore `token` dalla risposta di `LoginWithJWT`

---

## Esempio Completo

Ecco un esempio HTML completo con autenticazione e contesto:

```html
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Il Mio Assistente AI</title>

  <!-- AIsuru Web Component -->
  <script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
</head>
<body>

  <h1>Benvenuto nella Mia Applicazione</h1>

  <!-- Agente AI Autenticato -->
  <memori-client
    memoriName="MioAssistente"
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
    showLogin="false"
    additionalInfo='{"loginToken":"TOKEN_AUTH_UTENTE"}'
    context="AMBIENTE:PRODUZIONE,RUOLO_UTENTE:PREMIUM"
    initialQuestion="Benvenuto! Come posso aiutarti oggi?"
  ></memori-client>

</body>
</html>
```

---

## Opzioni di Layout

L'attributo `layout` supporta diverse modalità di visualizzazione:

| Valore | Descrizione |
|--------|-------------|
| `CHAT` | Interfaccia chat standard |
| `FULLPAGE` | Esperienza immersiva a pagina intera |
| `TOTEM` | Modalità totem/kiosk |
| `WEBSITE_ASSISTANT` | Widget assistente flottante |

---

## Riferimento Rapido

### Attributi Obbligatori

| Attributo | Descrizione |
|-----------|-------------|
| `memoriName` | Nome del tuo agente |
| `ownerUserName` | Il tuo username AIsuru |
| `memoriID` | ID Agente da Dev Docs |
| `ownerUserID` | ID Proprietario da Dev Docs |
| `tenantID` | Il tuo tenant (es. `www.aisuru.com`) |
| `engineURL` | URL API Engine |
| `apiURL` | URL API Backend |
| `baseURL` | URL base del tenant |

### Attributi Opzionali

| Attributo | Descrizione | Default |
|-----------|-------------|---------|
| `layout` | Modalità display | `CHAT` |
| `uiLang` | Lingua interfaccia | `EN` |
| `spokenLang` | Lingua conversazione | `EN` |
| `showLogin` | Mostra pulsante login | `true` |
| `additionalInfo` | JSON con loginToken e altri dati | - |
| `context` | Variabili di contesto | - |
| `initialQuestion` | Messaggio/istruzione iniziale | - |

---

## Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Riferimento API PwlUser](https://docs.aisuru.com/api/backend/pwluser)
- [API Trusted Application](https://docs.aisuru.com/api/backend/trustedapplication)
- [Pacchetto NPM Web Component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)
- [Microsoft Identity Platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/)
- [Documentazione MSAL.js](https://github.com/AzureAD/microsoft-authentication-library-for-js)

---

📚 [Torna al Modulo SYS-03](../README.md) | 🏠 [Home del Corso](../../README.md)
