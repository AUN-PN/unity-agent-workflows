#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const root = path.resolve(__dirname, "..");
const contractPath = path.join(root, "evals", "skill-semantic-contract.json");
const evalPath = path.join(root, "evals", "skill-trigger-cases.json");

function fail(message) {
  failures.push(message);
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, "utf8"));
}

function readFile(rel) {
  return fs.readFileSync(path.join(root, rel), "utf8");
}

function gitShow(rel) {
  try {
    return execFileSync("git", ["show", `HEAD:${rel}`], {
      cwd: root,
      encoding: "utf8",
      stdio: ["ignore", "pipe", "pipe"],
    });
  } catch (_error) {
    return null;
  }
}

function normalize(text) {
  return String(text)
    .toLowerCase()
    .replace(/[`\*_#>|()[\]{}"'.,:;!?/\\-]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function phraseHit(corpus, phrase) {
  return normalize(corpus).includes(normalize(phrase));
}

function checkGroups(corpus, groups, label, missingKind) {
  for (const group of groups || []) {
    const hits = (group.any || []).filter((phrase) => phraseHit(corpus, phrase));
    if (hits.length === 0) {
      fail(`${missingKind}: ${label} missing one of [${(group.any || []).join(" | ")}]`);
    }
  }
}

function joinFiles(files, source) {
  const chunks = [];
  for (const rel of files) {
    const text = source(rel);
    if (text !== null && text !== undefined) {
      chunks.push(`\n--- ${rel} ---\n${text}`);
    }
  }
  return chunks.join("\n");
}

function unique(values) {
  return [...new Set(values)];
}

function evalText(caseItem) {
  return `${caseItem.prompt || ""}\n${caseItem.expectation || ""}`;
}

const failures = [];
const contract = readJson(contractPath);
const evals = readJson(evalPath);

if (contract.schema_version !== 1) {
  fail("contract schema_version must be 1");
}
if (contract.skill !== "unity-agent-workflows") {
  fail("contract skill must be unity-agent-workflows");
}
if (evals.skill !== "unity-agent-workflows") {
  fail("evals skill must be unity-agent-workflows");
}

const candidateDocs = contract.docs && contract.docs.candidate;
if (!Array.isArray(candidateDocs) || candidateDocs.length === 0) {
  fail("contract docs.candidate must list current skill docs");
}

for (const rel of candidateDocs || []) {
  if (!fs.existsSync(path.join(root, rel))) {
    fail(`candidate doc missing: ${rel}`);
  }
}

const candidateCorpus = joinFiles(candidateDocs || [], readFile);
const baselineDocs = (contract.docs && contract.docs.baseline) || candidateDocs || [];
const baselineAvailable = [];
const baselineCorpus = joinFiles(baselineDocs, (rel) => {
  const text = gitShow(rel);
  if (text !== null) {
    baselineAvailable.push(rel);
  }
  return text;
});

if (baselineAvailable.length === 0) {
  fail("baseline unavailable: git show HEAD:<path> returned no docs");
}

for (const rel of contract.required_references || []) {
  const abs = path.join(root, rel);
  if (!fs.existsSync(abs)) {
    fail(`missing required reference: ${rel}`);
    continue;
  }
  if (!phraseHit(candidateCorpus, rel)) {
    fail(`missing required reference route: ${rel}`);
  }
}

for (const concept of contract.concepts || []) {
  const label = concept.id || concept.label || "unnamed concept";
  checkGroups(candidateCorpus, concept.groups, label, "candidate concept missing");
  if (baselineCorpus) {
    checkGroups(baselineCorpus, concept.groups, label, "baseline concept missing");
  }
}

const cases = evals.cases;
if (!Array.isArray(cases) || cases.length === 0) {
  fail("evals cases must be a non-empty array");
}

const caseIds = new Set();
let positiveCount = 0;
let negativeCount = 0;
for (const item of cases || []) {
  for (const key of ["id", "prompt", "expected_skill", "expectation"]) {
    if (!(key in item)) {
      fail(`eval case missing ${key}: ${item.id || "<unknown>"}`);
    }
  }
  if (caseIds.has(item.id)) {
    fail(`duplicate eval case id: ${item.id}`);
  }
  caseIds.add(item.id);
  if (item.expected_skill === true) positiveCount += 1;
  if (item.expected_skill === false) negativeCount += 1;
}
if (positiveCount === 0) fail("evals missing expected_skill true cases");
if (negativeCount === 0) fail("evals missing expected_skill false cases");

for (const requiredId of contract.required_eval_case_ids || []) {
  if (!caseIds.has(requiredId)) {
    fail(`missing prompt coverage eval case: ${requiredId}`);
  }
}

const coverage = contract.prompt_coverage || {};
for (const item of cases || []) {
  if (item.expected_skill !== true) continue;
  const rule = coverage[item.id];
  if (!rule) {
    fail(`missing prompt coverage rule: ${item.id}`);
    continue;
  }
  const text = evalText(item);
  checkGroups(text, rule.eval_groups, `eval file ${item.id}`, "missing prompt coverage");
  checkGroups(candidateCorpus, rule.doc_groups, `docs for ${item.id}`, "missing prompt coverage");
}

const negativeText = (cases || [])
  .filter((item) => item.expected_skill === false)
  .map((item) => JSON.stringify(item))
  .join("\n");
for (const phrase of contract.required_negative_eval_text || []) {
  if (!phraseHit(negativeText, phrase)) {
    fail(`negative eval over-trigger text missing from eval file: ${phrase}`);
  }
}

const docPathMentions = unique(
  (candidateCorpus.match(/references\/[-a-z0-9]+\.md/g) || []).sort()
);
for (const rel of docPathMentions) {
  if (!fs.existsSync(path.join(root, rel))) {
    fail(`candidate docs reference missing file: ${rel}`);
  }
}

if (failures.length > 0) {
  console.error("skill semantic check failed");
  for (const message of failures) {
    console.error(`- ${message}`);
  }
  process.exit(1);
}

console.log(
  `skill semantic check ok: ${contract.concepts.length} concepts, ${positiveCount} positive evals, ${negativeCount} negative evals, ${baselineAvailable.length} baseline docs`
);
