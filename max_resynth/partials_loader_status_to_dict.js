// partials_loader_status_to_dict.js
// In: status messages from partials_bank_to_coll.js (outlet 1)
// Out: bang + Dict "partials_loader_status" (for dict.view)

inlets = 1;
outlets = 2;
autowatch = 1;

var DICT_NAME = "partials_loader_status";
var D = new Dict(DICT_NAME);

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

function _commit(eventName) {
  _setKV("event", String(eventName || ""));
  _setKV("updated_ms", _nowMs());
  outlet(0, "bang");
}

function clear() {
  D.clear();
  _setKV("dict", DICT_NAME);
  _commit("clear");
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

  if (t0 === "files" && tokens.length >= 2) {
    _setKV("filesCount", parseInt(tokens[1], 10) || 0);
    _commit("files");
    return;
  }

  if ((t0 === "jump" || t0 === "ingest" || t0 === "loaded") && tokens.length >= 2) {
    var path = String(tokens[1]);
    _setKV("path", path);
    _setKV("file", _basename(path));
    _setFromKV(tokens, 2);
    if (t0 === "loaded") {
      _setKV("progressTag", "loaded");
      _setKV("progressFrac", 1.0);
    }
    _commit(t0);
    return;
  }

  if (t0 === "progress" && tokens.length >= 3) {
    _setKV("progressTag", String(tokens[1]));
    _setKV("progressFrac", parseFloat(tokens[2]) || 0.0);
    // optional extras: ... key, value ...
    if (tokens.length >= 8) _setKV("progressExtraA", String(tokens[6]) + " " + String(tokens[7]));
    if (tokens.length >= 10) _setKV("progressExtraB", String(tokens[8]) + " " + String(tokens[9]));
    _commit("progress");
    return;
  }

  if (t0 === "mode" && tokens.length >= 2) {
    _setKV("mode", String(tokens[1]));
    _commit("mode");
    return;
  }

  if (t0 === "error") {
    _setKV("error", tokens.slice(1).join(" "));
    _commit("error");
    return;
  }

  // Unknown messages: store raw for inspection
  _setKV("raw", tokens);
  _commit("raw");
  outlet(1, ["unknown"].concat(tokens));
}

function loadbang() {
  clear();
  outlet(1, ["ready", DICT_NAME]);
}


