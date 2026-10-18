import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { resolve, join } from "node:path";
import { pathToFileURL, fileURLToPath } from "node:url";
import { afterEach, beforeEach, test } from "node:test";

const root = fileURLToPath(new URL("../", import.meta.url));
const globalModules = execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim();
const piRoot = join(globalModules, "@earendil-works/pi-coding-agent");
const requirePi = createRequire(join(piRoot, "package.json"));
const extension = resolve(root, "dot_pi/private_extensions/jev-review.ts");
const { loadExtensions } = await import(pathToFileURL(join(piRoot, "dist/core/extensions/loader.js")));
const loaded = await loadExtensions([extension], root);
assert.deepEqual(loaded.errors, [], "Pi must load the extension without errors");
const tool = loaded.extensions[0].tools.get("jev_review").definition;

const input = {
  objective: "Preserve cancellation behavior while moving the billing check.",
  scope: "billing.ts:1–3",
  evidence: [{ source: "billing.ts:1–3", content: "if (account.cancelled) return; charge(account);" }],
  questions: [{
    id: "cancellation", question: "Does the supplied path skip charging cancelled accounts?",
    yes: "The path returns before charge for cancelled accounts.",
    no: "The path calls charge for cancelled accounts.",
  }],
};
const answer = {
  type: "choice", choice: "yes",
  probabilities: { yes: 0.9, no: 0.05, insufficient_evidence: 0.05 }, confidence: 0.8,
};
const response = () => ({
  model: "jev-1.13.0", answers: { cancellation: structuredClone(answer) },
  usage: { input_tokens: 120, output_tokens: 20 },
});
const execute = (args = input, signal) => tool.execute("test", args, signal, undefined, {});
const originalFetch = globalThis.fetch;
const originalKey = process.env.TYPESAFE_API_KEY;
const originalModel = process.env.JEV_MODEL;
beforeEach(() => {
  process.env.TYPESAFE_API_KEY = "test-key-not-a-secret";
  delete process.env.JEV_MODEL;
  globalThis.fetch = () => { throw new Error("Unexpected network request"); };
});
afterEach(() => {
  globalThis.fetch = originalFetch;
  if (originalKey === undefined) delete process.env.TYPESAFE_API_KEY;
  else process.env.TYPESAFE_API_KEY = originalKey;
  if (originalModel === undefined) delete process.env.JEV_MODEL;
  else process.env.JEV_MODEL = originalModel;
});

test("matches installed Pi types without adding project dependencies", () => {
  const ts = createRequire(join(globalModules, "typescript/package.json"))("typescript");
  const config = ts.convertCompilerOptionsFromJson({
    noEmit: true, strict: true, skipLibCheck: true, target: "ES2023",
    module: "ESNext", moduleResolution: "Bundler",
    paths: {
      "@earendil-works/pi-coding-agent": [join(piRoot, "dist/index.d.ts")],
      "@earendil-works/pi-ai": [join(piRoot, "node_modules/@earendil-works/pi-ai/dist/index.d.ts")],
      "typebox/value": [requirePi.resolve("typebox/value").replace(/\.mjs$/, ".d.mts")],
    },
    typeRoots: [join(piRoot, "node_modules/@types")],
  }, root);
  const program = ts.createProgram([extension], config.options);
  const diagnostics = [...config.errors, ...ts.getPreEmitDiagnostics(program)];
  assert.equal(diagnostics.length, 0, ts.formatDiagnosticsWithColorAndContext(diagnostics, {
    getCurrentDirectory: () => root, getCanonicalFileName: (f) => f, getNewLine: () => "\n",
  }));
});

test("sends only the selected evidence, criteria and pinned model; preserves advisory results", async () => {
  let calls = 0;
  globalThis.fetch = async (url, options) => {
    calls++;
    assert.equal(url, "https://api.typesafe.ai/v1/systemone");
    assert.equal(options.method, "POST");
    assert.equal(options.redirect, "error");
    assert.equal(options.headers.Authorization, "Bearer test-key-not-a-secret");
    const packet = JSON.parse(options.body);
    assert.equal(packet.model, "jev-1.13.0");
    assert.deepEqual(packet.state, { objective: input.objective, scope: input.scope, evidence: input.evidence });
    assert.deepEqual(Object.keys(packet.questions), ["cancellation"]);
    assert.equal(packet.questions.cancellation.criteria.yes, input.questions[0].yes);
    assert.ok(packet.questions.cancellation.criteria.insufficient_evidence);
    const data = response();
    data.debug = "private response metadata";
    data.answers.cancellation.debug = "private answer metadata";
    return Response.json(data);
  };
  const result = await execute();
  assert.equal(calls, 1);
  assert.equal(result.details.status, "evaluated");
  assert.equal(result.details.advisory, true);
  assert.deepEqual(result.details.answers.cancellation, answer);
  assert.ok(result.details.elapsed_ms >= 0);
  assert.doesNotMatch(JSON.stringify(result), /private .*metadata|test-key-not-a-secret/);
});

