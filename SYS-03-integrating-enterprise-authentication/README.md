# SYS-03: Integrating Enterprise Authentication

> Learn how to integrate enterprise authentication systems with AIsuru conversational AI agents

## 🎯 Module Overview

This module covers enterprise authentication integration patterns for AIsuru, enabling secure access to AI agents within corporate environments.

**Duration:** 2 hours

## 📚 Topics

| # | Topic | Description |
|---|-------|-------------|
| 1 | [Manage Login](./manage_login/) | Complete authentication management demo covering all scenarios |

### Demo Application Features

The **Manage Login** demo application includes:

| Demo | Authentication Method | Description |
|------|----------------------|-------------|
| **Demo 1** | Self-Managed Login | Web component handles login via `showLogin="true"` |
| **Demo 2** | Programmatic Auth (LoginWithJWT) | Backend authenticates users via Trusted App API |
| **Demo 3** | Microsoft Authentication | Azure AD / Entra ID SSO integration |
| **Demo 4** | Login with Redirect | Authenticate users, then redirect to AIsuru platform |

## 🎓 Learning Objectives

By the end of this module, you will be able to:

- ✅ Implement authentication in embedded AIsuru web components
- ✅ Use the LoginWithJWT API for programmatic authentication
- ✅ Configure Trusted Applications for secure backend-to-backend communication
- ✅ Configure Microsoft Azure AD / Entra ID SSO
- ✅ Build redirect-based authentication flows

## 🛠️ Prerequisites

- Basic understanding of authentication concepts (OAuth 2.0, JWT, SSO)
- Familiarity with AIsuru web components
- Access to AIsuru platform and API credentials

## 📂 Module Structure

```
SYS-03-integrating-enterprise-authentication/
├── README.md        # This file
└── manage_login/    # Complete authentication demo app
    ├── README.md    # English documentation
    ├── README-IT.md # Italian documentation
    └── demo/        # Rails application with all auth demos
```

## 🔗 Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [AIsuru API Reference](https://docs.aisuru.com/api)
- [Backend API - PwlUser](https://docs.aisuru.com/api/backend/pwluser)

---

🏠 [Course Home](../README.md) | ➡️ [Next Module: SYS-04 Advanced Functions](../SYS-04-advanced-functions/)
