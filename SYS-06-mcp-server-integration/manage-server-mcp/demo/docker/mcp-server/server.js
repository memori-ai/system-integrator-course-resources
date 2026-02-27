/**
 * MCP Filesystem Server — Demo 3
 *
 * Exposes four tools over the Model Context Protocol (SSE transport):
 *   list_files   – list the contents of a directory inside /workspace
 *   read_file    – read a single file
 *   write_file   – overwrite an existing file
 *   create_file  – create a new file (fails if it already exists)
 *
 * All paths are resolved relative to WORKSPACE_ROOT (/workspace by default).
 * Any attempt to escape that root via ".." is rejected.
 *
 * The server listens on PORT (default 8000) and exposes two endpoints:
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
const fs = require("fs");
const path = require("path");

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------
const WORKSPACE_ROOT = process.env.WORKSPACE_ROOT || "/workspace";

// ---------------------------------------------------------------------------
// Path helpers
// ---------------------------------------------------------------------------

/**
 * Resolve a user-supplied relative path to an absolute path inside
 * WORKSPACE_ROOT.  Throws if the result escapes the root.
 */
function safePath(userPath) {
  const resolved = path.resolve(WORKSPACE_ROOT, userPath);
  if (!resolved.startsWith(path.resolve(WORKSPACE_ROOT))) {
    throw new Error("Path escapes the allowed workspace directory");
  }
  return resolved;
}

// ---------------------------------------------------------------------------
// Tool definitions (returned by tools/list)
// ---------------------------------------------------------------------------
const TOOLS = [
  {
    name: "list_files",
    description:
      "List the files and directories inside a given path within the workspace. " +
      "Pass '.' or omit the path to list the workspace root.",
    inputSchema: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description:
            "Relative directory path inside the workspace (default: root)",
        },
      },
      required: [],
    },
  },
  {
    name: "read_file",
    description:
      "Read and return the full text content of a file inside the workspace.",
    inputSchema: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description: "Relative file path inside the workspace",
        },
      },
      required: ["path"],
    },
  },
  {
    name: "write_file",
    description:
      "Overwrite the content of an existing file inside the workspace. " +
      "Use create_file to create a brand-new file.",
    inputSchema: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description: "Relative file path inside the workspace",
        },
        content: {
          type: "string",
          description: "New text content to write",
        },
      },
      required: ["path", "content"],
    },
  },
  {
    name: "create_file",
    description:
      "Create a new file inside the workspace. Fails if the file already exists.",
    inputSchema: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description: "Relative file path inside the workspace",
        },
        content: {
          type: "string",
          description: "Initial text content for the new file",
        },
      },
      required: ["path", "content"],
    },
  },
];

// ---------------------------------------------------------------------------
// Tool handlers
// ---------------------------------------------------------------------------

function handleListFiles(input = {}) {
  const dirPath = safePath(input.path || ".");
  if (!fs.existsSync(dirPath)) {
    return { error: `Directory does not exist: ${input.path || "."}` };
  }
  const entries = fs.readdirSync(dirPath, { withFileTypes: true });
  const listing = entries.map(
    (e) => `${e.isDirectory() ? "[DIR]  " : "[FILE] "}${e.name}`,
  );
  return {
    content: listing.length ? listing.join("\n") : "(empty directory)",
  };
}

function handleReadFile(input = {}) {
  const filePath = safePath(input.path);
  if (!fs.existsSync(filePath)) {
    return { error: `File not found: ${input.path}` };
  }
  if (fs.statSync(filePath).isDirectory()) {
    return { error: `Path is a directory, not a file: ${input.path}` };
  }
  return { content: fs.readFileSync(filePath, "utf-8") };
}

function handleWriteFile(input = {}) {
  const filePath = safePath(input.path);
  if (!fs.existsSync(filePath)) {
    return {
      error: `File does not exist: ${input.path}. Use create_file instead.`,
    };
  }
  if (fs.statSync(filePath).isDirectory()) {
    return { error: `Path is a directory, not a file: ${input.path}` };
  }
  fs.writeFileSync(filePath, input.content, "utf-8");
  return { content: `File written successfully: ${input.path}` };
}

function handleCreateFile(input = {}) {
  const filePath = safePath(input.path);
  // Ensure parent directory exists
  const parentDir = path.dirname(filePath);
  if (!fs.existsSync(parentDir)) {
    return {
      error: `Parent directory does not exist: ${path.relative(WORKSPACE_ROOT, parentDir)}`,
    };
  }
  if (fs.existsSync(filePath)) {
    return {
      error: `File already exists: ${input.path}. Use write_file to overwrite.`,
    };
  }
  fs.writeFileSync(filePath, input.content, "utf-8");
  return { content: `File created successfully: ${input.path}` };
}

// ---------------------------------------------------------------------------
// MCP Server factory - creates a new server instance for each connection
// ---------------------------------------------------------------------------

function createMCPServer() {
  const server = new Server(
    {
      name: "mcp-filesystem-server",
      version: "1.0.0",
    },
    {
      capabilities: {
        tools: {},
      },
    },
  );

  server.setRequestHandler(ListToolsRequestSchema, () => {
    return { tools: TOOLS };
  });

  server.setRequestHandler(CallToolRequestSchema, (request) => {
    const { name, input, arguments: args } = request.params;
    const toolInput = input || args || {};

    let result;
    try {
      switch (name) {
        case "list_files":
          result = handleListFiles(toolInput);
          break;
        case "read_file":
          result = handleReadFile(toolInput);
          break;
        case "write_file":
          result = handleWriteFile(toolInput);
          break;
        case "create_file":
          result = handleCreateFile(toolInput);
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

const PORT = Number(process.env.PORT) || 8000;

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
      console.error(`[mcp-filesystem-server] Host header: ${host}`);
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
            `[mcp-filesystem-server] Endpoint rewrite: ${originalEndpoint} → ${newEndpoint}`,
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
        `[mcp-filesystem-server] SSE session established: ${transport.sessionId}`,
      );
    } catch (err) {
      console.error("[mcp-filesystem-server] SSE setup error:", err);
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
      console.error("[mcp-filesystem-server] POST error:", err);
      if (!res.headersSent) res.writeHead(500).end("Error handling message");
    }
    return;
  }

  // Health-check — useful for ngrok / load-balancer probes
  if (req.method === "GET" && url.pathname === "/health") {
    res
      .writeHead(200, { "Content-Type": "application/json" })
      .end(JSON.stringify({ status: "ok", workspace: WORKSPACE_ROOT }));
    return;
  }

  res.writeHead(404).end("Not found");
});

httpServer.listen(PORT, () => {
  console.error(
    `[mcp-filesystem-server] Listening on port ${PORT} — workspace root: ${WORKSPACE_ROOT}`,
  );
});

// Graceful shutdown
process.on("SIGTERM", () => {
  httpServer.close(() => process.exit(0));
});
process.on("SIGINT", () => {
  httpServer.close(() => process.exit(0));
});
