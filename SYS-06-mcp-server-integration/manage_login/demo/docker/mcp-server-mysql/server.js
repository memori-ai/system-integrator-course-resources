#!/usr/bin/env node

/**
 * MCP Server for MySQL Database Operations
 *
 * This server uses the @benborla29/mcp-server-mysql package to expose
 * MySQL database operations via the Model Context Protocol (MCP).
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

// Test database connection
async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('✓ Successfully connected to MySQL database');
    connection.release();
  } catch (error) {
    console.error('✗ Failed to connect to MySQL:', error.message);
    throw error;
  }
}

// Create MCP server instance
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

// Register tools for database operations
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
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
    ],
  };
});

// Handle tool execution
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'query': {
        const { sql } = args;

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
        const { sql } = args;

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
        const { table } = args;

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

// Create HTTP server with SSE transport
const httpServer = createServer(async (req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  if (req.url === '/health') {
    try {
      await pool.execute('SELECT 1');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'healthy', database: 'connected' }));
    } catch (error) {
      res.writeHead(503, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'unhealthy', error: error.message }));
    }
    return;
  }

  if (req.url === '/mcp' || req.url === '/sse') {
    // Create a new server instance for each connection
    const connectionServer = new Server(
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

    // Register the same handlers
    connectionServer.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
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
        ],
      };
    });

    connectionServer.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        switch (name) {
          case 'query': {
            const { sql } = args;

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
            const { sql } = args;

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
            const { table } = args;

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

    const transport = new SSEServerTransport('/mcp', res);
    await connectionServer.connect(transport);
    return;
  }

  // Root endpoint - show server info
  if (req.url === '/') {
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

  res.writeHead(404);
  res.end('Not Found');
});

// Start server
async function start() {
  try {
    await testConnection();

    httpServer.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 MCP MySQL Server running on http://0.0.0.0:${PORT}`);
      console.log(`📊 Database: ${MYSQL_CONFIG.database} @ ${MYSQL_CONFIG.host}:${MYSQL_CONFIG.port}`);
      console.log(`🔌 MCP endpoint: http://0.0.0.0:${PORT}/mcp`);
      console.log(`💚 Health check: http://0.0.0.0:${PORT}/health`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Handle shutdown gracefully
process.on('SIGTERM', async () => {
  console.log('Shutting down gracefully...');
  await pool.end();
  httpServer.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

start();