test("preserves insufficient evidence and low confidence without granting a pass", async () => {
  globalThis.fetch = async () => {
    const data = response();
    data.answers.cancellation = {
      type: "choice", choice: "insufficient_evidence", confidence: 0.01,
      probabilities: { yes: 0.33, no: 0.33, insufficient_evidence: 0.34 },
    };
    return Response.json(data);
  };
  const result = (await execute()).details;
  assert.equal(result.status, "evaluated");
  assert.equal(result.answers.cancellation.choice, "insufficient_evidence");
  assert.equal(result.answers.cancellation.confidence, 0.01);
  assert.equal(result.advisory, true);
});

test("supports an operator-selected model and batches independent questions", async () => {
  process.env.JEV_MODEL = "jev-1.14.0";
  globalThis.fetch = async (_url, options) => {
    const packet = JSON.parse(options.body);
    assert.equal(packet.model, "jev-1.14.0");
    assert.deepEqual(Object.keys(packet.questions), ["cancellation", "another_check"]);
    const data = response();
    data.model = "jev-1.14.0";
    data.answers.another_check = answer;
    return Response.json(data);
  };
  const args = structuredClone(input);
  args.questions.push({ ...args.questions[0], id: "another_check" });
  assert.equal((await execute(args)).details.model, "jev-1.14.0");
});

test("missing configuration, duplicate IDs, empty evidence and oversize input do not send requests", async () => {
  let calls = 0;
  globalThis.fetch = async () => { calls++; return Response.json(response()); };
  delete process.env.TYPESAFE_API_KEY;
  assert.equal((await execute()).details.reason, "not_configured");
  process.env.TYPESAFE_API_KEY = "test-key-not-a-secret";
  assert.equal((await execute({ ...input, questions: [...input.questions, ...input.questions] })).details.reason, "invalid_input");
  assert.equal((await execute({ ...input, evidence: [] })).details.reason, "invalid_input");
  assert.equal((await execute({ ...input, evidence: [{ ...input.evidence[0], extra: "unselected data" }] })).details.reason, "invalid_input");
  assert.equal((await execute({ ...input, objective: " " })).details.reason, "invalid_input");
  assert.equal((await execute({ ...input, scope: "大".repeat(30_000) })).details.reason, "input_too_large");
  assert.equal(calls, 0);
});

test("rejects malformed, incomplete and inconsistent API results", async () => {
  const mutations = [
    (data) => { delete data.answers.cancellation; },
    (data) => { data.answers.unexpected = answer; },
    (data) => { data.answers.cancellation.choice = "allow"; },
    (data) => { data.answers.cancellation.type = "noul"; },
    (data) => { data.answers.cancellation.confidence = 1.1; },
    (data) => { data.answers.cancellation.probabilities.yes = 0.2; },
    (data) => { data.answers.cancellation.choice = "no"; },
    (data) => { delete data.usage; },
  ];
  for (const mutate of mutations) {
    const data = response();
    mutate(data);
    globalThis.fetch = async () => Response.json(data);
    assert.equal((await execute()).details.reason, "invalid_response");
  }
});

test("HTTP and network errors stay unavailable, do not leak service text and are not retried", async () => {
  for (const status of [401, 429, 500, 529]) {
    let calls = 0;
    globalThis.fetch = async () => { calls++; return new Response("sensitive service diagnostic", { status }); };
    const result = await execute();
    assert.equal(result.details.status, "unavailable");
    assert.equal(result.details.reason, "http_error");
    assert.doesNotMatch(JSON.stringify(result), /sensitive service diagnostic/);
    assert.equal(calls, 1);
  }
  globalThis.fetch = async () => { throw new Error("sensitive network diagnostic"); };
  assert.equal((await execute()).details.reason, "request_failed");
  globalThis.fetch = async () => new Response("not JSON");
  assert.equal((await execute()).details.reason, "request_failed");
});

test("cancellation prevents requests or cancels an in-flight request", async () => {
  assert.equal((await execute(input, AbortSignal.abort())).details.reason, "cancelled");
  const controller = new AbortController();
  globalThis.fetch = async (_url, options) => {
    controller.abort();
    options.signal.throwIfAborted();
  };
  assert.equal((await execute(input, controller.signal)).details.reason, "cancelled");
});

test("timeout is an unresolved review", async (t) => {
  t.mock.method(AbortSignal, "timeout", (ms) => {
    assert.equal(ms, 15_000);
    return AbortSignal.abort(new DOMException("Timed out", "TimeoutError"));
  });
  globalThis.fetch = async (_url, options) => options.signal.throwIfAborted();
  assert.equal((await execute()).details.reason, "timeout");
});
