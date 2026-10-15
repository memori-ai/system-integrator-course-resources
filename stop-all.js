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
    project: 'sys03-login-demo',
  },
  {
    name: 'SYS-04 - Advanced Functions',
    dir: path.join(SCRIPT_DIR, 'SYS-04-advanced-functions', 'manage_functions', 'demo'),
    project: 'sys04-functions-demo',
  },
  {
    name: 'SYS-05 - Web Component Programming',
    dir: path.join(SCRIPT_DIR, 'SYS-05-web-component-programming', 'web_component', 'demo'),
    project: 'sys05-webcomponent-demo',
  },
  {
    name: 'SYS-06 - MCP Server Integration',
    dir: path.join(SCRIPT_DIR, 'SYS-06-mcp-server-integration', 'manage-server-mcp', 'demo'),
    project: 'sys06-mcp-demo',
  },
];

// Runs a command and returns its stdout, or null if it failed.
function run(cmd, opts = {}) {
  try {
    return execSync(cmd, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'], ...opts }).trim();
  } catch (err) {
    return null;
  }
}

// Some demos (SYS-06) start extra containers from *inside* the Rails container
// -- ngrok tunnels launched by infra_controller.rb. Those carry the compose
// project label but a different working_dir, so `docker compose down` on the
// host leaves them running and the project network stays "in use".
// This removes whatever is left over, by label.
function cleanupProject(project) {
  const ids = run(`docker ps -aq --filter label=com.docker.compose.project=${project}`);
  if (ids) {
    const list = ids.split(/\r?\n/).filter(Boolean);
    console.log(`  Removing ${list.length} leftover container(s)...`);
    run(`docker rm -f ${list.join(' ')}`);
  }

  const nets = run(`docker network ls -q --filter label=com.docker.compose.project=${project}`);
  const netList = nets ? nets.split(/\r?\n/).filter(Boolean) : [];
  if (netList.length) {
    console.log(`  Removing ${netList.length} leftover network(s)...`);
    for (const net of netList) run(`docker network rm ${net}`);
  }
}

for (const demo of DEMOS) {
  console.log(`\n-- Stopping ${demo.name} --`);
  try {
    execSync('docker compose down', { cwd: demo.dir, stdio: 'inherit' });
  } catch (err) {
    console.error(`  ERROR stopping ${demo.name}: ${err.message}`);
  }
  cleanupProject(demo.project);
}

console.log('\nAll demos stopped.');
