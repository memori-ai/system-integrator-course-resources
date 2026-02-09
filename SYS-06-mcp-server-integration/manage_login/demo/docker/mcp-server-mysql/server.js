/**
 * MCP MySQL Server — Demo 1
 *
 * Exposes six tools over the Model Context Protocol (SSE transport):
 *   list_tables    – list all tables in the database
 *   describe_table – show the structure (columns, types) of a table
 *   execute_query  – run a SELECT query
 *   insert_row     – insert a new row into a table
 *   update_rows    – update existing rows (with WHERE condition)
 *   delete_rows    – delete rows (with WHERE condition)
 *
 * The server listens on PORT (default 8001) and exposes two endpoints:
 *   GET  /mcp       – establishes the SSE stream
 *   POST /messages  – receives JSON-RPC messages from the client
 *
 * An ngrok sidecar container (defined in docker-compose) tunnels this port
 * to a public URL that AIsuru agents can reach.
 */

const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
const {
  SSEServerTransport,
} = require("@modelcontextprotocol/sdk/server/sse.js");
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require("@modelcontextprotocol/sdk/types.js");
const http = require("http");
const mysql = require("mysql2/promise");

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------
const PORT = Number(process.env.PORT) || 8001;

const MYSQL_CONFIG = {
  host: process.env.MYSQL_HOST || "localhost",
  port: Number(process.env.MYSQL_PORT) || 3306,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
};

// Validate required MySQL config
if (!MYSQL_CONFIG.user || !MYSQL_CONFIG.password || !MYSQL_CONFIG.database) {
  console.error(
    "[mcp-mysql-server] ERROR: Missing required MySQL environment variables",
  );
  console.error("Required: MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE");
  process.exit(1);
}

// ---------------------------------------------------------------------------
// Tool definitions (returned by tools/list)
// ---------------------------------------------------------------------------
const TOOLS = [
  {
    name: "list_tables",
    description:
      "List all tables in the database. Returns the names of all tables available.",
    inputSchema: {
      type: "object",
      properties: {},
      required: [],
    },
  },
  {
    name: "describe_table",
    description:
      "Show the structure (columns, types, keys) of a specific table. " +
      "Returns detailed information about each column.",
    inputSchema: {
      type: "object",
      properties: {
        table: {
          type: "string",
          description: "The name of the table to describe",
        },
      },
      required: ["table"],
    },
  },
  {
    name: "execute_query",
    description:
      "Execute a SELECT query on the database. Only SELECT statements are allowed. " +
      "Returns the query results as a formatted table.",
    inputSchema: {
      type: "object",
      properties: {
        query: {
          type: "string",
          description:
            "The SELECT SQL query to execute (e.g., 'SELECT * FROM users LIMIT 10')",
        },
      },
      required: ["query"],
    },
  },
  {
    name: "insert_row",
    description:
      "Insert a new row into a table. Provide the table name and a JSON object " +
      "with column-value pairs.",
    inputSchema: {
      type: "object",
      properties: {
        table: {
          type: "string",
          description: "The table name",
        },
        data: {
          type: "object",
          description:
            "A JSON object with column names as keys and values to insert",
        },
      },
      required: ["table", "data"],
    },
  },
  {
    name: "update_rows",
    description:
      "Update existing rows in a table. Provide the table name, a JSON object " +
      "with column-value pairs to set, and a WHERE condition to filter rows.",
    inputSchema: {
      type: "object",
      properties: {
        table: {
          type: "string",
          description: "The table name",
        },
        data: {
          type: "object",
          description: "A JSON object with column names as keys and new values",
        },
        where: {
          type: "string",
          description:
            "SQL WHERE condition (e.g., 'id = 5' or 'status = \"active\"')",
        },
      },
      required: ["table", "data", "where"],
    },
  },
  {
    name: "delete_rows",
    description:
      "Delete rows from a table. Provide the table name and a WHERE condition. " +
      "Be careful: this permanently removes data.",
    inputSchema: {
      type: "object",
      properties: {
        table: {
          type: "string",
          description: "The table name",
        },
        where: {
          type: "string",
          description:
            "SQL WHERE condition (e.g., 'id = 5' or 'created_at < \"2023-01-01\"')",
        },
      },
      required: ["table", "where"],
    },
  },
];

// ---------------------------------------------------------------------------
// Tool handlers
// ---------------------------------------------------------------------------

/**
 * Helper: format query results as a readable table
 */
function formatTable(rows) {
  if (!rows || rows.length === 0) return "(no rows)";

  const columns = Object.keys(rows[0]);
  const header = columns.join(" | ");
  const separator = columns.map(() => "---").join(" | ");
  const body = rows
    .map((row) => columns.map((col) => String(row[col] ?? "NULL")).join(" | "))
    .join("\n");

  return `${header}\n${separator}\n${body}`;
}

