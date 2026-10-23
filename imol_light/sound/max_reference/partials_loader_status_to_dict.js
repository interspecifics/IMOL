// partials_loader_status_to_dict.js
// In: status messages from partials_bank_to_coll.js (outlet 1)
// Out: bang + Dict "partials_loader_status" (for dict.view)

inlets = 1;
outlets = 2;
autowatch = 1;

var DICT_NAME = "partials_loader_status";
var D = new Dict(DICT_NAME);

// UI refresh throttling: dict.view can get heavy if we "bang" too often.
// Keep this conservative so Max stays responsive.
var g_commitMinIntervalMs = 900;
var g_lastCommitMs = 0;

// Minimal mode: ONLY track the few fields we need for performance + debugging.
// Goal: no blinking / no heavy redraws.
// Allowed events:
// - files (count)
// - jump/loaded (file)
// - autobank_step / autobank_end (progress through partials)
// - error
var g_minimal = 1;

// IMPORTANT: dict.view is relatively heavy and can appear to "blink" under load.
// By default we do NOT emit "bang" to drive dict.view refresh. Instead we emit a tiny
// UI status list on outlet 1 that is safe to display with number/message boxes.
var g_emitBang = 0;

function setbang(n) {
  g_emitBang = (parseInt(n, 10) ? 1 : 0);
  _setKV("emitBang", g_emitBang);
  _commit("setbang", 2);
}

function _nowMs() {
  return (Date.now ? Date.now() : (new Date()).getTime());
}

function _basename(p) {
  p = String(p || "");
  var parts = p.split(/[\/\\]/);
  return parts.length ? parts[parts.length - 1] : p;
}

function _setKV(k, v) {
  try {
    D.set(k, v);
  } catch (e) {
  }
}

function _setFromKV(tokens, startIdx) {
  for (var i = startIdx; i < tokens.length - 1; i += 2) {
    var k = String(tokens[i]);
    var v = tokens[i + 1];
    _setKV(k, v);
  }
}

function _setFromKVAllowlist(tokens, startIdx, allow) {
  for (var i = startIdx; i < tokens.length - 1; i += 2) {
    var k = String(tokens[i]);
    if (allow && !allow[k]) continue;
    var v = tokens[i + 1];
    _setKV(k, v);
  }
}

function _commit(eventName, force) {
  var now = _nowMs();
  // Even "force" commits must respect throttling, otherwise dict.view can flicker/stall.
  // Only errors will bypass by setting force=2.
  if (force !== 2 && g_commitMinIntervalMs > 0 && (now - g_lastCommitMs) < g_commitMinIntervalMs) return;
  g_lastCommitMs = now;
  _setKV("event", String(eventName || ""));
  _setKV("updated_ms", now);
  if (g_emitBang) outlet(0, "bang");
}

function clear() {
  D.clear();
  _setKV("dict", DICT_NAME);
  _commit("clear", 2);
}

function _emitUiStatus() {
  // Outlet 1: tiny status update (safe UI)
  // ui file <name> startPartial <n> partialsCount <n> bankSize <n> event <event>
  var file = D.get("file");
  var sp = D.get("startPartial");
  var pc = D.get("partialsCount");
  var bs = D.get("bankSize");
  var ev = D.get("event");
  outlet(1, ["ui", "file", file, "startPartial", sp, "partialsCount", pc, "bankSize", bs, "event", ev]);
}

function list() {
  var tokens = [];
  for (var i = 0; i < arguments.length; i++) tokens.push(arguments[i]);
  _handle(tokens);
}

function anything() {
  var tokens = [messagename];
  for (var i = 0; i < arguments.length; i++) tokens.push(arguments[i]);
  _handle(tokens);
}

