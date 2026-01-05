# SYS-03: Integrare l'Autenticazione Enterprise

> Impara come integrare sistemi di autenticazione enterprise con gli agenti conversazionali AIsuru

## 🎯 Panoramica del Modulo

Questo modulo copre i pattern di integrazione dell'autenticazione enterprise per AIsuru, abilitando l'accesso sicuro agli agenti AI in ambienti aziendali.

**Durata:** 2 ore

## 📚 Argomenti

| # | Argomento | Descrizione |
|---|-----------|-------------|
| 1 | [Gestione Login](./manage_login/) | Demo completa di gestione autenticazione che copre tutti gli scenari |

### Funzionalità della Demo Application

La demo **Manage Login** include:

| Demo | Metodo di Autenticazione | Descrizione |
|------|--------------------------|-------------|
| **Demo 1** | Login Autonomo | Il web component gestisce il login via `showLogin="true"` |
| **Demo 2** | Auth Programmatica (LoginWithJWT) | Il backend autentica gli utenti via Trusted App API |
| **Demo 3** | Autenticazione Microsoft | Integrazione SSO Azure AD / Entra ID |

## 🎓 Obiettivi di Apprendimento

Al termine di questo modulo, sarai in grado di:

- ✅ Implementare l'autenticazione in web component AIsuru embedded
- ✅ Usare l'API LoginWithJWT per l'autenticazione programmatica
- ✅ Configurare Trusted Applications per comunicazione sicura backend-to-backend
- ✅ Configurare SSO Microsoft Azure AD / Entra ID
- ✅ Costruire flussi di autenticazione basati su redirect

## 🛠️ Prerequisiti

- Comprensione base dei concetti di autenticazione (OAuth 2.0, JWT, SSO)
- Familiarità con i web component AIsuru
- Accesso alla piattaforma AIsuru e credenziali API

## 📂 Struttura del Modulo

```
SYS-03-integrating-enterprise-authentication/
├── README.md        # Questo file (EN)
├── README-IT.md     # Questo file (IT)
└── manage_login/    # Demo app completa di autenticazione
    ├── README.md    # Documentazione inglese
    ├── README-IT.md # Documentazione italiana
    └── demo/        # Applicazione Rails con tutte le demo auth
```

## 🔗 Risorse

- [Documentazione AIsuru](https://docs.aisuru.com/)
- [Riferimento API AIsuru](https://docs.aisuru.com/api)
- [Backend API - PwlUser](https://docs.aisuru.com/api/backend/pwluser)

---

🏠 [Home del Corso](../README.md) | ➡️ [Prossimo Modulo: SYS-04 Funzioni Avanzate](../SYS-04-advanced-functions/)

