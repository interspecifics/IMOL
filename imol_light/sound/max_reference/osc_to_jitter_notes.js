// osc_to_jitter_notes.js
// In0: oscparse lists OR raw float (/system/state)
// In1: 83-float availability list (plain floats OR loader "avail ..." message)
// Out0/Out1: bank index values for your two float boxes, Out2: debug / control messages

inlets = 2;
outlets = 3;
autowatch = 1;

var g_N = 83;

var g_hold_ms = 900;
var g_debounce_ms = 60;

var g_random_sustain = 1;
var g_random_delay = 1;
// Longer sustains make the index-ranges "sit" long enough to be perceptible.
var g_sustain_set_ms = [1200, 1600, 2200, 3000, 4200];
var g_delay_set_ms = [0, 8, 16, 32];

// Occasional long sustains (seconds) to create rarer "held" notes
var g_long_sustain_enabled = 1;
var g_long_sustain_prob = 0.18; // 0..1 probability per note
var g_long_sustain_set_ms = [3000, 4500];

// (Removed) legacy offset/scale mapping ranges. We now output bank indices directly.

var g_avail_threshold = 0.0001;
// Pick modes:
// - random: uniform among available bins
// - top: random among top-K bins by weight
// - weighted: weighted random by avail amplitude
// - cycle: deterministic walk through available bins (sorted by weight desc)
var g_pick_mode = "cycle";
var g_top_k = 12;

var g_system_trigger_enabled = 1;
// Triggering logic:
// - float change (delta) => NOTES
// - integer change (floor) => sometimes SWEEP
var g_system_trigger_mode = "delta";
// Lower delta => more notes when /system/state is smooth.
var g_system_delta = 0.04;
var g_last_system_state = null;
var g_last_system_int = null;

var g_last_trigger_ms = 0;
var g_avail = [];
var g_avail_weights = [];
var g_last_list_ms = 0;
var g_avail_weight_sum = 0.0;
var g_cycle_order = [];
var g_cycle_pos = 0;

var g_releaseTask = null;
var g_attackTask = null;
var g_pending_offset = 0.0;
var g_pending_scale = 0.0;
var g_pending_hold_ms = 0;
var g_pending_delay_ms = 0;

var g_notes_per_trigger = 3;
var g_inter_delay_set_ms = [0, 12, 24, 48, 72];
var g_note_seq_task = null;
var g_note_seq_left = 0;

// Event-driven paging: request a new partial bank when we've "used" enough bins.
// This avoids clocks and keeps paging tied to musical activity.
// Output: emits ["nextbank"] on outlet 2 (debug), so you can route it to the loader js.
var g_request_nextbank = 1;
var g_request_unique_target = 75;     // request when we've hit this many unique bins (clamped to avail length)
var g_request_note_cap = 500;         // safety: request after N notes even if randomness doesn't cover all bins
var g_request_min_interval_ms = 2000; // don't request too frequently
var g_last_nextbank_ms = 0;
var g_used_bins = {};                 // idx -> 1
var g_used_unique = 0;
var g_notes_since_bank = 0;

// Avoid repeating bin picks within the same bank until we've exhausted the available bins.
var g_no_repeat = 1;

// -------------------- Bank sweep mode --------------------
// Sometimes, instead of "notes", scan through the current bank range so you hear
// the full evolution of those partials (e.g. 1300 -> 1383).
//
// Requires receiving loader status in inlet 0:
//   loaded <path> ... startPartial <N> bankSize <B> ...
var g_bank_start_partial = 0;
var g_bank_size = 83;
// Current "cursor" in global partial index space (used for sweeps)
var g_bank_cursor_partial = 0;
// Total partials in current file (from loader "loaded ... partialsCount <N>")
var g_file_partials_count = -1;

var g_sweep_duration_ms = 3200;     // total time for the sweep
var g_sweep_interval_ms = 30;       // update interval for ramp
var g_sweep_running = 0;
var g_sweep_task = null;
var g_sweep_t0_ms = 0;
// Sweep now drives BOTH outlets simultaneously:
// - outlet 0 ramps forward
// - outlet 1 ramps backward
var g_sweep_min_gap_ms = 5000;      // minimum time between sweeps (prevents sweep-streaks)
var g_last_sweep_ms = 0;
var g_notes_since_sweep = 9999;
var g_min_notes_between_sweeps = 2; // force at least N note triggers between sweeps