/**
 * 1. LIST_TABLES
 * Returns all table names in the database
 */
async function handleListTables(input = {}) {
  const connection = await mysql.createConnection(MYSQL_CONFIG);
  try {
    const [tables] = await connection.query("SHOW TABLES");
    if (tables.length === 0) {
      return { content: "(no tables found in database)" };
    }
    const tableNames = tables.map((t) => Object.values(t)[0]);
    return { content: tableNames.join("\n") };
  } catch (err) {
    return { error: err.message };
  } finally {
    await connection.end();
  }
}

/**
 * 2. DESCRIBE_TABLE
 * Shows the structure (columns, types, keys) of a table
 */
async function handleDescribeTable(input = {}) {
  const { table } = input;
  if (!table) {
    return { error: "Missing required parameter: table" };
  }

  const connection = await mysql.createConnection(MYSQL_CONFIG);
  try {
    // Use DESCRIBE or SHOW COLUMNS to get table structure
    const [columns] = await connection.query("DESCRIBE ??", [table]);
    return { content: formatTable(columns) };
  } catch (err) {
    return { error: err.message };
  } finally {
    await connection.end();
  }
}

/**
 * 3. EXECUTE_QUERY
 * Executes a SELECT query (read-only for safety)
 */
async function handleExecuteQuery(input = {}) {
  const { query } = input;
  if (!query) {
    return { error: "Missing required parameter: query" };
  }

  // Security: only allow SELECT statements
  const trimmed = query.trim().toUpperCase();
  if (!trimmed.startsWith("SELECT")) {
    return {
      error:
        "Only SELECT queries are allowed. Use other tools for INSERT/UPDATE/DELETE.",
    };
  }

  const connection = await mysql.createConnection(MYSQL_CONFIG);
  try {
    const [rows] = await connection.query(query);
    return { content: formatTable(rows) };
  } catch (err) {
    return { error: err.message };
  } finally {
    await connection.end();
  }
}

/**
 * 4. INSERT_ROW
 * Inserts a new row into a table
 */
async function handleInsertRow(input = {}) {
  const { table, data } = input;
  if (!table || !data) {
    return { error: "Missing required parameters: table, data" };
  }

  const columns = Object.keys(data);
  const values = Object.values(data);

  if (columns.length === 0) {
    return { error: "data object is empty" };
  }

  const placeholders = columns.map(() => "?").join(", ");
  const columnsList = columns.map((c) => `??`).join(", ");
  const query = `INSERT INTO ?? (${columnsList}) VALUES (${placeholders})`;

  // Flatten parameters: [table, ...columns, ...values]
  const params = [table, ...columns, ...values];

  const connection = await mysql.createConnection(MYSQL_CONFIG);
  try {
    const [result] = await connection.execute(query, params);
    return {
      content: `Row inserted successfully. Insert ID: ${result.insertId}, Rows affected: ${result.affectedRows}`,
    };
  } catch (err) {
    return { error: err.message };
  } finally {
    await connection.end();
  }
}

/**
 * 5. UPDATE_ROWS
 * Updates existing rows in a table based on a WHERE condition
 */
async function handleUpdateRows(input = {}) {
  const { table, data, where } = input;
  if (!table || !data || !where) {
    return { error: "Missing required parameters: table, data, where" };
  }

  const columns = Object.keys(data);
  const values = Object.values(data);

  if (columns.length === 0) {
    return { error: "data object is empty" };
  }

  const setClause = columns.map((c) => `?? = ?`).join(", ");
  const query = `UPDATE ?? SET ${setClause} WHERE ${where}`;

  // Flatten parameters: [table, col1, val1, col2, val2, ...]
  const params = [table];
  columns.forEach((col, i) => {
    params.push(col, values[i]);
  });

  const connection = await mysql.createConnection(MYSQL_CONFIG);
  try {
    const [result] = await connection.execute(query, params);
    return {
      content: `Rows updated successfully. Rows affected: ${result.affectedRows}`,
    };
  } catch (err) {
    return { error: err.message };
  } finally {
    await connection.end();
  }
}

/**
 * 6. DELETE_ROWS
 * Deletes rows from a table based on a WHERE condition
 */
async function handleDeleteRows(input = {}) {
  const { table, where } = input;
  if (!table || !where) {
    return { error: "Missing required parameters: table, where" };
  }

  const query = `DELETE FROM ?? WHERE ${where}`;

  const connection = await mysql.createConnection(MYSQL_CONFIG);
  try {
    const [result] = await connection.execute(query, [table]);
    return {
      content: `Rows deleted successfully. Rows affected: ${result.affectedRows}`,
    };
  } catch (err) {
    return { error: err.message };
  } finally {
    await connection.end();
  }
}

// ---------------------------------------------------------------------------
// MCP Server factory - creates a new server instance for each connection
// ---------------------------------------------------------------------------