function files() { var t = ["files"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }
function jump() { var t = ["jump"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }
function ingest() { var t = ["ingest"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }
function progress() { var t = ["progress"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }
function loaded() { var t = ["loaded"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }
function mode() { var t = ["mode"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }
function error() { var t = ["error"]; for (var i = 0; i < arguments.length; i++) t.push(arguments[i]); _handle(t); }

function _handle(tokens) {
  if (!tokens || tokens.length === 0) return;
  var t0 = String(tokens[0]);

  // Minimal mode: ignore everything except key events.
  if (g_minimal) {
    if (t0 !== "files" && t0 !== "jump" && t0 !== "loaded" && t0 !== "error" && t0 !== "autobank" && t0.indexOf("autobank_") !== 0) {
      return;
    }
  }

  if (t0 === "files" && tokens.length >= 2) {
    _setKV("filesCount", parseInt(tokens[1], 10) || 0);
    _commit("files", 1);
    _emitUiStatus();
    return;
  }

  if ((t0 === "jump" || t0 === "ingest" || t0 === "loaded") && tokens.length >= 2) {
    var path = String(tokens[1]);
    _setKV("path", path);
    _setKV("file", _basename(path));
    // Only keep the few fields we care about.
    var allow = {
      "mode": 1,
      "startPartial": 1,
      "bankSize": 1,
      "partialsCount": 1,
      "index": 1,
      "count": 1,
      "resample": 1,
      "format": 1
    };
    _setFromKVAllowlist(tokens, 2, allow);
    if (t0 === "loaded") {
      _setKV("progressTag", "loaded");
      _setKV("progressFrac", 1.0);
    }
    // Only refresh UI aggressively on "loaded". Jump/ingest can be frequent.
    _commit(t0, (t0 === "loaded") ? 1 : 0);
    if (t0 === "loaded") _emitUiStatus();
    return;
  }

  if (t0 === "progress" && tokens.length >= 3) {
    _setKV("progressTag", String(tokens[1]));
    _setKV("progressFrac", parseFloat(tokens[2]) || 0.0);
    // optional extras: ... key, value ...
    if (tokens.length >= 8) _setKV("progressExtraA", String(tokens[6]) + " " + String(tokens[7]));
    if (tokens.length >= 10) _setKV("progressExtraB", String(tokens[8]) + " " + String(tokens[9]));
    _commit("progress", false);
    return;
  }

  if (t0 === "mode" && tokens.length >= 2) {
    _setKV("mode", String(tokens[1]));
    _commit("mode", true);
    return;
  }

  if (t0 === "error") {
    _setKV("error", tokens.slice(1).join(" "));
    _commit("error", 2);
    _emitUiStatus();
    return;
  }

  // Autobank status (hands-free paging through partial banks)
  // Examples:
  // - ["autobank", 1, "mode", "timer", "intervalMs", 2500]
  // - ["autobank_step", "startPartial", 83, "bankSize", 83, "src", "timer"]
  // - ["autobank_end", ...]
  // - ["autobank_skip", ...]
  if (t0 === "autobank") {
    if (tokens.length >= 2) _setKV("autobankEnabled", parseInt(tokens[1], 10) || 0);
    var allow2 = { "mode": 1, "intervalMs": 1 };
    _setFromKVAllowlist(tokens, 2, allow2);
    _commit("autobank", 0);
    _emitUiStatus();
    return;
  }

  if (t0.indexOf("autobank_") === 0) {
    // Only keep the core paging facts.
    var allow3 = { "startPartial": 1, "bankSize": 1, "partialsCount": 1, "next": 1, "src": 1 };
    _setFromKVAllowlist(tokens, 1, allow3);
    // Don't redraw dict.view for every paging step; only redraw at throttle rate.
    // (The important refresh is on the subsequent "loaded".)
    _commit(t0, 0);
    // Still emit a tiny UI status update (safe)
    _emitUiStatus();
    return;
  }

  // Ignore everything else (keeps UI stable).
}

function loadbang() {
  clear();
  outlet(1, ["ready", DICT_NAME]);
}