// Extra sweep variant:
// Sometimes keep LEFT box static at "total partials in file" while RIGHT sweeps the current bank.
var g_sweep_left_total_enabled = 1;
var g_sweep_left_total_prob = 0.30;
var g_sweep_left_total_active = 0;

// Trigger policy:
// - "int_sweep": NOTES on float-delta, SWEEP only on integer-change (classic behavior)
// - "mix": choose notes vs sweep on each trigger (optional)
var g_trigger_mode = "int_sweep";

// Integer-change sweep probability (only used in "int_sweep")
var g_sweep_on_int_prob = 0.30;

// Optional mix probabilities (only used in "mix")
var g_prob_notes = 0.70;
var g_prob_sweep = 0.30;

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

// (Removed) legacy _map01 helper (was only used for offset/scale mapping).

function _rebuildAvailableFromList(list83) {
  g_avail = [];
  g_avail_weights = [];
  g_avail_weight_sum = 0.0;
  g_cycle_order = [];
  g_cycle_pos = 0;

  var n = Math.min(g_N, list83.length);
  for (var i = 0; i < n; i++) {
    var v = parseFloat(list83[i]);
    if (isNaN(v)) v = 0.0;
    if (v > g_avail_threshold) {
      g_avail.push(i);
      g_avail_weights.push(v);
      g_avail_weight_sum += v;
    }
  }

  // Build deterministic cycle order: sort available bins by weight desc.
  // (Still "from the list", but no random selection.)
  if (g_avail.length > 0) {
    var pairs = [];
    for (var j = 0; j < g_avail.length; j++) {
      pairs.push([g_avail[j], g_avail_weights[j]]);
    }
    pairs.sort(function(a, b) {
      // weight desc; tie-break by index asc
      if (b[1] > a[1]) return 1;
      if (b[1] < a[1]) return -1;
      return a[0] - b[0];
    });
    for (var k = 0; k < pairs.length; k++) g_cycle_order.push(pairs[k][0]);
  }

  g_last_list_ms = _nowMs();

  // New bank/list arrived: reset usage tracking
  g_used_bins = {};
  g_used_unique = 0;
  g_notes_since_bank = 0;
}

function _noteUsed(idx) {
  g_notes_since_bank += 1;
  var k = String(idx);
  if (!g_used_bins[k]) {
    g_used_bins[k] = 1;
    g_used_unique += 1;
  }
  // Update cursor to reflect the last-used bin in the current bank
  g_bank_cursor_partial = (Math.max(0, parseInt(g_bank_start_partial, 10) || 0) + (parseInt(idx, 10) || 0));
  _maybeRequestNextBank();
}

function _maybeRequestNextBank() {
  if (!g_request_nextbank) return;
  var now = _nowMs();
  if ((now - g_last_nextbank_ms) < g_request_min_interval_ms) return;

  var availN = (g_avail && g_avail.length > 0) ? g_avail.length : g_N;
  var target = Math.max(1, Math.min(parseInt(g_request_unique_target, 10) || 1, availN));

  if (g_used_unique >= target || g_notes_since_bank >= g_request_note_cap) {
    g_last_nextbank_ms = now;
    // Reset counters immediately to avoid spamming if the loader takes time to respond.
    g_used_bins = {};
    g_used_unique = 0;
    g_notes_since_bank = 0;
    outlet(2, ["nextbank"]);
  }
}

