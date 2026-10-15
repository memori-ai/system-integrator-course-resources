# Demo 7: the project request email

> Send the block below as an email to the Outlook mailbox you connected in
> the run-through. The page offers it as a download so attendees can send it
> from their own client.

This email asks for a whole small CRM, not a single page, and that is the
point: the room watches one email turn into a persistent application with
several views, seeded records and write endpoints, built without anyone
writing a line of code or a prompt.

Keep the requirements list concrete. "Kanban delle opportunita' divise per
fase", "calendario attivita'" and "dashboard con KPI" are checkable by looking
at the screen from the back of the room; "make it nice" is not. Every bullet
in the list is something the presenter can point at once the build finishes.

Two properties are worth preserving if you edit this email.

**The three entities and their fields stay spelled out.** They are what the
generated persistence collections are built from, and naming them in the email
is what lets the presenter say "these fields come from the email" while the
forms are on screen.

**The chat examples stay in.** They are what turns the demo from "it generated
a page" into "it generated an application the agent can drive": asking
"mostrami la pipeline" or "aggiungi un'opportunita' da 15.000 EUR per questo
cliente" after the build exercises the endpoints the agent registered for
itself a minute earlier.

One deliberate trade-off against the older Sales Dashboard email: that one
carried unguessable figures (420 / 275 / 180 / 95), so their appearance on
screen proved the mailbox had been read. This one asks the agent for invented
demo records instead, which loosens that proof and sits in tension with the
agent's "never invent figures" rule (see `vibe-project-builder.md`). If you
want the proof back, add a short block of seed records with irregular values
to the email, a handful of named clients with odd deal sizes, and drop the
"dati demo fittizi" line: the data then comes from the email again.

Because the build is generated, it is **not deterministic**. Run the same
email twice and the view names, their number, the layout and the endpoints can
differ. Demo the capability, not a specific screen.

```
Oggetto: Richiesta progetto: CRM FlowSales per demo clienti

Ciao,

ti giro la richiesta per il progetto di questa settimana.

Crea una demo CRM completa e realmente funzionante chiamata FlowSales,
pensata per mostrare le potenzialita' del Vibe Coder a dei clienti.

Voglio dati persistenti reali, non valori hardcoded.

Gestisci 3 entita':
- Clienti: nome, settore, email, telefono, stato, note
- Opportunita': cliente, titolo, valore, fase commerciale, probabilita',
  data chiusura
- Attivita': cliente, opportunita', tipo, data, priorita', stato

Crea:
- dashboard con KPI e grafici della pipeline
- tabella clienti
- scheda dettaglio cliente con opportunita' e attivita' collegate
- Kanban delle opportunita' divise per fase
- calendario attivita'
- form per aggiungere clienti, opportunita' e attivita'

Inserisci anche alcuni dati demo fittizi, ma come veri record modificabili.

Voglio poter interagire anche dalla chat, ad esempio:
"Mostrami la pipeline"
"Aggiungi un'opportunita' da 15.000 EUR per questo cliente"
"Quali attivita' ho questa settimana?"

Quando possibile mostra direttamente le viste nella conversazione e fai
aggiornare l'interfaccia dopo le modifiche.

Usa un design moderno B2B SaaS.

Costruisci tutto autonomamente, verifica che salvataggi e viste funzionino
davvero e alla fine mostrami la dashboard e spiegami cosa posso provare
durante la demo.

Grazie!
Marta Bianchi - Direzione Commerciale
```