function createMCPServer() {
  const server = new Server(
    {
      name: "mcp-mysql-server",
      version: "1.0.0",
    },
    {
      capabilities: {
        tools: {},
      },
    },
  );

  // Handler: list available tools
  server.setRequestHandler(ListToolsRequestSchema, () => {
    return { tools: TOOLS };
  });

  // Handler: execute a tool call
  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, input, arguments: args } = request.params;
    const toolInput = input || args || {};

    let result;
    try {
      // Map tool name to handler function
      switch (name) {
        case "list_tables":
          result = await handleListTables(toolInput);
          break;
        case "describe_table":
          result = await handleDescribeTable(toolInput);
          break;
        case "execute_query":
          result = await handleExecuteQuery(toolInput);
          break;
        case "insert_row":
          result = await handleInsertRow(toolInput);
          break;
        case "update_rows":
          result = await handleUpdateRows(toolInput);
          break;
        case "delete_rows":
          result = await handleDeleteRows(toolInput);
          break;
        default:
          result = { error: `Unknown tool: ${name}` };
      }
    } catch (err) {
      result = { error: err.message };
    }

    // MCP expects content as an array of { type, text } blocks
    const text = result.error ? `ERROR: ${result.error}` : result.content;
    return {
      content: [{ type: "text", text }],
      isError: !!result.error,
    };
  });

  return server;
}

// ---------------------------------------------------------------------------
// HTTP server + SSE transport
// ---------------------------------------------------------------------------

// In-memory map: sessionId → SSEServerTransport
const transports = {};

// Minimal JSON body parser (no external dependency)
function parseBody(req) {
  return new Promise((resolve, reject) => {
    let data = "";
    req.on("data", (chunk) => (data += chunk));
    req.on("end", () => {
      try {
        resolve(data ? JSON.parse(data) : {});
      } catch (e) {
        reject(e);
      }
    });
  });
}

const httpServer = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  // CORS headers - required for external clients (Aisuru AI)
  const origin = req.headers.origin || "*";
  res.setHeader("Access-Control-Allow-Origin", origin);
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Cache-Control");
  res.setHeader("Access-Control-Allow-Credentials", "true");

  // Handle preflight OPTIONS requests
  if (req.method === "OPTIONS") {
    res.writeHead(204);
    res.end();
    return;
  }

  // GET /mcp — establish SSE stream
  if (req.method === "GET" && url.pathname === "/mcp") {
    try {
      // The SDK's SSEServerTransport always emits a *relative* endpoint path
      // in the SSE "endpoint" event.  When the server is behind a reverse proxy
      // (ngrok), the MCP client needs the full absolute URL to POST messages
      // back.  We wrap res.write so that the single "endpoint" event is
      // rewritten to an absolute URL using the Host header that ngrok forwards.
      const host = req.headers.host;
      console.error(`[mcp-mysql-server] Host header: ${host}`);
      const originalWrite = res.write.bind(res);
      let endpointRewritten = false;
      res.write = function (chunk, ...args) {
        if (
          !endpointRewritten &&
          typeof chunk === "string" &&
          chunk.includes("event: endpoint")
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
      const transport = new SSEServerTransport("/messages", res);
      transports[transport.sessionId] = transport;
      transport.onclose = () => delete transports[transport.sessionId];

      await server.connect(transport);
      console.error(
        `[mcp-mysql-server] SSE session established: ${transport.sessionId}`,
      );
    } catch (err) {
      console.error("[mcp-mysql-server] SSE setup error:", err);
      if (!res.headersSent) res.writeHead(500).end("SSE setup failed");
    }
    return;
  }

  // POST /messages — receive JSON-RPC from client
  if (req.method === "POST" && url.pathname === "/messages") {
    const sessionId = url.searchParams.get("sessionId");
    if (!sessionId || !transports[sessionId]) {
      res.writeHead(sessionId ? 404 : 400).end("Session not found");
      return;
    }
    try {
      const body = await parseBody(req);
      await transports[sessionId].handlePostMessage(req, res, body);
    } catch (err) {
      console.error("[mcp-mysql-server] POST error:", err);
      if (!res.headersSent) res.writeHead(500).end("Error handling message");
    }
    return;
  }

  // Health-check — useful for ngrok / load-balancer probes
  if (req.method === "GET" && url.pathname === "/health") {
    res
      .writeHead(200, { "Content-Type": "application/json" })
      .end(JSON.stringify({ status: "ok", database: MYSQL_CONFIG.database }));
    return;
  }

  res.writeHead(404).end("Not found");
});

httpServer.listen(PORT, () => {
  console.error(
    `[mcp-mysql-server] Listening on port ${PORT} — database: ${MYSQL_CONFIG.database}`,
  );
});

// Graceful shutdown
process.on("SIGTERM", () => {
  httpServer.close(() => process.exit(0));
});
process.on("SIGINT", () => {
  httpServer.close(() => process.exit(0));
});
