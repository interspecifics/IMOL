// osc_to_jitter_notes.js
// In0: oscparse lists OR raw float (/system/state)
// In1: list of 83 floats from jit.spill
// Out0: offset, Out1: scale, Out2: debug

inlets = 2;
outlets = 3;
autowatch = 1;

var g_N = 83;

var g_hold_ms = 80;
var g_debounce_ms = 120;

var g_random_sustain = 1;
var g_random_delay = 1;
var g_sustain_set_ms = [90, 120, 160, 190, 280];
var g_delay_set_ms = [0, 8, 16, 32, 64];

var g_offset_min = -100.0;
var g_offset_max = 100.0;
var g_scale_min = -50.0;
var g_scale_max = 0.0;

var g_avail_threshold = 0.01;
var g_pick_mode = "random";
var g_top_k = 12;

var g_vel_value = 0.0;
var g_use_vel_value = 1;

var g_system_trigger_enabled = 1;
var g_system_trigger_mode = "delta";
var g_system_delta = 0.12;
var g_last_system_state = null;
var g_last_system_int = null;

var g_last_trigger_ms = 0;
var g_avail = [];
var g_avail_weights = [];
var g_last_list_ms = 0;

var g_releaseTask = null;
var g_attackTask = null;
var g_pending_offset = 0.0;
var g_pending_scale = 0.0;
var g_pending_hold_ms = 0;

// -------------------- Helpers --------------------
function _nowMs() {
  return (Date.now ? Date.now() : (new Date()).getTime());
}

function _clamp(x, a, b) {
  if (x < a) return a;
  if (x > b) return b;
  return x;
}

function _clamp01(x) {
  return _clamp(x, 0.0, 1.0);
}

function _map01(x, a, b) {
  return a + (b - a) * _clamp01(x);
}

function _rebuildAvailableFromList(list83) {
  g_avail = [];
  g_avail_weights = [];

  var n = Math.min(g_N, list83.length);
  for (var i = 0; i < n; i++) {
    var v = parseFloat(list83[i]);
    if (isNaN(v)) v = 0.0;
    if (v > g_avail_threshold) {
      g_avail.push(i);
      g_avail_weights.push(v);
    }
  }
  g_last_list_ms = _nowMs();
}

function _pickIndex() {
  if (!g_avail || g_avail.length === 0) {
    // fallback: any bin
    return Math.floor(Math.random() * g_N);
  }

  if (g_pick_mode === "top") {
    // pick from the top K by weight
    var pairs = [];
    for (var i = 0; i < g_avail.length; i++) {
      pairs.push([g_avail[i], g_avail_weights[i]]);
    }
    pairs.sort(function(a, b) { return b[1] - a[1]; });
    var k = Math.max(1, Math.min(g_top_k, pairs.length));
    var j = Math.floor(Math.random() * k);
    return pairs[j][0];
  }

  // random among available
  var r = Math.floor(Math.random() * g_avail.length);
  return g_avail[r];
}

function _pickFromSet(arr, fallback) {
  if (!arr || arr.length === 0) return fallback;
  var i = Math.floor(Math.random() * arr.length);
  var v = parseInt(arr[i], 10);
  if (isNaN(v)) return fallback;
  return v;
}

function _triggerNote() {
  var now = _nowMs();
  if ((now - g_last_trigger_ms) < g_debounce_ms) return;
  g_last_trigger_ms = now;

  var idx = _pickIndex(); // 0..82
  var x01 = (g_N <= 1) ? 0.0 : (idx / (g_N - 1));

  // offset picks which "zone" in the noise field we sample (note selection)
  var offsetVal = _map01(x01, g_offset_min, g_offset_max);

  // scale is the "note pressure"
  var inten = g_use_vel_value ? _clamp01(g_vel_value) : 1.0;
  var scaleVal = _map01(inten, g_scale_min, g_scale_max);

  // Pick sustain + attack delay for this note
  var hold_ms = g_random_sustain ? _pickFromSet(g_sustain_set_ms, g_hold_ms) : g_hold_ms;
  hold_ms = Math.max(1, parseInt(hold_ms, 10));
  var delay_ms = g_random_delay ? _pickFromSet(g_delay_set_ms, 0) : 0;
  delay_ms = Math.max(0, parseInt(delay_ms, 10));

  // Store pending values for delayed attack
  g_pending_offset = offsetVal;
  g_pending_scale = scaleVal;
  g_pending_hold_ms = hold_ms;

  // Cancel any existing scheduled attack/release (monophonic behavior)
  if (g_attackTask === null) {
    g_attackTask = new Task(_attack, this);
  } else {
    g_attackTask.cancel();
  }
  if (g_releaseTask === null) {
    g_releaseTask = new Task(_release, this);
  } else {
    g_releaseTask.cancel();
  }

  if (delay_ms <= 0) {
    _attack();
  } else {
    g_attackTask.interval = delay_ms;
    g_attackTask.repeat(1);
  }

  outlet(2, ["note_sched", "idx", idx, "delay_ms", delay_ms, "hold_ms", hold_ms, "avail", g_avail.length]);
}