function _pickIndex() {
  if (!g_avail || g_avail.length === 0) {
    // fallback: any bin
    return Math.floor(Math.random() * g_N);
  }

  if (g_pick_mode === "cycle") {
    if (!g_cycle_order || g_cycle_order.length === 0) {
      // fallback to first available
      return g_avail[0];
    }
    var Lc = g_cycle_order.length;
    if (!g_no_repeat) {
      var idx0 = g_cycle_order[g_cycle_pos % Lc];
      g_cycle_pos = (g_cycle_pos + 1) % Lc;
      return idx0;
    }
    // No-repeat cycle: skip indices already used in this bank until exhausted.
    for (var tc = 0; tc < Lc; tc++) {
      var idx = g_cycle_order[g_cycle_pos % Lc];
      g_cycle_pos = (g_cycle_pos + 1) % Lc;
      if (!g_used_bins[String(idx)]) return idx;
    }
    // All used already; fall back to normal cycling.
    return g_cycle_order[g_cycle_pos % Lc];
  }

  if (g_pick_mode === "top") {
    // pick from the top K by weight
    var pairs = [];
    for (var i = 0; i < g_avail.length; i++) {
      pairs.push([g_avail[i], g_avail_weights[i]]);
    }
    pairs.sort(function(a, b) { return b[1] - a[1]; });
    var k = Math.max(1, Math.min(g_top_k, pairs.length));
    if (!g_no_repeat) {
      var j0 = Math.floor(Math.random() * k);
      return pairs[j0][0];
    }
    // No-repeat: try a few times to find an unused one.
    for (var tt = 0; tt < Math.min(12, k); tt++) {
      var j = Math.floor(Math.random() * k);
      var cand = pairs[j][0];
      if (!g_used_bins[String(cand)]) return cand;
    }
    return pairs[Math.floor(Math.random() * k)][0];
  }

  if (g_pick_mode === "weighted") {
    // Roulette-wheel selection proportional to avail amplitude
    var sum = g_avail_weight_sum;
    if (!(sum > 0.0)) {
      // fallback to uniform
      var rr = Math.floor(Math.random() * g_avail.length);
      return g_avail[rr];
    }
    function _weightedOnce() {
      var t = Math.random() * sum;
      var acc = 0.0;
      for (var i = 0; i < g_avail.length; i++) {
        acc += g_avail_weights[i];
        if (acc >= t) return g_avail[i];
      }
      return g_avail[g_avail.length - 1];
    }
    if (!g_no_repeat) return _weightedOnce();
    // No-repeat: retry a few times to avoid already-used bins.
    for (var tw = 0; tw < 16; tw++) {
      var candW = _weightedOnce();
      if (!g_used_bins[String(candW)]) return candW;
    }
    return _weightedOnce();
  }

  // default: random among available
  if (!g_no_repeat) {
    var r0 = Math.floor(Math.random() * g_avail.length);
    return g_avail[r0];
  }
  for (var tr = 0; tr < 16; tr++) {
    var r = Math.floor(Math.random() * g_avail.length);
    var candR = g_avail[r];
    if (!g_used_bins[String(candR)]) return candR;
  }
  return g_avail[Math.floor(Math.random() * g_avail.length)];
}

function _pickFromSet(arr, fallback) {
  if (!arr || arr.length === 0) return fallback;
  var i = Math.floor(Math.random() * arr.length);
  var v = parseInt(arr[i], 10);
  if (isNaN(v)) return fallback;
  return v;
}

function _maybePickLongSustainMs(defaultMs) {
  if (!g_long_sustain_enabled) return defaultMs;
  var p = parseFloat(g_long_sustain_prob);
  if (isNaN(p) || p <= 0.0) return defaultMs;
  if (Math.random() >= Math.max(0.0, Math.min(1.0, p))) return defaultMs;
  return _pickFromSet(g_long_sustain_set_ms, defaultMs);
}

function _pickFloatListFromAvailMessage(list83) {
  // Accept:
  // - plain list: <f1> <f2> ...
  // - avail message: avail <N> <f1> <f2> ...
  // - count-prefixed: <N> <f1> <f2> ...
  if (!list83 || list83.length === 0) return list83;
  if (String(list83[0]) === "avail") {
    if (list83.length >= 3) return list83.slice(2);
    return [];
  }
  // If first token looks like an integer count, drop it.
  var n0 = parseInt(list83[0], 10);
  if (!isNaN(n0) && n0 > 0 && list83.length >= (n0 + 1)) {
    return list83.slice(1);
  }
  return list83;
}

