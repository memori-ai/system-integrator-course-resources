"""SQLite access for the fake ERP.

One tiny module: schema creation, connection helper, and the idempotent
seed hook. Everything else lives in main.py.
"""

import os
import sqlite3

DB_PATH = os.environ.get("GESTIONALE_DB", "/data/gestionale.db")

SCHEMA = """
CREATE TABLE IF NOT EXISTS clienti (
    id        INTEGER PRIMARY KEY,
    nome      TEXT NOT NULL,
    settore   TEXT NOT NULL,
    referente TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS commesse (
    id               INTEGER PRIMARY KEY,
    codice           TEXT NOT NULL UNIQUE,
    titolo           TEXT NOT NULL,
    cliente_id       INTEGER NOT NULL REFERENCES clienti(id),
    stato            TEXT NOT NULL,
    percentuale      INTEGER NOT NULL,
    valore_eur       INTEGER NOT NULL,
    data_inizio      TEXT NOT NULL,
    data_scadenza    TEXT NOT NULL,
    ore_consuntivate INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS avanzamenti (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    commessa_id INTEGER NOT NULL REFERENCES commesse(id),
    percentuale INTEGER NOT NULL,
    nota        TEXT NOT NULL,
    creato_il   TEXT NOT NULL
);
"""


def connect():
    """Open a connection whose rows behave like dicts."""
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


def init(force: bool = False):
    """Create the schema and seed it.

    Idempotent: an existing database with data is left untouched unless
    force=True (used by POST /admin/reset to restore the demo).
    """
    from seed import CLIENTI, build_commesse

    conn = connect()
    try:
        with conn:
            conn.executescript(SCHEMA)
            if force:
                conn.execute("DELETE FROM avanzamenti")
                conn.execute("DELETE FROM commesse")
                conn.execute("DELETE FROM clienti")
            already = conn.execute("SELECT COUNT(*) AS n FROM commesse").fetchone()["n"]
            if already:
                return
            conn.executemany(
                "INSERT INTO clienti (id, nome, settore, referente) VALUES (?, ?, ?, ?)",
                CLIENTI,
            )
            conn.executemany(
                "INSERT INTO commesse (codice, titolo, cliente_id, stato, percentuale, "
                "valore_eur, data_inizio, data_scadenza, ore_consuntivate) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                build_commesse(),
            )
    finally:
        conn.close()
