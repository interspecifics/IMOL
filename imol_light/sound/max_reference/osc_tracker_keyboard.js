// osc_tracker_keyboard.js
// In: oscparse lists (track/vel/system)
// Out: list of 83 floats (mc.list~ @chans 83) + debug

inlets = 1;
outlets = 2;
autowatch = 1;

var g_N = 83;
var g_gain = 1.0;
var g_velGain = 0.35;
var g_spread = 0.0;
var g_decay = 0.92;
var g_floor = 0.0005;
var g_maxHz = 30.0;
var g_minOutIntervalMs = 30;
var g_useYForAmp = 1;

var g_tickMs = 33;
var g_task = null;

var g_amps = [];
var g_dirty = 0;
var g_lastOutMs = 0;

var g_velValue = 0.0;
var g_systemState = 1.0;

var g_slot = {};
var g_slotLetters = "ABCDEF";

// -------------------- Helpers --------------------
function _clamp01(x) {
  if (x < 0) return 0.0;
  if (x > 1) return 1.0;
  return x;
}

function _nowMs() {
  // Date.now exists in V8; fallback to new Date().getTime().
  return (Date.now ? Date.now() : (new Date()).getTime());
}

function _ensureArrays() {
  if (!g_amps || g_amps.length !== g_N) {
    g_amps = [];
    for (var i = 0; i < g_N; i++) g_amps[i] = 0.0;
  }
}

function _gauss(d, sigma) {
  // exp(-(d^2)/(2*sigma^2))
  if (sigma <= 0) return (d === 0 ? 1.0 : 0.0);
  var s2 = sigma * sigma;
  return Math.exp(-(d * d) / (2.0 * s2));
}

function _tick() {
  _ensureArrays();
  var changed = 0;

  // decay
  for (var i = 0; i < g_N; i++) {
    var v = g_amps[i] * g_decay;
    if (v < g_floor) v = 0.0;
    if (v !== g_amps[i]) {
      g_amps[i] = v;
      changed = 1;
    }
  }

  if (changed) g_dirty = 1;
  _maybeOutput();
}

function _maybeOutput(force) {
  if (!force && !g_dirty) return;

  var now = _nowMs();
  if (!force && (now - g_lastOutMs) < g_minOutIntervalMs) return;
  g_lastOutMs = now;

  // output list of floats
  outlet(0, g_amps);
  g_dirty = 0;
}

function _noteToIndex(xNorm) {
  // xNorm 0..1 -> 0..N-1
  var ix = Math.round(_clamp01(xNorm) * (g_N - 1));
  if (ix < 0) ix = 0;
  if (ix > (g_N - 1)) ix = g_N - 1;
  return ix;
}

function _applyKey(ix, strength) {
  _ensureArrays();
  strength = _clamp01(strength);
  if (strength <= 0) return;

  // Spread energy into neighbor bins.
  if (g_spread <= 0.0) {
    if (strength > g_amps[ix]) {
      g_amps[ix] = strength;
      g_dirty = 1;
    }
    return;
  }

  // Only touch a small neighborhood to keep it light.
  var radius = Math.max(1, Math.floor(g_spread * 3.0));
  var start = Math.max(0, ix - radius);
  var end = Math.min(g_N - 1, ix + radius);
  for (var j = start; j <= end; j++) {
    var w = _gauss(j - ix, g_spread);
    var v = strength * w;
    if (v > g_amps[j]) {
      g_amps[j] = v;
      g_dirty = 1;
    }
  }
}