function _looksLikeNumericFloatList(arr) {
  if (!arr || arr.length === 0) return false;

  // Explicit avail message
  if (String(arr[0]) === "avail") {
    return (arr.length >= 3);
  }

  // Count-prefixed list: N f1 f2 ...
  var n0 = parseInt(arr[0], 10);
  if (!isNaN(n0) && n0 > 0 && arr.length >= (n0 + 1)) {
    var f1 = parseFloat(arr[1]);
    return !isNaN(f1);
  }

  // Plain list of floats
  var numeric = 0;
  var checkN = Math.min(arr.length, 32);
  for (var i = 0; i < checkN; i++) {
    var v = parseFloat(arr[i]);
    if (!isNaN(v)) numeric++;
  }
  return (numeric >= Math.max(4, Math.floor(checkN * 0.75)));
}

function _handleLoaderLoaded(arr) {
  // Keep it robust: scan for startPartial + bankSize keys.
  var sp = null;
  var bs = null;
  var pc = null;
  for (var i = 2; i < arr.length - 1; i++) {
    var k = String(arr[i]);
    if (k === "startPartial") {
      var v = parseInt(arr[i + 1], 10);
      if (!isNaN(v) && v >= 0) sp = v;
    } else if (k === "bankSize") {
      var b = parseInt(arr[i + 1], 10);
      if (!isNaN(b) && b > 0) bs = b;
    } else if (k === "partialsCount") {
      var c = parseInt(arr[i + 1], 10);
      if (!isNaN(c) && c > 0) pc = c;
    }
  }
  if (sp !== null) g_bank_start_partial = sp;
  if (bs !== null) g_bank_size = bs;
  if (pc !== null) g_file_partials_count = pc;
  // If cursor is unset or out of current bank, snap it to the END of the bank.
  // (Sweeps are defined as cursor-bankSize -> cursor, so "end of bank" yields a full-bank sweep.)
  var startP = Math.max(0, parseInt(g_bank_start_partial, 10) || 0);
  var bsP = Math.max(1, parseInt(g_bank_size, 10) || 83);
  if (!(g_bank_cursor_partial >= startP && g_bank_cursor_partial < (startP + bsP))) {
    var endP = startP + bsP;
    if (g_file_partials_count > 0) {
      var pcN = Math.max(1, parseInt(g_file_partials_count, 10) || 0);
      if (endP > (pcN - 1)) endP = pcN - 1;
    }
    g_bank_cursor_partial = endP;
  }
  outlet(2, ["bank", "startPartial", g_bank_start_partial, "bankSize", g_bank_size, "cursor", g_bank_cursor_partial, "partialsCount", g_file_partials_count]);
}

function _triggerNote() {
  var now = _nowMs();
  if ((now - g_last_trigger_ms) < g_debounce_ms) return;
  g_last_trigger_ms = now;

  if (g_sweep_running) return;

  // NOTES ONLY (sweeps are triggered separately by integer-change events)
  outlet(2, ["trigger_style", "notes"]);
  g_notes_since_sweep += 1;
  g_note_seq_left = Math.max(1, parseInt(g_notes_per_trigger, 10) || 1);
  _scheduleNextNoteInSequence(0);
}

function _startBankSweep() {
  if (g_sweep_running) return;
  g_sweep_running = 1;
  g_sweep_t0_ms = _nowMs();
  g_last_sweep_ms = g_sweep_t0_ms;
  g_notes_since_sweep = 0;

  // Decide whether to use the "left = total partials" variant for this sweep
  g_sweep_left_total_active = 0;
  if (g_sweep_left_total_enabled && g_file_partials_count > 0) {
    var p = parseFloat(g_sweep_left_total_prob);
    if (!isNaN(p) && p > 0.0) {
      p = Math.max(0.0, Math.min(1.0, p));
      if (Math.random() < p) g_sweep_left_total_active = 1;
    }
  }

  if (g_sweep_task === null) g_sweep_task = new Task(_bankSweepTick, this);
  else g_sweep_task.cancel();
  g_sweep_task.interval = Math.max(5, parseInt(g_sweep_interval_ms, 10) || 30);
  g_sweep_task.repeat(1);

  outlet(2, ["sweep_start", "cursor", g_bank_cursor_partial, "bankSize", g_bank_size, "partialsCount", g_file_partials_count, "left_total", g_sweep_left_total_active, "dur_ms", g_sweep_duration_ms]);
}

