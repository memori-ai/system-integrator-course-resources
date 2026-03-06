#!/usr/bin/env node

/**
 * MCP Server for MySQL Database Operations
 *
 * This server exposes MySQL database operations via the Model Context Protocol (MCP).
 * It uses SSE (Server-Sent Events) transport for communication with MCP clients.
 *
 * Environment variables required:
 * - MYSQL_HOST: MySQL server hostname (default: mysql)
 * - MYSQL_PORT: MySQL server port (default: 3306)
 * - MYSQL_DATABASE: Database name
 * - MYSQL_USER: Database user
 * - MYSQL_PASSWORD: Database password
 * - PORT: Server port (default: 8001)
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';
import { ListToolsRequestSchema, CallToolRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { createServer } from 'http';
import mysql from 'mysql2/promise';

const MYSQL_CONFIG = {
  host: process.env.MYSQL_HOST || 'mysql',
  port: parseInt(process.env.MYSQL_PORT || '3306'),
  database: process.env.MYSQL_DATABASE || 'mcp_demo_mysql',
  user: process.env.MYSQL_USER || 'mcpuser',
  password: process.env.MYSQL_PASSWORD || 'mcppassword',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const PORT = parseInt(process.env.PORT || '8001');

// Create MySQL connection pool
const pool = mysql.createPool(MYSQL_CONFIG);

// In-memory map: sessionId → SSEServerTransport
const transports = {};

// Test database connection
async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('[mcp-mysql-server] ✓ Successfully connected to MySQL database');
    connection.release();
  } catch (error) {
    console.error('[mcp-mysql-server] ✗ Failed to connect to MySQL:', error.message);
    throw error;
  }
}

// Tool definitions
const TOOLS = [
  {
    name: 'query',
    description: 'Execute a SELECT query on the MySQL database',
    inputSchema: {
      type: 'object',
      properties: {
        sql: {
          type: 'string',
          description: 'The SELECT SQL query to execute',
        },
      },
      required: ['sql'],
    },
  },
  {
    name: 'execute',
    description: 'Execute an INSERT, UPDATE, or DELETE query on the MySQL database',
    inputSchema: {
      type: 'object',
      properties: {
        sql: {
          type: 'string',
          description: 'The SQL query to execute (INSERT, UPDATE, DELETE)',
        },
      },
      required: ['sql'],
    },
  },
  {
    name: 'list_tables',
    description: 'List all tables in the database',
    inputSchema: {
      type: 'object',
      properties: {},
    },
  },
  {
    name: 'describe_table',
    description: 'Get the schema/structure of a specific table',
    inputSchema: {
      type: 'object',
      properties: {
        table: {
          type: 'string',
          description: 'The name of the table to describe',
        },
      },
      required: ['table'],
    },
  },
];

// MCP Server factory - creates a new server instance for each connection
function createMCPServer() {
  const server = new Server(
    {
      name: 'mcp-mysql-server',
      version: '1.0.0',
    },
    {
      capabilities: {
        tools: {},
      },
    }
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return { tools: TOOLS };
  });

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, input, arguments: args } = request.params;
    const toolInput = input || args || {};

    try {
      switch (name) {
        case 'query': {
          const { sql } = toolInput;

          // Security: Only allow SELECT queries
          if (!sql.trim().toLowerCase().startsWith('select')) {
            throw new Error('Only SELECT queries are allowed with the query tool. Use execute for INSERT/UPDATE/DELETE.');
          }

          const [rows] = await pool.execute(sql);
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify(rows, null, 2),
              },
            ],
          };
        }

        case 'execute': {
          const { sql } = toolInput;

          // Security: Prevent SELECT queries (use query tool instead)
          if (sql.trim().toLowerCase().startsWith('select')) {
            throw new Error('Use the query tool for SELECT queries.');
          }

          const [result] = await pool.execute(sql);
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify({
                  affectedRows: result.affectedRows,
                  insertId: result.insertId,
                  message: 'Query executed successfully',
                }, null, 2),
              },
            ],
          };
        }

        case 'list_tables': {
          const [rows] = await pool.execute('SHOW TABLES');
          const tables = rows.map(row => Object.values(row)[0]);
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify({ tables }, null, 2),
              },
            ],
          };
        }

        case 'describe_table': {
          const { table } = toolInput;

          // Security: Validate table name (prevent SQL injection)
          if (!/^[a-zA-Z0-9_]+$/.test(table)) {
            throw new Error('Invalid table name. Only alphanumeric characters and underscores are allowed.');
          }

          const [rows] = await pool.execute(`DESCRIBE ${table}`);
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify(rows, null, 2),
              },
            ],
          };
        }

        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `Error: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  });

  return server;
}

// Minimal JSON body parser
function parseBody(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', (chunk) => (data += chunk));
    req.on('end', () => {
      try {
        resolve(data ? JSON.parse(data) : {});
      } catch (e) {
        reject(e);
      }
    });
  });
}

// Create HTTP server with SSE transport
const httpServer = createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  // CORS headers - required for external clients
  const origin = req.headers.origin || '*';
  res.setHeader('Access-Control-Allow-Origin', origin);
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Cache-Control');
  res.setHeader('Access-Control-Allow-Credentials', 'true');

  // Handle preflight OPTIONS requests
  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  // GET /mcp — establish SSE stream
  if (req.method === 'GET' && url.pathname === '/mcp') {
    try {
      // Rewrite endpoint for ngrok support
      const host = req.headers.host;
      console.error(`[mcp-mysql-server] Host header: ${host}`);
      const originalWrite = res.write.bind(res);
      let endpointRewritten = false;
      res.write = function (chunk, ...args) {
        if (
          !endpointRewritten &&
          typeof chunk === 'string' &&
          chunk.includes('event: endpoint')
        ) {
          endpointRewritten = true;
          const originalEndpoint = chunk.match(/data: (\/messages[^\n]*)/)?.[1];
          chunk = chunk.replace(
            /data: (\/messages[^\n]*)/,
            `data: https://${host}$1`,
          );
          const newEndpoint = chunk.match(/data: (https:\/\/[^\n]*)/)?.[1];
          console.error(
            `[mcp-mysql-server] Endpoint rewrite: ${originalEndpoint} → ${newEndpoint}`,
          );
        }
        return originalWrite(chunk, ...args);
      };

      // Create a new server instance for this connection
      const server = createMCPServer();
      const transport = new SSEServerTransport('/messages', res);
      transports[transport.sessionId] = transport;
      transport.onclose = () => delete transports[transport.sessionId];

      await server.connect(transport);
      console.error(
        `[mcp-mysql-server] SSE session established: ${transport.sessionId}`,
      );
    } catch (err) {
      console.error('[mcp-mysql-server] SSE setup error:', err);
      if (!res.headersSent) res.writeHead(500).end('SSE setup failed');
    }
    return;
  }

  // POST /messages — receive JSON-RPC from client
  if (req.method === 'POST' && url.pathname === '/messages') {
    const sessionId = url.searchParams.get('sessionId');
    if (!sessionId || !transports[sessionId]) {
      res.writeHead(sessionId ? 404 : 400).end('Session not found');
      return;
    }
    try {
      const body = await parseBody(req);
      await transports[sessionId].handlePostMessage(req, res, body);
    } catch (err) {
      console.error('[mcp-mysql-server] POST error:', err);
      if (!res.headersSent) res.writeHead(500).end('Error handling message');
    }
    return;
  }

  // Health-check endpoint
  if (req.method === 'GET' && url.pathname === '/health') {
    try {
      await pool.execute('SELECT 1');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'ok', database: MYSQL_CONFIG.database }));
    } catch (error) {
      res.writeHead(503, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'error', error: error.message }));
    }
    return;
  }

  // Root endpoint - show server info
  if (req.method === 'GET' && url.pathname === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      name: 'MCP MySQL Server',
      version: '1.0.0',
      endpoints: {
        mcp: '/mcp',
        health: '/health',
      },
      database: {
        host: MYSQL_CONFIG.host,
        port: MYSQL_CONFIG.port,
        database: MYSQL_CONFIG.database,
      },
    }));
    return;
  }

  res.writeHead(404).end('Not found');
});

// Start server
async function start() {
  try {
    await testConnection();

    httpServer.listen(PORT, '0.0.0.0', () => {
      console.error(
        `[mcp-mysql-server] Listening on port ${PORT} — database: ${MYSQL_CONFIG.database} @ ${MYSQL_CONFIG.host}:${MYSQL_CONFIG.port}`,
      );
    });
  } catch (error) {
    console.error('[mcp-mysql-server] Failed to start server:', error);
    process.exit(1);
  }
}

// Handle shutdown gracefully
process.on('SIGTERM', async () => {
  console.error('[mcp-mysql-server] Shutting down gracefully...');
  await pool.end();
  httpServer.close(() => {
    console.error('[mcp-mysql-server] Server closed');
    process.exit(0);
  });
});

process.on('SIGINT', async () => {
  console.error('[mcp-mysql-server] Shutting down gracefully...');
  await pool.end();
  httpServer.close(() => {
    console.error('[mcp-mysql-server] Server closed');
    process.exit(0);
  });
});

start();
