#!/usr/bin/env node
// Stops all course demos started with `npm run start:all`.
//
// Cross-platform on purpose (Windows/macOS/Linux) -- see start-all.js.
//
// Usage:
//   npm run stop:all

'use strict';

const { execSync } = require('child_process');
const path = require('path');

const SCRIPT_DIR = __dirname;

const DEMOS = [
  {
    name: 'SYS-03 - Enterprise Authentication',
    dir: path.join(SCRIPT_DIR, 'SYS-03-integrating-enterprise-authentication', 'manage_login', 'demo'),
  },
  {
    name: 'SYS-04 - Advanced Functions',
    dir: path.join(SCRIPT_DIR, 'SYS-04-advanced-functions', 'manage_functions', 'demo'),
  },
  {
    name: 'SYS-05 - Web Component Programming',
    dir: path.join(SCRIPT_DIR, 'SYS-05-web-component-programming', 'web_component', 'demo'),
  },
  {
    name: 'SYS-06 - MCP Server Integration',
    dir: path.join(SCRIPT_DIR, 'SYS-06-mcp-server-integration', 'manage-server-mcp', 'demo'),
  },
];

for (const demo of DEMOS) {
  console.log(`\n-- Stopping ${demo.name} --`);
  try {
    execSync('docker compose down', { cwd: demo.dir, stdio: 'inherit' });
  } catch (err) {
    console.error(`  ERROR stopping ${demo.name}: ${err.message}`);
  }
}

console.log('\nAll demos stopped.');
