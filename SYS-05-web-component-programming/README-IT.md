# SYS-05: Programmazione Web Component

Come integrare e programmare il web component AIsuru nelle tue pagine.

[English version](./README.md)

## Panoramica

Il modulo copre le tecniche che rendono un agente embedded consapevole della pagina in cui vive e che permettono alle sue risposte di agire su quella pagina.

Guida completa: [web_component/README-IT.md](./web_component/README-IT.md) ([English version](./web_component/README.md))

## Avvio rapido

```bash
cd web_component/demo
```

La prima volta crea un file `.env_dev` nella cartella `demo/` con questo contenuto:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

(Il launcher `npm run start:all` nella root del repository scrive il file da solo.)

```bash
# Compila e avvia l'applicazione
npm run start

# Apri il browser
open http://localhost:13005
```

Il servizio `web` è mappato sulla porta 13005 invece che sulla 3000, così questa demo può girare insieme alle altre. Dentro il container ascolta comunque sulla 3000.

**Windows, se `npm run start` non funziona:** Git su Windows può convertire i fine riga in CRLF, cosa che rompe gli script shell dentro il container. Esegui questo comando una volta e riprova:

```bash
git config --global core.autocrlf false
```

---

[Home del corso](../README-IT.md)