function _maybeSweepAllowedNow() {
  if (g_sweep_running) return 0;
  var now = _nowMs();
  if (g_sweep_min_gap_ms > 0 && (now - g_last_sweep_ms) < g_sweep_min_gap_ms) return 0;
  if (g_notes_since_sweep < g_min_notes_between_sweeps) return 0;
  return 1;
}

function _triggerFromSystem(reason) {
  // Choose sweep vs notes by probability; if sweep is gated, fall back to notes.
  var doSweep = (Math.random() < g_prob_sweep) ? 1 : 0;
  if (doSweep && _maybeSweepAllowedNow()) {
    outlet(2, ["trigger_style", "sweep", "reason", reason]);
    _startBankSweep();
    return;
  }
  outlet(2, ["trigger_style", "notes", "reason", reason]);
  _triggerNote();
}

function _maybeSweepFromIntChange(reason) {
  if (!_maybeSweepAllowedNow()) return 0;
  var p = parseFloat(g_sweep_on_int_prob);
  if (isNaN(p) || p <= 0.0) return 0;
  p = Math.max(0.0, Math.min(1.0, p));
  if (Math.random() >= p) return 0;
  outlet(2, ["trigger_style", "sweep", "reason", reason]);
  _startBankSweep();
  return 1;
}

function _bankSweepTick() {
  if (!g_sweep_running) return;
  var now = _nowMs();
  var dt = now - g_sweep_t0_ms;
  var dur = Math.max(1, parseInt(g_sweep_duration_ms, 10) || 1);
  var t01 = _clamp01(dt / dur);

  // Sweep around the *current* cursor, covering one bank width:
  // start = cursor - bankSize, end = cursor
  var endP = Math.max(0, parseInt(g_bank_cursor_partial, 10) || 0);
  var bs = Math.max(1, parseInt(g_bank_size, 10) || 83);
  // If the cursor is sitting at the bank start (common right after 'loaded'),
  // sweeping cursor-bankSize -> cursor can become 0->0. Make it a full-bank sweep instead.
  var bankStart = Math.max(0, parseInt(g_bank_start_partial, 10) || 0);
  if (endP <= bankStart) endP = bankStart + bs;
  var startP = Math.max(0, endP - bs);
  // Clamp to file bounds if we know partialsCount
  if (g_file_partials_count > 0) {
    var pc = Math.max(1, parseInt(g_file_partials_count, 10) || 0);
    if (endP > (pc - 1)) endP = pc - 1;
    if (startP > endP) startP = Math.max(0, endP - bs);
  }

  var vF = startP + (endP - startP) * t01; // forward
  var vB = endP - (endP - startP) * t01;   // backward
  // Update cursor during sweep so the next sweep continues from the latest position
  g_bank_cursor_partial = vF;

  // In sweep mode we output the *partial index range* directly on BOTH outlets.
  // Right box (outlet 1) goes forward, left box (outlet 0) goes backward.
  outlet(1, vF);
  if (g_sweep_left_total_active && g_file_partials_count > 0) {
    outlet(0, parseFloat(g_file_partials_count));
  } else {
    outlet(0, vB);
  }

  if (t01 >= 1.0) {
    g_sweep_running = 0;
    // Don't zero the outputs here; leaving the last values makes the sweep perceptible
    // and avoids abrupt "mute" moments in downstream patches.
    // Only after sweep ends: request next bank
    outlet(2, ["sweep_end", "nextbank"]);
    outlet(2, ["nextbank"]);
    return;
  }

  if (g_sweep_task !== null) {
    try { g_sweep_task.repeat(1); } catch (e) {}
  }
}

function _scheduleNextNoteInSequence(firstDelayMs) {
  if (g_note_seq_left <= 0) return;

  var delay_ms = Math.max(0, parseInt(firstDelayMs, 10) || 0);
  if (g_note_seq_task === null) g_note_seq_task = new Task(_noteSeqTick, this);
  else g_note_seq_task.cancel();
  g_note_seq_task.interval = delay_ms;
  g_note_seq_task.repeat(1);
}

