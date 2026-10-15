"""Seed data for the fake ERP.

Dates are computed relative to today so that "this month" and "overdue"
stay true whenever the course is taught.
"""

from datetime import date, timedelta

CLIENTI = [
    (1, "Rossi Spa", "Manifatturiero", "Laura Rossi"),
    (2, "Bianchi Logistica", "Logistica", "Marco Bianchi"),
    (3, "Verdi Energia", "Energia", "Anna Verdi"),
    (4, "Neri Retail", "Retail", "Giulio Neri"),
    (5, "Ferrari Meccanica", "Manifatturiero", "Sara Ferrari"),
    (6, "Comune di Lugano", "Pubblica amministrazione", "Ufficio Appalti"),
]

# (titolo, cliente_id, stato, percentuale, valore_eur, giorni_inizio,
#  giorni_scadenza, ore) — i giorni sono offset rispetto a oggi.
_ROWS = [
    ("Rifacimento linea di assemblaggio", 1, "attiva", 45, 120000, -20, 40, 310),
    ("Manutenzione predittiva impianti", 1, "attiva", 70, 68000, -50, 25, 240),
    ("Audit sicurezza macchinari", 1, "in_ritardo", 60, 24000, -120, -15, 150),
    ("Nuovo WMS magazzino nord", 2, "attiva", 30, 210000, -10, 90, 180),
    ("Integrazione corrieri", 2, "in_ritardo", 80, 45000, -150, -30, 320),
    ("Portale tracking clienti", 2, "sospesa", 20, 38000, -80, 60, 90),
    ("Monitoraggio consumi fotovoltaico", 3, "attiva", 55, 96000, -35, 20, 260),
    ("Certificazione ISO 50001", 3, "completata", 100, 32000, -200, -60, 210),
    ("Dashboard energetica multi-sito", 3, "attiva", 15, 74000, -5, 110, 60),
    ("Rollout casse self-service", 4, "attiva", 65, 155000, -60, 15, 400),
    ("Programma fedelta digitale", 4, "in_ritardo", 40, 62000, -140, -8, 230),
    ("Analisi assortimento", 4, "completata", 100, 18000, -180, -45, 95),
    ("Revamping centro di lavoro", 5, "attiva", 25, 88000, -15, 70, 120),
    ("Collaudo cella robotizzata", 5, "attiva", 90, 134000, -75, 10, 480),
    ("Formazione operatori CNC", 5, "sospesa", 10, 12000, -30, 45, 24),
    ("Digitalizzazione pratiche edilizie", 6, "attiva", 50, 240000, -45, 30, 350),
    ("Sportello unico online", 6, "attiva", 35, 175000, -25, 85, 190),
    ("Migrazione archivio storico", 6, "completata", 100, 54000, -220, -90, 300),
    ("Manutenzione software gestionale", 1, "attiva", 60, 42000, -40, 22, 170),
    ("Estensione rete sensori", 3, "attiva", 20, 58000, -8, 95, 45),
    ("Ottimizzazione rotte consegna", 2, "attiva", 75, 71000, -55, 12, 265),
    ("Restyling punti vendita pilota", 4, "sospesa", 5, 130000, -12, 150, 30),
    ("Banco prova motori", 5, "completata", 100, 99000, -190, -70, 410),
    ("Portale trasparenza", 6, "attiva", 45, 67000, -28, 18, 140),
    ("Consulenza efficientamento", 3, "attiva", 80, 29000, -65, 8, 155),
]


def build_commesse():
    """Return the rows ready for INSERT, with codes and absolute dates."""
    oggi = date.today()
    righe = []
    for i, (titolo, cliente_id, stato, perc, valore, d_inizio, d_scad, ore) in enumerate(
        _ROWS, start=1
    ):
        codice = f"CM-{oggi.year}-{i:03d}"
        righe.append(
            (
                codice,
                titolo,
                cliente_id,
                stato,
                perc,
                valore,
                (oggi + timedelta(days=d_inizio)).isoformat(),
                (oggi + timedelta(days=d_scad)).isoformat(),
                ore,
            )
        )
    return righe