function _handleParsedMessage(arr) {
  if (!arr || arr.length === 0) return;

  var a0 = String(arr[0]);

  // track A i x y w h area vx vy
  if (a0 === "track" && arr.length >= 10) {
    var letter = String(arr[1]);
    var x = parseFloat(arr[3]);
    var y = parseFloat(arr[4]);
    var area = parseFloat(arr[7]);
    var vx = parseFloat(arr[8]);
    var vy = parseFloat(arr[9]);

    if (isNaN(x)) x = 0.0;
    if (isNaN(y)) y = 0.0;
    if (isNaN(area)) area = 0.0;
    if (isNaN(vx)) vx = 0.0;
    if (isNaN(vy)) vy = 0.0;

    // store
    g_slot[letter] = { x: x, y: y, area: area, vx: vx, vy: vy, t: _nowMs() };

    // map to a "key press"
    var ix = _noteToIndex(x);
    var baseAmp = g_useYForAmp ? (1.0 - _clamp01(y)) : 1.0;
    var motion = Math.sqrt((vx * vx) + (vy * vy)); // normalized-ish (depends on sender)
    var strength = (baseAmp * g_gain) + (motion * g_velGain);

    // Optional: use /vel/value as an overall macro gain (acts like "expression pedal")
    strength *= (0.25 + 0.75 * _clamp01(g_velValue));

    // Optional: use area as extra pressure (area is often stable; keep subtle)
    strength *= (0.75 + 0.25 * _clamp01(area));

    _applyKey(ix, strength);
    _maybeOutput(false);
    return;
  }

  // vel value v
  if (a0 === "vel" && arr.length >= 3 && String(arr[1]) === "value") {
    var vv = parseFloat(arr[2]);
    if (isNaN(vv)) vv = 0.0;
    g_velValue = _clamp01(vv);
    return;
  }

  // system state s
  if (a0 === "system" && arr.length >= 3 && String(arr[1]) === "state") {
    var ss = parseFloat(arr[2]);
    if (isNaN(ss)) ss = 1.0;
    g_systemState = ss;
    return;
  }
}

// -------------------- Max entry points --------------------
function loadbang() {
  _ensureArrays();
  _recalcTick();
  if (g_task === null) {
    g_task = new Task(_tick, this);
  }
  g_task.interval = g_tickMs;
  g_task.repeat();
  outlet(1, ["ready", "N", g_N, "tickMs", g_tickMs]);
}

function bang() {
  _maybeOutput(true);
}

function list() {
  var arr = [];
  for (var i = 0; i < arguments.length; i++) arr.push(arguments[i]);
  _handleParsedMessage(arr);
}

function anything() {
  var arr = [messagename];
  for (var i = 0; i < arguments.length; i++) arr.push(arguments[i]);
  _handleParsedMessage(arr);
}

// -------------------- Commands --------------------
function _recalcTick() {
  var hz = parseFloat(g_maxHz);
  if (isNaN(hz) || hz <= 0) hz = 30.0;
  g_maxHz = hz;
  g_tickMs = Math.max(10, Math.floor(1000.0 / g_maxHz));
}

function setn(n) {
  var nn = parseInt(n, 10);
  if (isNaN(nn) || nn < 1) return;
  g_N = nn;
  _ensureArrays();
  g_dirty = 1;
  outlet(1, ["setn", g_N]);
}

function setgain(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_gain = x;
  outlet(1, ["setgain", g_gain]);
}

function setvelgain(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_velGain = x;
  outlet(1, ["setvelgain", g_velGain]);
}

function setspread(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_spread = Math.max(0.0, x);
  outlet(1, ["setspread", g_spread]);
}

function setdecay(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_decay = Math.max(0.0, Math.min(1.0, x));
  outlet(1, ["setdecay", g_decay]);
}

function setrate(hz) {
  g_maxHz = parseFloat(hz);
  _recalcTick();
  if (g_task !== null) g_task.interval = g_tickMs;
  outlet(1, ["setrate_hz", g_maxHz, "tickMs", g_tickMs]);
}

function setoutthrottle(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_minOutIntervalMs = Math.max(0, x);
  outlet(1, ["setoutthrottle_ms", g_minOutIntervalMs]);
}

function setyamp(v) {
  g_useYForAmp = (parseInt(v, 10) ? 1 : 0);
  outlet(1, ["setyamp", g_useYForAmp]);
}

function clear() {
  _ensureArrays();
  for (var i = 0; i < g_N; i++) g_amps[i] = 0.0;
  g_dirty = 1;
  _maybeOutput(true);
  outlet(1, ["clear"]);
}

function start() {
  if (g_task === null) g_task = new Task(_tick, this);
  g_task.interval = g_tickMs;
  g_task.repeat();
  outlet(1, ["start", "tickMs", g_tickMs]);
}

function stop() {
  if (g_task !== null) g_task.cancel();
  outlet(1, ["stop"]);
}

function status() {
  outlet(1, ["status",
    "N", g_N,
    "gain", g_gain,
    "velGain", g_velGain,
    "spread", g_spread,
    "decay", g_decay,
    "tickMs", g_tickMs,
    "outThrottleMs", g_minOutIntervalMs,
    "velValue", g_velValue,
    "systemState", g_systemState
  ]);
}


