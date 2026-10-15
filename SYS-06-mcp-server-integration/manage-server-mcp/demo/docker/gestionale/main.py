"""Fake ERP API for SYS-06 Demo 6.

Exposes an OAuth2 (client credentials) protected REST API. The AIsuru
OAuth/API connector imports the endpoints from /openapi.json and turns each
one into a tool, so the summaries and descriptions below are effectively
part of the agent's prompt: they tell it WHEN to use each endpoint.
"""

import os
from datetime import datetime, timedelta, timezone
from typing import Literal, Optional

import jwt
from fastapi import Depends, FastAPI, Form, Header, HTTPException, Path, Query, Security
from fastapi.openapi.utils import get_openapi
from fastapi.openapi.models import OAuthFlowClientCredentials, OAuthFlows
from fastapi.security import OAuth2
from pydantic import BaseModel, Field

import db

CLIENT_ID = os.environ.get("GESTIONALE_CLIENT_ID", "aisuru-demo")
CLIENT_SECRET = os.environ.get("GESTIONALE_CLIENT_SECRET", "demo-secret-sys06")
JWT_SECRET = os.environ.get("GESTIONALE_JWT_SECRET", "sys06-demo-jwt-secret")
ADMIN_TOKEN = os.environ.get("GESTIONALE_ADMIN_TOKEN", "sys06-demo-admin")

# Deliberately short: during a lesson the connector has to renew the token
# on its own, which is exactly the behaviour the demo is about.
TOKEN_TTL_SECONDS = 900

SCOPE_READ = "commesse:read"
SCOPE_WRITE = "commesse:write"

app = FastAPI(
    title="Gestionale Commesse API",
    version="1.0.0",
    description=(
        "Fake ERP exposing projects (commesse), customers and KPIs. "
        "Protected with OAuth2 client credentials."
    ),
)


# --- models -----------------------------------------------------------

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int


class Cliente(BaseModel):
    id: int
    nome: str
    settore: str
    referente: str
    commesse_attive: int


class Commessa(BaseModel):
    id: int
    codice: str
    titolo: str
    cliente: str
    stato: str
    percentuale: int
    valore_eur: int
    data_inizio: str
    data_scadenza: str
    ore_consuntivate: int


class PaginaCommesse(BaseModel):
    totale: int
    limit: int
    offset: int
    risultati: list[Commessa]


class Riepilogo(BaseModel):
    mese: str
    commesse_attive: int
    commesse_in_ritardo: int
    valore_totale_eur: int
    ore_consuntivate: int
    percentuale_media: int


class AvanzamentoIn(BaseModel):
    percentuale: int = Field(ge=0, le=100, description="New completion percentage.")
    nota: str = Field(min_length=1, max_length=500, description="Short progress note.")


# --- auth -------------------------------------------------------------

oauth2_scheme = OAuth2(
    flows=OAuthFlows(
        clientCredentials=OAuthFlowClientCredentials(
            tokenUrl="/token",
            scopes={
                SCOPE_READ: "Read projects, customers and KPIs.",
                SCOPE_WRITE: "Update a project's completion percentage.",
            },
        )
    ),
    auto_error=False,
)


def _issue_token(scope: str) -> Token:
    now = datetime.now(timezone.utc)
    payload = {
        "sub": CLIENT_ID,
        "scope": scope,
        "iat": int(now.timestamp()),
        "exp": int((now + timedelta(seconds=TOKEN_TTL_SECONDS)).timestamp()),
    }
    return Token(
        access_token=jwt.encode(payload, JWT_SECRET, algorithm="HS256"),
        expires_in=TOKEN_TTL_SECONDS,
    )


def _claims(authorization: Optional[str]) -> dict:
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=401, detail="Missing bearer token.")
    raw = authorization.split(" ", 1)[1].strip()
    try:
        return jwt.decode(raw, JWT_SECRET, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired, request a new one.")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token.")


def require_read(authorization: Optional[str] = Security(oauth2_scheme)) -> dict:
    claims = _claims(authorization)
    if SCOPE_READ not in claims.get("scope", "").split():
        raise HTTPException(status_code=403, detail=f"Scope {SCOPE_READ} required.")
    return claims


def require_write(authorization: Optional[str] = Security(oauth2_scheme)) -> dict:
    claims = _claims(authorization)
    if SCOPE_WRITE not in claims.get("scope", "").split():
        raise HTTPException(status_code=403, detail=f"Scope {SCOPE_WRITE} required.")
    return claims


@app.on_event("startup")
def _startup():
    db.init()


@app.post("/token", response_model=Token, tags=["auth"], summary="Request an access token")
def token(
    grant_type: str = Form(...),
    client_id: str = Form(...),
    client_secret: str = Form(...),
    scope: str = Form(default=f"{SCOPE_READ} {SCOPE_WRITE}"),
):
    """OAuth2 client credentials endpoint. The connector calls this on its own."""
    if grant_type != "client_credentials":
        raise HTTPException(status_code=400, detail="unsupported_grant_type")
    if client_id != CLIENT_ID or client_secret != CLIENT_SECRET:
        raise HTTPException(status_code=401, detail="invalid_client")
    granted = [s for s in scope.split() if s in (SCOPE_READ, SCOPE_WRITE)]
    if not granted:
        raise HTTPException(status_code=400, detail="invalid_scope")
    return _issue_token(" ".join(granted))