function _noteSeqTick() {
  if (g_note_seq_left <= 0) return;
  g_note_seq_left -= 1;

  var idx = _pickIndex(); // 0..82
  _noteUsed(idx);
  // NOTE MODE (bank indices):
  // Right box (outlet 1) = start index in the current bank
  // Left box  (outlet 0) = end index in the current bank (start + bankSize)
  var startP = Math.max(0, (parseInt(g_bank_start_partial, 10) || 0) + (parseInt(idx, 10) || 0));
  var bs = Math.max(1, parseInt(g_bank_size, 10) || 83);
  // Clamp end at end-of-file if we know partialsCount
  if (g_file_partials_count > 0) {
    var remain = (parseInt(g_file_partials_count, 10) || 0) - startP;
    if (remain > 0) bs = Math.max(1, Math.min(bs, remain));
  }
  var endP = startP + bs;
  // Keep cursor aligned with note position so sweeps continue from here.
  g_bank_cursor_partial = startP;

  var hold_ms = g_random_sustain ? _pickFromSet(g_sustain_set_ms, g_hold_ms) : g_hold_ms;
  hold_ms = _maybePickLongSustainMs(hold_ms);
  hold_ms = Math.max(1, parseInt(hold_ms, 10));

  // Optional delayed attack (humanize)
  var delay_ms = g_random_delay ? _pickFromSet(g_delay_set_ms, 0) : 0;
  delay_ms = Math.max(0, parseInt(delay_ms, 10));

  // outlet 0 (left) should be end, outlet 1 (right) should be start
  g_pending_offset = endP;
  g_pending_scale = startP;
  g_pending_hold_ms = hold_ms;
  g_pending_delay_ms = delay_ms;

  if (g_attackTask === null) g_attackTask = new Task(_attack, this);
  else g_attackTask.cancel();
  if (g_releaseTask === null) g_releaseTask = new Task(_release, this);
  else g_releaseTask.cancel();

  if (delay_ms <= 0) _attack();
  else { g_attackTask.interval = delay_ms; g_attackTask.repeat(1); }

  outlet(2, ["note", "idx", idx, "start", startP, "end", endP, "delay_ms", delay_ms, "hold_ms", hold_ms, "avail", g_avail.length]);

  if (g_note_seq_left > 0) {
    var inter = _pickFromSet(g_inter_delay_set_ms, 0);
    _scheduleNextNoteInSequence(inter);
  }
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

  // Loader status (from partials_bank_to_coll.js outlet 1)
  if (a0 === "loaded") {
    _handleLoaderLoaded(arr);
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

  // 1) Integer-change => maybe sweep (does NOT trigger notes by itself)
  var iv = Math.floor(v);
  if (g_last_system_int === null) g_last_system_int = iv;
  if (iv !== g_last_system_int) {
    g_last_system_int = iv;
    g_last_system_state = v;
    if (g_trigger_mode === "mix") {
      _triggerFromSystem("int_change");
    } else {
      _maybeSweepFromIntChange("int_change");
    }
    return;
  }

  // 2) Float-change (delta) => notes
  if (g_system_trigger_mode === "delta") {
    if (Math.abs(v - g_last_system_state) >= g_system_delta) {
      if (g_trigger_mode === "mix") {
        _triggerFromSystem("delta");
      } else {
        outlet(2, ["trigger_style", "notes", "reason", "delta"]);
        _triggerNote();
      }
      g_last_system_state = v;
      return;
    }
  }

  g_last_system_state = v;
}

// Manual: force a sweep (for testing / performance)
function sweep() {
  if (g_sweep_running) return;
  outlet(2, ["trigger_style", "sweep", "reason", "manual"]);
  _startBankSweep();
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
    // availability list (plain floats OR loader "avail ..." message)
    if (_looksLikeNumericFloatList(arr)) {
      _rebuildAvailableFromList(_pickFloatListFromAvailMessage(arr));
    }
    return;
  }

  // oscparse output list
  _handleOscParsed(arr);
}

function anything() {
  var arr = [messagename];
  for (var i = 0; i < arguments.length; i++) arr.push(arguments[i]);

  if (inlet === 1) {
    if (_looksLikeNumericFloatList(arr)) {
      _rebuildAvailableFromList(_pickFloatListFromAvailMessage(arr));
    }
    return;
  }

  _handleOscParsed(arr);
}

