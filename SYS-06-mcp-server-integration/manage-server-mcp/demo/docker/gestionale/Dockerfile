# Fake ERP ("gestionale") used by Demo 6.
# A plain HTTP/REST API with OAuth2 client credentials, so the AIsuru
# OAuth/API connector has something realistic to talk to.

FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY db.py seed.py main.py ./

# The SQLite file lives on a volume mounted at /data (see docker-compose.yml).
ENV GESTIONALE_DB=/data/gestionale.db

EXPOSE 8100

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8100"]
