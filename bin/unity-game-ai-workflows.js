#!/usr/bin/env node
"use strict";

const fs = require("fs");
const os = require("os");
const path = require("path");

const SKILL_NAME = "unity-game-ai-workflows";
const PACKAGE_ROOT = path.resolve(__dirname, "..");
const PAYLOAD = [
  "SKILL.md",
  "README.md",
  "package.json",
  "agents",
  "bin",
  "references",
  "scripts",
];

const DEFAULT_TARGETS = {
  codex: path.join(os.homedir(), ".codex", "skills", SKILL_NAME),
  claude: path.join(os.homedir(), ".claude", "skills", SKILL_NAME),
};

function usage() {
  console.log(`Unity Game AI Workflows installer

Usage:
  npx unity-game-ai-workflows [options]
  npx git+ssh://git@github.com/Aun-Phuwanan/unity-game-ai-workflows.git [options]
  npx github:Aun-Phuwanan/unity-game-ai-workflows [options]

Options:
  --target codex|claude|both   Install target. Default: codex
  --codex                      Same as --target codex
  --claude                     Same as --target claude
  --all, --both                Same as --target both
  --dest <path>                Install to a custom skill directory
  --dry-run                    Show actions without writing files
  --no-backup                  Replace an existing target without backup
  --help                       Show this help
  --version                    Show package version

Examples:
  npx unity-game-ai-workflows
  npx unity-game-ai-workflows --target both
  npx git+ssh://git@github.com/Aun-Phuwanan/unity-game-ai-workflows.git --dry-run
`);
}

function packageVersion() {
  const packageJson = JSON.parse(
    fs.readFileSync(path.join(PACKAGE_ROOT, "package.json"), "utf8")
  );
  return packageJson.version;
}

function parseArgs(argv) {
  const options = {
    target: "codex",
    dest: null,
    dryRun: false,
    backup: true,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--help" || arg === "-h") {
      usage();
      process.exit(0);
    }
    if (arg === "--version" || arg === "-v") {
      console.log(packageVersion());
      process.exit(0);
    }
    if (arg === "--target") {
      const value = argv[index + 1];
      if (!value) {
        throw new Error("--target requires codex, claude, or both");
      }
      options.target = normalizeTarget(value);
      index += 1;
      continue;
    }
    if (arg.startsWith("--target=")) {
      options.target = normalizeTarget(arg.slice("--target=".length));
      continue;
    }
    if (arg === "--codex") {
      options.target = "codex";
      continue;
    }
    if (arg === "--claude") {
      options.target = "claude";
      continue;
    }
    if (arg === "--all" || arg === "--both") {
      options.target = "both";
      continue;
    }
    if (arg === "--dest") {
      const value = argv[index + 1];
      if (!value) {
        throw new Error("--dest requires a path");
      }
      options.dest = path.resolve(expandHome(value));
      index += 1;
      continue;
    }
    if (arg.startsWith("--dest=")) {
      options.dest = path.resolve(expandHome(arg.slice("--dest=".length)));
      continue;
    }
    if (arg === "--dry-run") {
      options.dryRun = true;
      continue;
    }
    if (arg === "--no-backup") {
      options.backup = false;
      continue;
    }
    throw new Error(`Unknown option: ${arg}`);
  }

  return options;
}

function normalizeTarget(value) {
  const normalized = String(value).trim().toLowerCase();
  if (normalized === "all") {
    return "both";
  }
  if (!["codex", "claude", "both"].includes(normalized)) {
    throw new Error(`Unsupported target: ${value}`);
  }
  return normalized;
}

function expandHome(value) {
  if (value === "~") {
    return os.homedir();
  }
  if (value.startsWith("~/")) {
    return path.join(os.homedir(), value.slice(2));
  }
  return value;
}

function selectedTargets(options) {
  if (options.dest) {
    return [["custom", options.dest]];
  }
  if (options.target === "both") {
    return Object.entries(DEFAULT_TARGETS);
  }
  return [[options.target, DEFAULT_TARGETS[options.target]]];
}

function verifyPayload() {
  for (const entry of PAYLOAD) {
    const source = path.join(PACKAGE_ROOT, entry);
    if (!fs.existsSync(source)) {
      throw new Error(`Package payload missing: ${entry}`);
    }
  }
}

function installTarget(label, destination, options) {
  const resolvedDestination = path.resolve(destination);
  const resolvedSource = path.resolve(PACKAGE_ROOT);

  if (resolvedDestination === resolvedSource) {
    console.log(`Already installed at ${resolvedDestination}`);
    return;
  }

  const parent = path.dirname(resolvedDestination);
  let backupPath = null;

  console.log(
    `${options.dryRun ? "Would install" : "Installing"} ${SKILL_NAME} -> ${resolvedDestination} (${label})`
  );

  if (fs.existsSync(resolvedDestination)) {
    if (options.backup) {
      backupPath = nextBackupPath(resolvedDestination);
      console.log(
        `${options.dryRun ? "Would backup" : "Backing up"} existing skill -> ${backupPath}`
      );
    } else {
      console.log(
        `${options.dryRun ? "Would replace" : "Replacing"} existing skill without backup`
      );
    }
  }

  if (options.dryRun) {
    return;
  }

  fs.mkdirSync(parent, { recursive: true });

  try {
    if (fs.existsSync(resolvedDestination)) {
      if (backupPath) {
        fs.renameSync(resolvedDestination, backupPath);
      } else {
        fs.rmSync(resolvedDestination, { recursive: true, force: true });
      }
    }

    fs.mkdirSync(resolvedDestination, { recursive: true });
    for (const entry of PAYLOAD) {
      copyEntry(entry, resolvedDestination);
    }
  } catch (error) {
    if (backupPath && fs.existsSync(backupPath)) {
      fs.rmSync(resolvedDestination, { recursive: true, force: true });
      fs.renameSync(backupPath, resolvedDestination);
    }
    throw error;
  }
}

function copyEntry(entry, destination) {
  const source = path.join(PACKAGE_ROOT, entry);
  const target = path.join(destination, entry);
  const stat = fs.statSync(source);

  if (stat.isDirectory()) {
    fs.cpSync(source, target, {
      recursive: true,
      filter: (currentPath) => !currentPath.includes(`${path.sep}.git${path.sep}`),
    });
    return;
  }

  fs.copyFileSync(source, target);
  fs.chmodSync(target, stat.mode);
}

function nextBackupPath(destination) {
  const stamp = new Date()
    .toISOString()
    .replace(/[-:]/g, "")
    .replace(/\..+$/, "Z");
  const base = `${destination}.backup-${stamp}`;
  let candidate = base;
  let suffix = 1;

  while (fs.existsSync(candidate)) {
    suffix += 1;
    candidate = `${base}-${suffix}`;
  }

  return candidate;
}

function main() {
  const options = parseArgs(process.argv.slice(2));
  verifyPayload();

  for (const [label, destination] of selectedTargets(options)) {
    installTarget(label, destination, options);
  }

  if (!options.dryRun) {
    console.log("Install complete.");
    console.log(`Invoke with: Use $${SKILL_NAME} ...`);
  }
}

try {
  main();
} catch (error) {
  console.error(`Error: ${error.message}`);
  process.exit(1);
}