function setnotes(n) {
  var v = parseInt(n, 10);
  if (isNaN(v)) return;
  g_notes_per_trigger = Math.max(1, Math.min(8, v));
  outlet(2, ["setnotes", g_notes_per_trigger]);
}

function setnextbank(n) {
  g_request_nextbank = (parseInt(n, 10) ? 1 : 0);
  outlet(2, ["setnextbank", g_request_nextbank]);
}

function setnextbankunique(n) {
  var v = parseInt(n, 10);
  if (isNaN(v)) return;
  g_request_unique_target = Math.max(1, v);
  outlet(2, ["setnextbankunique", g_request_unique_target]);
}

function setnextbanknotecap(n) {
  var v = parseInt(n, 10);
  if (isNaN(v)) return;
  g_request_note_cap = Math.max(1, v);
  outlet(2, ["setnextbanknotecap", g_request_note_cap]);
}

function setnextbankinterval(ms) {
  var v = parseInt(ms, 10);
  if (isNaN(v)) return;
  g_request_min_interval_ms = Math.max(0, v);
  outlet(2, ["setnextbankinterval_ms", g_request_min_interval_ms]);
}

function setsweepdur(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_sweep_duration_ms = Math.max(50, x);
  outlet(2, ["setsweepdur_ms", g_sweep_duration_ms]);
}

function setsweepinterval(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_sweep_interval_ms = Math.max(5, x);
  outlet(2, ["setsweepinterval_ms", g_sweep_interval_ms]);
}

function settriggermode(m) {
  var s = String(m || "").toLowerCase();
  if (s !== "int_sweep" && s !== "mix") return;
  g_trigger_mode = s;
  outlet(2, ["settriggermode", g_trigger_mode]);
}

function setsweeponintprob(p) {
  var x = parseFloat(p);
  if (isNaN(x)) return;
  g_sweep_on_int_prob = Math.max(0.0, Math.min(1.0, x));
  outlet(2, ["setsweeponintprob", g_sweep_on_int_prob]);
}

function setnotesprob(p) {
  var x = parseFloat(p);
  if (isNaN(x)) return;
  g_prob_notes = Math.max(0.0, Math.min(1.0, x));
  g_prob_sweep = 1.0 - g_prob_notes;
  outlet(2, ["setnotesprob", g_prob_notes, "sweepprob", g_prob_sweep]);
}

function setsweepprob(p) {
  var x = parseFloat(p);
  if (isNaN(x)) return;
  g_prob_sweep = Math.max(0.0, Math.min(1.0, x));
  g_prob_notes = 1.0 - g_prob_sweep;
  outlet(2, ["setsweepprob", g_prob_sweep, "notesprob", g_prob_notes]);
}

function setlefttotalprob(p) {
  var x = parseFloat(p);
  if (isNaN(x)) return;
  g_sweep_left_total_prob = Math.max(0.0, Math.min(1.0, x));
  outlet(2, ["setlefttotalprob", g_sweep_left_total_prob]);
}

// One-shot recovery: restore sane defaults if settings get extreme during a performance.
function resetdefaults() {
  g_debounce_ms = 60;
  g_system_delta = 0.04;
  g_notes_per_trigger = 3;
  g_pick_mode = "cycle";

  g_sweep_min_gap_ms = 5000;
  g_min_notes_between_sweeps = 2;
  g_trigger_mode = "int_sweep";
  g_sweep_on_int_prob = 0.30;
  g_prob_notes = 0.70; // used only in "mix"
  g_prob_sweep = 0.30; // used only in "mix"

  g_sweep_left_total_enabled = 1;
  g_sweep_left_total_prob = 0.30;

  outlet(2, ["resetdefaults",
    "system_delta", g_system_delta,
    "debounce_ms", g_debounce_ms,
    "notes", g_notes_per_trigger,
    "pick", g_pick_mode,
    "triggermode", g_trigger_mode,
    "sweep_int_prob", g_sweep_on_int_prob,
    "notesprob", g_prob_notes,   // mix-only
    "sweepprob", g_prob_sweep,   // mix-only
    "sweep_gap_ms", g_sweep_min_gap_ms,
    "left_total_prob", g_sweep_left_total_prob
  ]);
}
function setsweepgap(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_sweep_min_gap_ms = Math.max(0, x);
  outlet(2, ["setsweepgap_ms", g_sweep_min_gap_ms]);
}