function _attack() {
  // Emit pulses (note-on)
  outlet(0, g_pending_offset);
  outlet(1, g_pending_scale);
  outlet(2, ["note_on", "offset", g_pending_offset, "scale", g_pending_scale]);

  // Schedule release to 0
  if (g_releaseTask === null) {
    g_releaseTask = new Task(_release, this);
  } else {
    g_releaseTask.cancel();
  }
  g_releaseTask.interval = Math.max(1, parseInt(g_pending_hold_ms, 10));
  g_releaseTask.repeat(1);
}

function _release() {
  outlet(0, 0.0);
  outlet(1, 0.0);
  outlet(2, ["note_off"]);
}

function _handleOscParsed(arr) {
  if (!arr || arr.length < 1) return;
  var a0 = String(arr[0]);

  // /vel/value v  ->  vel value v
  if (a0 === "vel" && arr.length >= 3 && String(arr[1]) === "value") {
    var vv = parseFloat(arr[2]);
    if (isNaN(vv)) vv = 0.0;
    g_vel_value = _clamp01(vv);
    return;
  }

  // /state/N 1  -> state N 1
  if (a0 === "state" && arr.length >= 3) {
    var v = parseFloat(arr[2]);
    if (!isNaN(v) && v >= 0.5) {
      _triggerNote();
    }
    return;
  }

  // Optional: also accept /system/state when using oscparse:
  //   /system/state 4.2  -> system state 4.2
  if (a0 === "system" && arr.length >= 3 && String(arr[1]) === "state") {
    _handleSystemStateFloat(arr[2]);
    return;
  }
}

function _handleSystemStateFloat(ss) {
  var v = parseFloat(ss);
  if (isNaN(v)) v = 0.0;

  // If /vel/value is not wired, use fractional part of system/state as a 0..1 intensity source.
  // This keeps the patch playable even with only /system/state available.
  var frac = v % 1.0;
  if (frac < 0) frac += 1.0;
  g_vel_value = _clamp01(frac);

  if (!g_system_trigger_enabled) {
    g_last_system_state = v;
    g_last_system_int = Math.floor(v);
    return;
  }

  if (g_last_system_state === null) {
    g_last_system_state = v;
    g_last_system_int = Math.floor(v);
    return;
  }

  if (g_system_trigger_mode === "delta") {
    if (Math.abs(v - g_last_system_state) >= g_system_delta) {
      _triggerNote();
      g_last_system_state = v;
      g_last_system_int = Math.floor(v);
      return;
    }
  } else {
    // default: "int"
    var iv = Math.floor(v);
    if (g_last_system_int === null) g_last_system_int = iv;
    if (iv !== g_last_system_int) {
      _triggerNote();
      g_last_system_int = iv;
      g_last_system_state = v;
      return;
    }
  }

  g_last_system_state = v;
}

// -------------------- Max entry points --------------------
function loadbang() {
  outlet(2, ["ready", "N", g_N]);
}

function bang() {
  _triggerNote();
}

function list() {
  var arr = [];
  for (var i = 0; i < arguments.length; i++) arr.push(arguments[i]);

  if (inlet === 1) {
    // available list from jit.spill
    _rebuildAvailableFromList(arr);
    return;
  }

  // oscparse output list
  _handleOscParsed(arr);
}

function anything() {
  var arr = [messagename];
  for (var i = 0; i < arguments.length; i++) arr.push(arguments[i]);

  if (inlet === 1) {
    // some objects may send "list" as anything; still treat as list
    _rebuildAvailableFromList(arr);
    return;
  }

  _handleOscParsed(arr);
}

// For wiring like:
//   [udpreceive 9001] -> [route /system/state] -> [unpack f] -> [js osc_to_jitter_notes.js]
// Max will send a float directly (no OSC address). Handle that here.
function msg_float(v) {
  if (inlet === 1) return; // inlet 1 is reserved for the 83-float jit.spill list
  _handleSystemStateFloat(v);
}

