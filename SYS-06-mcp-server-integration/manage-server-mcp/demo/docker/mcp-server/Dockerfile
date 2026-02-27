# MCP Filesystem Server
# Lightweight Node.js image — only runs the MCP server process.

FROM node:20.11.1-alpine AS base

WORKDIR /app

# Install dependencies (production only)
COPY package.json ./
RUN npm install --production

# Copy server source
COPY server.js ./

# The workspace volume will be mounted at /workspace at runtime.
# WORKSPACE_ROOT env var is set in docker-compose.
ENV WORKSPACE_ROOT=/workspace

# SSE transport listens on this port (overridable via PORT env var).
EXPOSE 8000

CMD ["node", "server.js"]