function setsweepnotes(n) {
  var x = parseInt(n, 10);
  if (isNaN(x)) return;
  g_min_notes_between_sweeps = Math.max(0, x);
  outlet(2, ["setsweepnotes", g_min_notes_between_sweeps]);
}

function setinterdelayset(a, b, c, d, e) {
  var arr = [];
  var xs = [a, b, c, d, e];
  for (var i = 0; i < xs.length; i++) {
    var v = parseInt(xs[i], 10);
    if (!isNaN(v)) arr.push(Math.max(0, v));
  }
  if (arr.length >= 1) g_inter_delay_set_ms = arr;
  outlet(2, ["setinterdelayset_ms"].concat(g_inter_delay_set_ms));
}

// For wiring like:
//   [udpreceive 9001] -> [route /system/state] -> [unpack f] -> [js osc_to_jitter_notes.js]
// Max will send a float directly (no OSC address). Handle that here.
function msg_float(v) {
  if (inlet === 1) return; // inlet 1 is reserved for the 83-float availability list
  _handleSystemStateFloat(v);
}

// -------------------- Commands (tuning) --------------------
function sethold(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_hold_ms = Math.max(1, x);
  outlet(2, ["sethold_ms", g_hold_ms]);
}

function setlongsustain(n) {
  g_long_sustain_enabled = (parseInt(n, 10) ? 1 : 0);
  outlet(2, ["setlongsustain", g_long_sustain_enabled]);
}

function setlongsustainprob(p) {
  var x = parseFloat(p);
  if (isNaN(x)) return;
  g_long_sustain_prob = Math.max(0.0, Math.min(1.0, x));
  outlet(2, ["setlongsustainprob", g_long_sustain_prob]);
}

function setlongsustainset(a, b, c, d, e, f) {
  var xs = [a, b, c, d, e, f];
  var arr = [];
  for (var i = 0; i < xs.length; i++) {
    var v = parseInt(xs[i], 10);
    if (!isNaN(v) && v > 0) arr.push(v);
  }
  if (arr.length >= 1) g_long_sustain_set_ms = arr;
  outlet(2, ["setlongsustainset_ms"].concat(g_long_sustain_set_ms));
}

function setdebounce(ms) {
  var x = parseInt(ms, 10);
  if (isNaN(x)) return;
  g_debounce_ms = Math.max(0, x);
  outlet(2, ["setdebounce_ms", g_debounce_ms]);
}

// (Removed) setoffset/setscale (no longer applicable).

function setthreshold(v) {
  var x = parseFloat(v);
  if (isNaN(x)) return;
  g_avail_threshold = Math.max(0.0, x);
  outlet(2, ["setthreshold", g_avail_threshold]);
}

function setpickmode(m) {
  var s = String(m || "").toLowerCase();
  if (s !== "random" && s !== "top" && s !== "weighted" && s !== "cycle") return;
  g_pick_mode = s;
  outlet(2, ["setpickmode", g_pick_mode]);
}

function setnorepeat(v) {
  g_no_repeat = (parseInt(v, 10) ? 1 : 0);
  outlet(2, ["setnorepeat", g_no_repeat]);
}

function settopk(k) {
  var x = parseInt(k, 10);
  if (isNaN(x)) return;
  g_top_k = Math.max(1, x);
  outlet(2, ["settopk", g_top_k]);
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
    "offset_scale", "bank_index_mode",
    "pick", g_pick_mode,
    "top_k", g_top_k,
    "system_trigger", g_system_trigger_enabled,
    "system_mode", g_system_trigger_mode,
    "system_delta", g_system_delta,
    "bank_start", g_bank_start_partial,
    "bank_size", g_bank_size,
    "partials_count", g_file_partials_count,
    "used_unique", g_used_unique,
    "notes_since_bank", g_notes_since_bank,
    "no_repeat", g_no_repeat,
    "avail_len", (g_avail ? g_avail.length : 0),
    "avail_age_ms", (_nowMs() - (g_last_list_ms || 0))
  ]);
}

function clear() {
  g_avail = [];
  g_avail_weights = [];
  _release();
  outlet(2, ["clear"]);
}