// -------------------- Commands (tuning) --------------------
function sethold(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_hold_ms = Math.max(1, x);
  outlet(2, ["sethold_ms", g_hold_ms]);
}

function setdebounce(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_debounce_ms = Math.max(0, x);
  outlet(2, ["setdebounce_ms", g_debounce_ms]);
}

function setoffset(minv, maxv) {
  var a = parseFloat(minv);
  var b = parseFloat(maxv);
  if (isNaN(a) || isNaN(b)) return;
  g_offset_min = a;
  g_offset_max = b;
  outlet(2, ["setoffset", g_offset_min, g_offset_max]);
}

function setscale(minv, maxv) {
  var a = parseFloat(minv);
  var b = parseFloat(maxv);
  if (isNaN(a) || isNaN(b)) return;
  g_scale_min = a;
  g_scale_max = b;
  outlet(2, ["setscale", g_scale_min, g_scale_max]);
}

function setthreshold(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_avail_threshold = Math.max(0.0, x);
  outlet(2, ["setthreshold", g_avail_threshold]);
}

function setpickmode(m) {
  var s = String(m || "").toLowerCase();
  if (s !== "random" && s !== "top") return;
  g_pick_mode = s;
  outlet(2, ["setpickmode", g_pick_mode]);
}

function settopk(k) {
  var x = parseInt(k, 10);
  if (isNaN(x)) return;
  g_top_k = Math.max(1, x);
  outlet(2, ["settopk", g_top_k]);
}

function usevel(v) {
  g_use_vel_value = (parseInt(v, 10) ? 1 : 0);
  outlet(2, ["usevel", g_use_vel_value]);
}

function setrandomsustain(v) {
  g_random_sustain = (parseInt(v, 10) ? 1 : 0);
  outlet(2, ["setrandomsustain", g_random_sustain]);
}

function setrandomdelay(v) {
  g_random_delay = (parseInt(v, 10) ? 1 : 0);
  outlet(2, ["setrandomdelay", g_random_delay]);
}

function setsustainset(a, b, c, d, e) {
  // expects 5 ints in ms; ignores non-numeric
  var arr = [];
  var xs = [a, b, c, d, e];
  for (var i = 0; i < xs.length; i++) {
    var v = parseInt(xs[i], 10);
    if (!isNaN(v)) arr.push(Math.max(1, v));
  }
  if (arr.length >= 1) g_sustain_set_ms = arr;
  outlet(2, ["setsustainset_ms"].concat(g_sustain_set_ms));
}

function setdelayset(a, b, c, d, e) {
  var arr = [];
  var xs = [a, b, c, d, e];
  for (var i = 0; i < xs.length; i++) {
    var v = parseInt(xs[i], 10);
    if (!isNaN(v)) arr.push(Math.max(0, v));
  }
  if (arr.length >= 1) g_delay_set_ms = arr;
  outlet(2, ["setdelayset_ms"].concat(g_delay_set_ms));
}

function setsystemtrigger(v) {
  g_system_trigger_enabled = (parseInt(v, 10) ? 1 : 0);
  outlet(2, ["setsystemtrigger", g_system_trigger_enabled]);
}

function setsystemmode(m) {
  var s = String(m || "").toLowerCase();
  if (s !== "int" && s !== "delta") return;
  g_system_trigger_mode = s;
  outlet(2, ["setsystemmode", g_system_trigger_mode]);
}

function setsystemdelta(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_system_delta = Math.max(0.0, x);
  outlet(2, ["setsystemdelta", g_system_delta]);
}

function status() {
  outlet(2, ["status",
    "N", g_N,
    "avail", (g_avail ? g_avail.length : 0),
    "threshold", g_avail_threshold,
    "hold_ms", g_hold_ms,
    "debounce_ms", g_debounce_ms,
    "random_sustain", g_random_sustain,
    "sustain_set_ms", g_sustain_set_ms,
    "random_delay", g_random_delay,
    "delay_set_ms", g_delay_set_ms,
    "offset", g_offset_min, g_offset_max,
    "scale", g_scale_min, g_scale_max,
    "pick", g_pick_mode,
    "top_k", g_top_k,
    "vel_value", g_vel_value,
    "use_vel", g_use_vel_value,
    "system_trigger", g_system_trigger_enabled,
    "system_mode", g_system_trigger_mode,
    "system_delta", g_system_delta
  ]);
}

function clear() {
  g_avail = [];
  g_avail_weights = [];
  g_vel_value = 0.0;
  _release();
  outlet(2, ["clear"]);
}


