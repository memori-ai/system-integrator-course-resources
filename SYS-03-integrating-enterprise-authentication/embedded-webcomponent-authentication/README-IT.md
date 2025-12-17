# Autenticazione Web Component Embedded

> Guida completa alla configurazione del web component AIsuru con autenticazione per scenari embedded

## 🎯 Panoramica

Questa guida spiega come integrare il web component AIsuru nelle tue applicazioni e configurare l'autenticazione per fornire esperienze AI personalizzate. Imparerai a:

- Configurare il web component con le credenziali del tuo agente
- Passare token di autenticazione per utenti loggati
- Usare variabili di contesto e domande iniziali
- Implementare flussi di autenticazione sicuri

## 📋 Prerequisiti

Prima di iniziare, hai bisogno di:

1. Un **account AIsuru** su [aisuru.com](https://www.aisuru.com)
2. Un **Agente AI (Memori)** configurato nel tuo account
3. Accesso alla sezione **Dev Docs** del tuo agente
4. Conoscenza base di HTML e JavaScript

---

## 🔧 Configurazione Base del Web Component

### Step 1: Includere il Web Component

Aggiungi queste due righe nel tuo HTML `<head>` o prima del tag di chiusura `</body>`:

```html
<!-- AIsuru Web Component -->
<script type="module" src="https://cdn.jsdelivr.net/npm/@memori.ai/memori-webcomponent/dist/memori-webcomponent.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@memori.ai/memori-react/dist/styles.min.css" />
```

### Step 2: Ottenere le Credenziali del Tuo Agente

Naviga al tuo agente in AIsuru, poi vai su **Dev Docs** → tab **Accesso alle API**.

Troverai:

| Campo | Descrizione | Esempio |
|-------|-------------|---------|
| **Memori (Agente) ID** | Identificatore univoco del tuo agente | `a1b2c3d4-e5f6-7890-abcd-ef1234567890` |
| **Engine URL** | Endpoint API per le conversazioni | `https://engine.memori.ai/memori/v2` |
| **Backend URL** | Endpoint API per operazioni backend | `https://backend.memori.ai/api/v2` |

Sotto **Altri riferimenti**:

| Campo | Descrizione | Esempio |
|-------|-------------|---------|
| **Memori (Agente) ID secondario** | ID agente alternativo | `b2c3d4e5-f6a7-8901-bcde-f12345678901` |
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

## 🔐 Configurazione dell'Autenticazione

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

## 🎛️ Variabili di Contesto e Domande Iniziali

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

## 🔑 Ottenere Token di Login via API

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

### Opzione 2: Login con JWT

Per integrazioni SSO aziendali, usa l'autenticazione basata su JWT:

```bash
POST https://backend.memori.ai/api/v2/LoginWithJWT
Content-Type: application/json

{
  "tenant": "www.aisuru.com",
  "jwt": "IL_TUO_JWT_FIRMATO"
}
```

**Risposta:**

```json
{
  "user": {
    "userID": "c3d4e5f6-a7b8-9012-cdef-123456789012",
    "userName": "utente@esempio.com",
    ...
  },
  "token": "f1e2d3c4-b5a6-9780-1234-567890abcdef",
  "resultCode": 0,
  "resultMessage": "OK"
}
```

Usa il valore `token` restituito nell'attributo `additionalInfo.loginToken`.

📖 **Riferimento API Completo**: [Documentazione API PwlUser](https://docs.aisuru.com/api/backend/pwluser)

---

## 📝 Esempio Completo

Ecco un esempio completo con autenticazione e contesto:

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

## 🎨 Opzioni di Layout

L'attributo `layout` supporta diverse modalità di visualizzazione:

| Valore | Descrizione |
|--------|-------------|
| `CHAT` | Interfaccia chat standard |
| `FULLPAGE` | Esperienza immersiva a pagina intera |
| `TOTEM` | Modalità totem/kiosk |
| `WEBSITE_ASSISTANT` | Widget assistente flottante |

---

## 🔗 Riferimento Rapido

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

## 📚 Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Riferimento API PwlUser](https://docs.aisuru.com/api/backend/pwluser)
- [Pacchetto NPM Web Component](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

📚 [Torna al Modulo SYS-03](../README.md) | 🏠 [Home del Corso](../../README.md)

