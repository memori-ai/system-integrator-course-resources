#!/usr/bin/env node
// Starts all course demos (SYS-03, SYS-04, SYS-05, SYS-06) in the background, each on
// its own port, so you don't have to `cd` into each demo/ folder one by one.
//
// Cross-platform on purpose (Windows/macOS/Linux): uses Node's child_process
// and path/fs modules instead of shell-specific syntax, so it runs the same
// way everywhere Node.js runs. Only Node.js and Docker are required.
//
// Usage:
//   npm run start:all            verbose: every Docker line is printed
//   node start-all.js --quiet    quiet: one line per step, details go to avvio.log
//
// The quiet mode is what the double-click launchers (avvia.bat / avvia.command)
// use: course attendees are not developers, and several minutes of Docker build
// output scrolling by reads as "something is broken" to them.
//
// Then open index.html (the demo hub) to jump between them.

'use strict';

const { execSync, exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const SCRIPT_DIR = __dirname;

const QUIET = process.argv.includes('--quiet');
const LOG_FILE = path.join(SCRIPT_DIR, 'avvio.log');

// Demos that failed to start, reported together at the end so the launcher can
// tell the attendee which ones to retry instead of scrolling back up.
const failures = [];

// Logging must never be the reason the launcher dies (read-only folder, disk
// full, antivirus holding the file): every failure here is swallowed.
function logAppend(text) {
  if (!QUIET) return;
  try {
    fs.appendFileSync(LOG_FILE, text);
  } catch (err) {
    /* ignored on purpose */
  }
}

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
  if (!QUIET) {
    console.log(`  $ ${cmd}`);
    execSync(cmd, { cwd, stdio: 'inherit' });
    return;
  }

  // A first `docker compose build` easily prints more than the 1 MB execSync
  // allows by default, so the buffer is raised: hitting the limit would abort a
  // build that was going perfectly well.
  logAppend(`\n$ ${cmd}\n  (in ${cwd})\n`);
  try {
    const out = execSync(cmd, { cwd, stdio: ['ignore', 'pipe', 'pipe'], maxBuffer: 64 * 1024 * 1024 });
    logAppend(out.toString());
  } catch (err) {
    logAppend(`${err.stdout || ''}${err.stderr || ''}\n`);
    throw err;
  }
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

// The labels are Italian because they are only ever printed in quiet mode, and
// quiet mode exists for the Italian double-click launchers. Running the script
// the documented way (npm run start:all) keeps the English developer output.
const STEPS = [
  ['preparazione immagine (la prima volta scarica parecchi dati)', 'docker compose build'],
  ['installazione dipendenze', 'docker compose run --rm web bundle install'],
  ['avvio dei servizi', 'docker compose up -d'],
];

function startDemo(demo, position, total) {
  if (QUIET) {
    console.log(`  [${position}/${total}] ${demo.name}  ->  http://localhost:${demo.port}`);
  } else {
    console.log(`\n-- ${demo.name} (http://localhost:${demo.port}) --`);
  }

  // ensureEnvFile() writes inside the demo folder, so a missing folder used to
  // throw outside the try below and kill the whole run: one incomplete download
  // and none of the other demos would start.
  if (!fs.existsSync(demo.dir)) {
    failures.push(demo.name);
    console.error(QUIET
      ? `          cartella non trovata, demo saltata: ${demo.dir}`
      : `  ERROR: folder not found, skipping: ${demo.dir}`);
    return;
  }

  ensureEnvFile(demo);

  try {
    for (const [label, cmd] of STEPS) {
      if (QUIET) console.log(`          ${label}...`);
      run(cmd, demo.dir);
    }
    console.log(QUIET ? '          pronta.' : '  Started.');
  } catch (err) {
    failures.push(demo.name);
    if (QUIET) {
      console.error(`          NON avviata. Dettagli tecnici in ${LOG_FILE}`);
    } else {
      console.error(`  ERROR starting ${demo.name}: ${err.message}`);
      console.error('  Continuing with the next demo...');
    }
  }
}

function openInBrowser(filePath) {
  // On Windows `start` pops up a blocking "cannot find the file" dialog when the
  // path is wrong, which would leave the launcher window hanging forever with no
  // way out for the attendee. Checking first costs nothing.
  if (!fs.existsSync(filePath)) {
    console.log(`Non trovo la pagina con l'elenco delle demo: ${filePath}`);
    return;
  }

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

if (QUIET) {
  // Start from an empty log: the attendee is told to send us "avvio.log" when
  // something breaks, and it has to describe this run only.
  try {
    fs.writeFileSync(LOG_FILE, `Avvio del ${new Date().toLocaleString()}\n`);
  } catch (err) {
    /* ignored on purpose */
  }
} else {
  console.log('Starting all course demos in the background (this can take a while on first run)...');
}

DEMOS.forEach((demo, i) => startDemo(demo, i + 1, DEMOS.length));

if (QUIET) {
  if (failures.length) {
    // Exit code 1 lets avvia.bat / avvia.command print a different closing
    // message instead of claiming everything went well.
    process.exitCode = 1;
    console.log(`\n  Queste demo non sono partite: ${failures.join(', ')}`);
  }
} else {
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
  if (failures.length) process.exitCode = 1;
}

openInBrowser(path.join(SCRIPT_DIR, 'index.html'));
