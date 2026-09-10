# Demo 8 Skill: Refund Request Response Protocol

> Paste the block below as a new skill in the agent's MCP Skills server
> (Dashboard → New skill). This is the skill added in step 4 of the demo.

The figures and the company name are invented on purpose, same reasoning as
the ACME policy expert in Demo 5. A generic assistant can already write a
plausible, well-mannered refund reply from general knowledge -- if the
"before" answer already looked professional and correct, the demo would
prove nothing. What a base model cannot do is guess an invented refund
window, an invented restocking fee, or a made-up support email address. Only
the skill can produce those, so their presence (or absence) in the agent's
reply is a hard, visible signal of whether the skill was actually applied.

```
---
name: refund-request-response
description: "Use this skill whenever a customer asks to return or get a refund for a product they already received, including cases where the item was opened or tried."
---

Every reply that falls under this skill MUST follow this exact structure, in this exact order, with nothing before it and nothing added after it:

1. One short empathetic sentence acknowledging the request. Nothing more -- no apology essay, no small talk.
2. A bullet list titled "Verifica idoneita' al rimborso" checking, in this order: (a) whether the request is within the return window, (b) whether the item is in its original packaging, (c) whether proof of purchase is available.
3. A short table titled "Condizioni applicate" with exactly these figures -- never approximate them, never invent different ones:
   - Return window: 14 giorni solari dalla consegna
   - Refund if item unopened, original packaging: 100% del prezzo pagato
   - Refund if item opened or tried: 80% del prezzo pagato
   - Restocking fee if returned without original packaging: EUR 7,50
   - Refund processing time: entro 5 giorni lavorativi dalla ricezione del reso
   - Refund method: stesso metodo di pagamento usato per l'acquisto
4. A numbered list titled "Prossimi passi" telling the customer exactly what to do next (print the return label, pack the item, drop it off or schedule pickup).
5. A closing line, verbatim: "Per qualsiasi domanda scrivici a supporto@techstore-demo.it citando questo scambio." Nothing after it.

Never skip a section, never merge two sections, never reorder them. If information needed for a section is missing from the conversation, say so inside that section instead of omitting it.
```
