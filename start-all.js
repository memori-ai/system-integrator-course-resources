#!/usr/bin/env node
// Starts all course demos (SYS-03, SYS-04, SYS-05, SYS-06) in the background, each on
// its own port, so you don't have to `cd` into each demo/ folder one by one.
//
// Cross-platform on purpose (Windows/macOS/Linux): uses Node's child_process
// and path/fs modules instead of shell-specific syntax, so it runs the same
// way everywhere Node.js runs. Only Node.js and Docker are required.
//
// Usage:
//   npm run start:all
//
// Then open index.html (the demo hub) to jump between them.

'use strict';

const { execSync, exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const SCRIPT_DIR = __dirname;

const DEMOS = [
  {
    name: 'SYS-03 - Enterprise Authentication',
    dir: path.join(SCRIPT_DIR, 'SYS-03-integrating-enterprise-authentication', 'manage_login', 'demo'),
    port: 13000,
    envFile: '.env_dev',
    envContent: 'MONGO_URI=mongodb://mongodb:27017/embedded_webcomponent_auth_development\n',
  },
  {
    name: 'SYS-04 - Advanced Functions',
    dir: path.join(SCRIPT_DIR, 'SYS-04-advanced-functions', 'manage_functions', 'demo'),
    port: 13004,
    envFile: '.env_dev',
    envContent: 'MONGO_URI=mongodb://mongodb:27017/sys_04_advanced_functions_development\n',
  },
  {
    name: 'SYS-05 - Web Component Programming',
    dir: path.join(SCRIPT_DIR, 'SYS-05-web-component-programming', 'web_component', 'demo'),
    port: 13005,
    envFile: '.env_dev',
    envContent: 'MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development\n',
  },
  {
    name: 'SYS-06 - MCP Server Integration',
    dir: path.join(SCRIPT_DIR, 'SYS-06-mcp-server-integration', 'manage-server-mcp', 'demo'),
    port: 13006,
    envFile: '.env',
    // No default: NGROK_AUTHTOKEN is personal, must come from the user.
    envContent: null,
  },
];

function run(cmd, cwd) {
  console.log(`  $ ${cmd}`);
  execSync(cmd, { cwd, stdio: 'inherit' });
}

function ensureEnvFile(demo) {
  const envPath = path.join(demo.dir, demo.envFile);
  if (fs.existsSync(envPath)) return;

  if (demo.envContent) {
    console.log(`  Creating missing ${demo.envFile} with default values...`);
    fs.writeFileSync(envPath, demo.envContent);
  } else {
    console.log(`  WARNING: ${demo.envFile} not found and requires a value only you can provide (NGROK_AUTHTOKEN).`);
    console.log('  Creating a placeholder file -- edit it with your real ngrok auth token, then re-run this script:');
    console.log(`  ${envPath}`);
    fs.writeFileSync(envPath, 'NGROK_AUTHTOKEN=your_token_here\n');
  }
}

function startDemo(demo) {
  console.log(`\n-- ${demo.name} (http://localhost:${demo.port}) --`);
  ensureEnvFile(demo);

  try {
    run('docker compose build', demo.dir);
    run('docker compose run --rm web bundle install', demo.dir);
    run('docker compose up -d', demo.dir);
    console.log('  Started.');
  } catch (err) {
    console.error(`  ERROR starting ${demo.name}: ${err.message}`);
    console.error('  Continuing with the next demo...');
  }
}

function openInBrowser(filePath) {
  // Cross-platform "open this file with the default browser".
  // macOS: `open`, Windows: `start` (a cmd.exe builtin, needs a shell), Linux: `xdg-open`.
  let cmd;
  if (process.platform === 'darwin') {
    cmd = `open "${filePath}"`;
  } else if (process.platform === 'win32') {
    // `start` needs an empty title argument ("") when the path might contain spaces.
    cmd = `start "" "${filePath}"`;
  } else {
    cmd = `xdg-open "${filePath}"`;
  }

  exec(cmd, (err) => {
    if (err) {
      console.log(`Could not open the hub page automatically. Open it yourself:\n  ${filePath}`);
    }
  });
}

console.log('Starting all course demos in the background (this can take a while on first run)...');

for (const demo of DEMOS) {
  startDemo(demo);
}

console.log(`
All demos are starting up:
  SYS-03  ->  http://localhost:13000
  SYS-04  ->  http://localhost:13004
  SYS-05  ->  http://localhost:13005
  SYS-06  ->  http://localhost:13006

Check status any time with:
  docker ps

Stop everything with:
  npm run stop:all
`);

openInBrowser(path.join(SCRIPT_DIR, 'index.html'));
