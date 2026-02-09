FROM node:20.11.1-alpine AS base

WORKDIR /app

# Install dependencies (production only)
COPY package.json ./
RUN npm install --production

# Copy server source
COPY server.js ./

EXPOSE 8001

CMD ["node", "server.js"]