@app.get("/health", tags=["service"], include_in_schema=False)
def health():
    return {"status": "ok"}


# --- helpers ----------------------------------------------------------

def _row_to_commessa(row) -> Commessa:
    return Commessa(
        id=row["id"],
        codice=row["codice"],
        titolo=row["titolo"],
        cliente=row["cliente"],
        stato=row["stato"],
        percentuale=row["percentuale"],
        valore_eur=row["valore_eur"],
        data_inizio=row["data_inizio"],
        data_scadenza=row["data_scadenza"],
        ore_consuntivate=row["ore_consuntivate"],
    )


_SELECT = (
    "SELECT c.*, cl.nome AS cliente FROM commesse c "
    "JOIN clienti cl ON cl.id = c.cliente_id"
)


def _find_commessa(conn, id_o_codice: str):
    return conn.execute(
        f"{_SELECT} WHERE c.codice = ? OR c.id = ?",
        (id_o_codice, id_o_codice if id_o_codice.isdigit() else -1),
    ).fetchone()


# --- business endpoints -----------------------------------------------

@app.get(
    "/commesse",
    response_model=PaginaCommesse,
    tags=["commesse"],
    summary="List projects, with filters and pagination",
)
def lista_commesse(
    stato: Optional[Literal["attiva", "in_ritardo", "completata", "sospesa"]] = Query(
        default=None, description="Filter by project status."
    ),
    cliente: Optional[str] = Query(
        default=None, description="Filter by customer name, partial match allowed."
    ),
    mese: Optional[str] = Query(
        default=None,
        pattern=r"^\d{4}-\d{2}$",
        description="Filter to projects running in this month, format YYYY-MM.",
    ),
    limit: int = Query(default=20, ge=1, le=50, description="Page size, max 50."),
    offset: int = Query(default=0, ge=0, description="Rows to skip."),
    _: dict = Depends(require_read),
):
    """Return a page of projects, already sorted by urgency.

    Results come back with the most urgent projects first: in_ritardo, then
    attiva, then sospesa, then completata, and within each group ordered by
    the soonest data_scadenza. Always paginated: ask for a page and use the
    offset to continue instead of trying to download everything. If you only
    need counts or totals, call /kpi/riepilogo instead of listing rows.
    """
    where, args = [], []
    if stato:
        where.append("c.stato = ?")
        args.append(stato)
    if cliente:
        where.append("cl.nome LIKE ?")
        args.append(f"%{cliente}%")
    if mese:
        where.append("(substr(c.data_inizio, 1, 7) <= ? AND substr(c.data_scadenza, 1, 7) >= ?)")
        args.extend([mese, mese])
    clause = (" WHERE " + " AND ".join(where)) if where else ""

    conn = db.connect()
    totale = conn.execute(
        f"SELECT COUNT(*) AS n FROM commesse c JOIN clienti cl ON cl.id = c.cliente_id{clause}",
        args,
    ).fetchone()["n"]
    rows = conn.execute(
        f"{_SELECT}{clause} ORDER BY "
        "CASE c.stato "
        "WHEN 'in_ritardo' THEN 0 "
        "WHEN 'attiva' THEN 1 "
        "WHEN 'sospesa' THEN 2 "
        "WHEN 'completata' THEN 3 "
        "ELSE 4 END, "
        "c.data_scadenza LIMIT ? OFFSET ?",
        args + [limit, offset],
    ).fetchall()
    conn.close()
    return PaginaCommesse(
        totale=totale,
        limit=limit,
        offset=offset,
        risultati=[_row_to_commessa(r) for r in rows],
    )


@app.get(
    "/commesse/{id_o_codice}",
    response_model=Commessa,
    tags=["commesse"],
    summary="Get one project by id or code",
)
def dettaglio_commessa(
    id_o_codice: str = Path(description="Numeric id or project code, e.g. CM-2026-003."),
    _: dict = Depends(require_read),
):
    """Use this when the user names a specific project code."""
    conn = db.connect()
    row = _find_commessa(conn, id_o_codice)
    conn.close()
    if row is None:
        raise HTTPException(status_code=404, detail="Commessa not found.")
    return _row_to_commessa(row)


@app.get("/clienti", response_model=list[Cliente], tags=["clienti"], summary="List customers")
def lista_clienti(_: dict = Depends(require_read)):
    """Use this to resolve a customer name before filtering projects by customer."""
    conn = db.connect()
    rows = conn.execute(
        "SELECT cl.*, ("
        "  SELECT COUNT(*) FROM commesse c "
        "  WHERE c.cliente_id = cl.id AND c.stato = 'attiva'"
        ") AS commesse_attive FROM clienti cl ORDER BY cl.nome"
    ).fetchall()
    conn.close()
    return [Cliente(**dict(r)) for r in rows]


@app.get(
    "/kpi/riepilogo",
    response_model=Riepilogo,
    tags=["kpi"],
    summary="Aggregated KPIs for a month",
)
def riepilogo(
    mese: Optional[str] = Query(
        default=None,
        pattern=r"^\d{4}-\d{2}$",
        description="Month to summarise, format YYYY-MM. Defaults to the current month.",
    ),
    _: dict = Depends(require_read),
):
    """Answers questions like "how many active projects do we have this month".

    Prefer this over listing all projects and counting them yourself: it is a
    single small response.
    """
    mese = mese or datetime.now(timezone.utc).strftime("%Y-%m")
    conn = db.connect()
    rows = conn.execute(
        f"{_SELECT} WHERE substr(c.data_inizio, 1, 7) <= ? "
        "AND substr(c.data_scadenza, 1, 7) >= ?",
        (mese, mese),
    ).fetchall()
    conn.close()
    attive = [r for r in rows if r["stato"] == "attiva"]
    ritardo = [r for r in rows if r["stato"] == "in_ritardo"]
    perc = [r["percentuale"] for r in rows] or [0]
    return Riepilogo(
        mese=mese,
        commesse_attive=len(attive),
        commesse_in_ritardo=len(ritardo),
        valore_totale_eur=sum(r["valore_eur"] for r in rows),
        ore_consuntivate=sum(r["ore_consuntivate"] for r in rows),
        percentuale_media=round(sum(perc) / len(perc)),
    )


@app.post(
    "/commesse/{id_o_codice}/avanzamento",
    response_model=Commessa,
    tags=["commesse"],
    summary="Update a project's completion percentage",
    operation_id="avanzamento_commessa",
    # Out of the public schema on purpose. The AIsuru connector imports GET
    # operations only: it skipped this POST with the $ref body, with the body
    # inlined, and with a short operation_id alike. Keeping it in the schema
    # only promised the agent a tool it never received, so the demo is
    # read-only. The endpoint still works when called directly.
    include_in_schema=False,
)
def registra_avanzamento(
    payload: AvanzamentoIn,
    id_o_codice: str = Path(description="Numeric id or project code, e.g. CM-2026-003."),
    _: dict = Depends(require_write),
):
    """Record progress on a project. Reaching 100% marks it as completed."""
    conn = db.connect()
    row = _find_commessa(conn, id_o_codice)
    if row is None:
        conn.close()
        raise HTTPException(status_code=404, detail="Commessa not found.")
    stato = "completata" if payload.percentuale == 100 else row["stato"]
    with conn:
        conn.execute(
            "UPDATE commesse SET percentuale = ?, stato = ? WHERE id = ?",
            (payload.percentuale, stato, row["id"]),
        )
        conn.execute(
            "INSERT INTO avanzamenti (commessa_id, percentuale, nota, creato_il) "
            "VALUES (?, ?, ?, ?)",
            (row["id"], payload.percentuale, payload.nota,
             datetime.now(timezone.utc).isoformat(timespec="seconds")),
        )
    updated = _find_commessa(conn, id_o_codice)
    conn.close()
    return _row_to_commessa(updated)


@app.post("/admin/reset", tags=["service"], include_in_schema=False)
def reset(x_admin_token: str = Header(default=None)):
    """Restore the original seed. Not part of the public schema, so the
    connector never turns it into a tool the agent could call."""
    if x_admin_token != ADMIN_TOKEN:
        raise HTTPException(status_code=401, detail="Invalid admin token.")
    db.init(force=True)
    return {"reset": True}


# --- openapi tweak ----------------------------------------------------

def _inline_refs(node, schemas, depth=0):
    """Replace $ref pointers with the schema they point at."""
    if depth > 10:
        return node
    if isinstance(node, dict):
        ref = node.get("$ref")
        if isinstance(ref, str) and ref.startswith("#/components/schemas/"):
            target = schemas.get(ref.rsplit("/", 1)[-1], {})
            return _inline_refs(target, schemas, depth + 1)
        return {k: _inline_refs(v, schemas, depth + 1) for k, v in node.items()}
    if isinstance(node, list):
        return [_inline_refs(v, schemas, depth + 1) for v in node]
    return node


def custom_openapi():
    """Serve request bodies with the schema written out in full.

    The AIsuru connector imported every GET but skipped the one endpoint
    with a body, whose schema was a $ref into components. Inlining it
    removes that dependency; the rest of the document is untouched.
    """
    if app.openapi_schema:
        return app.openapi_schema
    schema = get_openapi(
        title=app.title,
        version=app.version,
        description=app.description,
        routes=app.routes,
    )
    components = schema.get("components", {}).get("schemas", {})
    for operations in schema.get("paths", {}).values():
        for operation in operations.values():
            body = operation.get("requestBody")
            if body:
                operation["requestBody"] = _inline_refs(body, components)
    app.openapi_schema = schema
    return schema


app.openapi = custom_openapi
