// partials_bank_to_coll.js
// Out0: coll commands (clear/store). Out1: status.

inlets = 1;
outlets = 2;
autowatch = 1;

var g_bankSize = 83;
var g_pointsPerPartial = 83;
var g_startPartial = 0;
var g_resample = 1;
var g_keyOffset = 0;
var g_mode = "full";

var g_bankData = {};
var g_bankLoaded = false;
var g_lastSourcePath = "";
var g_lastPartialsCount = -1;
var g_fullLoaded = false;

var g_windowEnable = 0;
var g_windowStart = 0;
var g_windowSize = 83;
var g_windowPadHold = 1;
var g_fullTriplets = {};

// Folder playlist
var g_folderPath = "";
var g_folderPathResolved = "";
var g_scanSuffix = ".txt";
var g_files = [];
var g_currentFileIdx = -1;
var g_randomizeStart = 0;
var g_avoidRepeat = 1;

// Status/progress reporting (outlet 1)
var g_progressEnabled = 1;
var g_progressMinIntervalMs = 80; // don't spam Max UI

// File list verbosity (outlet 1)
// When scanning big folders, dumping all file paths can be heavy. Default OFF.
var g_emitFileList = 0;

// Auto-advance to a new file after ingest completes (uses scanned folder list).
var g_autoNext = 0;
var g_autoNextDelayMs = 150;
var g_autoNextTask = null;

var g_isIngesting = 0;
var g_jumpMinIntervalMs = 250;
var g_lastJumpMs = 0;

// Auto-next behavior:
// - "loaded": jump right after ingest completes (legacy behavior)
// - "window_end": jump when nextwindow would go past the end of available points (autowindow use)
// - "bank_end": jump when autobank reaches end-of-file (preferred for huge partialsCount)
var g_autoNextMode = "bank_end";

var g_lastMinPoints = 0;

// Coll-text ingest acceleration (avoid rescanning huge files on every autobank step)
var g_collCachePath = "";
var g_collCacheSawPointType = 0;
var g_collCacheBaseKey = 1;
var g_collCacheOffsets = {}; // key(int) -> file position (byte offset at start of line)
var g_collCacheMaxKeyIndexed = -1;
var g_collCacheLastPos = 0;
var g_collCacheMaxKeyOverall = -1; // estimated max key in file (for partialsCount)

// Chunked coll writes: emitting huge "store" messages in one scheduler tick can freeze Max UI.
var g_collFlushQueue = [];
var g_collFlushTask = null;
var g_collFlushBatch = 2; // messages per tick
var g_collFlushMeta = null;

// Auto-advance point windows (hands-free). Two modes:
// - "osc": only advance when autowindowtick is received (drive from OSC/bang)
// - "timer": advance periodically every g_autoWindowIntervalMs
var g_autoWindow = 0;
var g_autoWindowMode = "osc"; // "osc" | "timer"
var g_autoWindowIntervalMs = 2500;
var g_autoWindowTask = null;
var g_autoWindowWaitingForLoad = 0;

// Auto-advance banks (pages through many partials in a file by moving startPartial).
// Use this when partialsCount is huge but each partial has only ~83 points.
var g_autoBank = 0;
var g_autoBankMode = "osc"; // "osc" | "timer"
var g_autoBankIntervalMs = 2500;
var g_autoBankTask = null;
var g_autoBankWaitingForLoad = 0;

// One-shot "make it work" defaults (so you don't need many setup messages)
var g_autoDefaultsEnable = 1;
var g_autoDefaultsMode = "bank";
var g_autoDefaultsBankSize = 83;
var g_autoDefaultsResample = 0;
var g_autoDefaultsWindowEnable = 1;
var g_autoDefaultsWindowSize = 83;
var g_autoDefaultsWindowStart = 0;
var g_autoDefaultsAutoNext = 1;
var g_autoDefaultsAutoNextMode = "bank_end";
// For big files with many partials: page through banks automatically.
var g_autoDefaultsAutoBank = 1;
var g_autoDefaultsAutoBankMode = "osc"; // "osc" | "timer"
var g_autoDefaultsAutoBankIntervalMs = 2500;
// Folder playback behavior
var g_autoDefaultsAvoidRepeat = 1;
var g_autoDefaultsRandomStart = 1;

var g_emitAvail = 1; // emit "avail" list (83 floats) on loaded/window updates

function setfolder(path) {
  if (path === undefined || path === null) {
    post("partials_bank_to_coll.js: setfolder requires a folder path\n");
    return;
  }
  g_folderPath = String(path);
  g_folderPathResolved = _resolvePath(g_folderPath, /*isFolder*/ true);
}

function setrandomstart(n) {
  g_randomizeStart = (parseInt(n, 10) ? 1 : 0);
}

function setavoidrepeat(n) {
  g_avoidRepeat = (parseInt(n, 10) ? 1 : 0);
}

function setprogress(n) {
  g_progressEnabled = (parseInt(n, 10) ? 1 : 0);
}

function setprogressinterval(ms) {
  var v = parseInt(ms, 10);
  if (v >= 0) g_progressMinIntervalMs = v;
}

function setfilelist(n) {
  g_emitFileList = (parseInt(n, 10) ? 1 : 0);
}

function setautonext(n) {
  g_autoNext = (parseInt(n, 10) ? 1 : 0);
  outlet(1, ["autonext", g_autoNext, "delayMs", g_autoNextDelayMs, "mode", g_autoNextMode]);
}

function setautonextdelay(ms) {
  var v = parseInt(ms, 10);
  if (isNaN(v)) return;
  g_autoNextDelayMs = Math.max(0, v);
  outlet(1, ["autonext", g_autoNext, "delayMs", g_autoNextDelayMs, "mode", g_autoNextMode]);
}

function setautonextmode(m) {
  if (m === undefined || m === null) return;
  m = String(m).toLowerCase();
  if (m !== "loaded" && m !== "window_end" && m !== "bank_end") {
    outlet(1, ["error", "bad_autonext_mode", m, "expected", "loaded|window_end|bank_end"]);
    return;
  }
  g_autoNextMode = m;
  outlet(1, ["autonext", g_autoNext, "delayMs", g_autoNextDelayMs, "mode", g_autoNextMode]);
}

function setautowindow(n) {
  g_autoWindow = (parseInt(n, 10) ? 1 : 0);
  _syncAutoWindow();
  outlet(1, ["autowindow", g_autoWindow, "mode", g_autoWindowMode, "intervalMs", g_autoWindowIntervalMs]);
}

function setautowindowmode(m) {
  if (m === undefined || m === null) return;
  m = String(m).toLowerCase();
  if (m !== "osc" && m !== "timer") {
    outlet(1, ["error", "bad_autowindow_mode", m, "expected", "osc|timer"]);
    return;
  }
  g_autoWindowMode = m;
  _syncAutoWindow();
  outlet(1, ["autowindow", g_autoWindow, "mode", g_autoWindowMode, "intervalMs", g_autoWindowIntervalMs]);
}

function setautowindowinterval(ms) {
  var v = parseInt(ms, 10);
  if (isNaN(v)) return;
  g_autoWindowIntervalMs = Math.max(0, v);
  _syncAutoWindow();
  outlet(1, ["autowindow", g_autoWindow, "mode", g_autoWindowMode, "intervalMs", g_autoWindowIntervalMs]);
}

// External driver: call from OSC/bang routing to advance one window.
function autowindowtick() {
  if (!g_autoWindow) return;
  _autoWindowStep("osc");
}

function setautobank(n) {
  g_autoBank = (parseInt(n, 10) ? 1 : 0);
  _syncAutoBank();
  outlet(1, ["autobank", g_autoBank, "mode", g_autoBankMode, "intervalMs", g_autoBankIntervalMs]);
}

function setautobankmode(m) {
  if (m === undefined || m === null) return;
  m = String(m).toLowerCase();
  if (m !== "osc" && m !== "timer") {
    outlet(1, ["error", "bad_autobank_mode", m, "expected", "osc|timer"]);
    return;
  }
  g_autoBankMode = m;
  _syncAutoBank();
  outlet(1, ["autobank", g_autoBank, "mode", g_autoBankMode, "intervalMs", g_autoBankIntervalMs]);
}

function setautobankinterval(ms) {
  var v = parseInt(ms, 10);
  if (isNaN(v)) return;
  g_autoBankIntervalMs = Math.max(0, v);
  _syncAutoBank();
  outlet(1, ["autobank", g_autoBank, "mode", g_autoBankMode, "intervalMs", g_autoBankIntervalMs]);
}

function autobanktick() {
  if (!g_autoBank) return;
  _autoBankStep("osc");
}

// Alias: friendlier message name for patching.
function nextbank() {
  autobanktick();
}

function _syncAutoBank() {
  if (g_autoBankTask !== null) {
    try { g_autoBankTask.cancel(); } catch (e) {}
  }
  if (!g_autoBank) return;
  if (g_autoBankMode !== "timer") return;
  _scheduleAutoBankTick();
}

function _scheduleAutoBankTick() {
  if (!g_autoBank || g_autoBankMode !== "timer") return;
  if (g_autoBankTask === null) {
    g_autoBankTask = new Task(_autoBankTimerTick, this);
  } else {
    try { g_autoBankTask.cancel(); } catch (e) {}
  }
  g_autoBankTask.interval = Math.max(0, parseInt(g_autoBankIntervalMs, 10) || 0);
  g_autoBankTask.repeat(1);
}

function _autoBankTimerTick() {
  if (!g_autoBank || g_autoBankMode !== "timer") return;
  if (g_autoBankWaitingForLoad) {
    _scheduleAutoBankTick();
    return;
  }
  _autoBankStep("timer");
  _scheduleAutoBankTick();
}

function _autoBankStep(source) {
  if (!g_lastSourcePath || !String(g_lastSourcePath).length) {
    outlet(1, ["autobank_skip", "reason", "no_path", "src", source]);
    return;
  }
  if (g_isIngesting) {
    outlet(1, ["autobank_skip", "reason", "ingesting", "src", source]);
    return;
  }

  // If we know the file has finite partialsCount, stop paging when we reach the end.
  var nextStart = Math.max(0, (parseInt(g_startPartial, 10) || 0) + (parseInt(g_bankSize, 10) || 83));
  if (g_lastPartialsCount > 0 && nextStart >= g_lastPartialsCount) {
    outlet(1, ["autobank_end", "startPartial", g_startPartial, "next", nextStart, "partialsCount", g_lastPartialsCount, "src", source]);
    if (g_autoNext && g_autoNextMode === "bank_end") {
      // Reuse existing auto-next machinery to jump to next file once.
      g_autoBankWaitingForLoad = 1;
      _maybeScheduleAutoNext();
    }
    return;
  }

  setstart(nextStart);
  outlet(1, ["autobank_step", "startPartial", g_startPartial, "bankSize", g_bankSize, "src", source]);
  // Re-ingest same file at a new startPartial. (This is O(N) scan in coll text; acceptable for occasional paging.)
  ingest(g_lastSourcePath);
}

function _syncAutoWindow() {
  // Cancel any existing task unless we're in timer mode and enabled.
  if (g_autoWindowTask !== null) {
    try { g_autoWindowTask.cancel(); } catch (e) {}
  }
  if (!g_autoWindow) return;
  if (g_autoWindowMode !== "timer") return;
  _scheduleAutoWindowTick();
}

function _scheduleAutoWindowTick() {
  if (!g_autoWindow || g_autoWindowMode !== "timer") return;
  if (g_autoWindowTask === null) {
    g_autoWindowTask = new Task(_autoWindowTimerTick, this);
  } else {
    try { g_autoWindowTask.cancel(); } catch (e) {}
  }
  g_autoWindowTask.interval = Math.max(0, parseInt(g_autoWindowIntervalMs, 10) || 0);
  g_autoWindowTask.repeat(1);
}

function _autoWindowTimerTick() {
  if (!g_autoWindow || g_autoWindowMode !== "timer") return;
  if (g_autoWindowWaitingForLoad) {
    _scheduleAutoWindowTick();
    return;
  }
  _autoWindowStep("timer");
  _scheduleAutoWindowTick();
}

function _autoWindowStep(source) {
  if (!g_windowEnable || !g_bankLoaded) {
    outlet(1, ["autowindow_skip", "reason", "not_ready", "window", g_windowEnable, "loaded", g_bankLoaded, "src", source]);
    return;
  }
  if (g_isIngesting) {
    outlet(1, ["autowindow_skip", "reason", "ingesting", "src", source]);
    return;
  }

  // If this step would trigger window_end and autonext is active, mark waiting to avoid spamming.
  if (g_autoNext && g_autoNextMode === "window_end") {
    var inc = g_windowSize;
    var limit = _windowPointLimit();
    if (limit > 0 && (g_windowStart + inc) >= limit) {
      g_autoWindowWaitingForLoad = 1;
      outlet(1, ["autowindow_wait", "reason", "window_end", "start", g_windowStart, "inc", inc, "limit", limit, "src", source]);
      nextwindow(inc); // will emit window_end and schedule autonext
      return;
    }
  }

  nextwindow(g_windowSize);
  outlet(1, ["autowindow_step", "start", g_windowStart, "size", g_windowSize, "src", source]);
}

function setjumpinterval(ms) {
  var v = parseInt(ms, 10);
  if (isNaN(v)) return;
  g_jumpMinIntervalMs = Math.max(0, v);
  outlet(1, ["jumpIntervalMs", g_jumpMinIntervalMs]);
}

function autoplay(folderPath, suffix) {
  // Single-command workflow:
  // 1) setfolder + scan
  // 2) configure safe defaults (83 voices, windowed points)
  // 3) enable autonext
  // 4) optionally enable autobank (page through many partials)
  // 4) jump
  if (folderPath !== undefined && folderPath !== null) {
    setfolder(folderPath);
  }
  if (suffix !== undefined && suffix !== null) {
    g_scanSuffix = String(suffix);
  }

  if (g_autoDefaultsEnable) {
    setmode(g_autoDefaultsMode);
    setbank(g_autoDefaultsBankSize);
    setresample(g_autoDefaultsResample);
    setwindow(g_autoDefaultsWindowEnable);
    setwindowsize(g_autoDefaultsWindowSize);
    setwindowstart(g_autoDefaultsWindowStart);
    setautonext(g_autoDefaultsAutoNext);
    setautonextmode(g_autoDefaultsAutoNextMode);
    setavoidrepeat(g_autoDefaultsAvoidRepeat);
    setrandomstart(g_autoDefaultsRandomStart);
    setautobank(g_autoDefaultsAutoBank);
    setautobankmode(g_autoDefaultsAutoBankMode);
    // interval is only used in timer mode
    if (String(g_autoDefaultsAutoBankMode) === "timer") setautobankinterval(g_autoDefaultsAutoBankIntervalMs);
  }

  scan(g_scanSuffix);
  jump();
}

function setautodefaults(n) {
  g_autoDefaultsEnable = (parseInt(n, 10) ? 1 : 0);
  outlet(1, ["autodefaults", g_autoDefaultsEnable]);
}

function setavail(n) {
  g_emitAvail = (parseInt(n, 10) ? 1 : 0);
  outlet(1, ["avail", "enabled", g_emitAvail]);
}

function scan(suffix) {
  _ensureDefaultFolder();
  if (suffix !== undefined && suffix !== null) {
    g_scanSuffix = String(suffix);
  }

  g_folderPathResolved = _resolvePath(g_folderPath, /*isFolder*/ true);
  g_files = _scanFolderFiles(g_folderPathResolved, g_scanSuffix);
  g_currentFileIdx = -1;

  if (g_emitFileList) outlet(1, ["files", g_files.length].concat(g_files));
  else outlet(1, ["files", g_files.length]);
  post("partials_bank_to_coll.js: scan found " + g_files.length + " files\n");
}

function files() {
  // Keep this lightweight by default; use `setfilelist 1` if you really want all paths.
  if (g_emitFileList) outlet(1, ["files", g_files.length].concat(g_files));
  else outlet(1, ["files", g_files.length]);
}

function where() {
  _ensureDefaultFolder();
  g_folderPathResolved = _resolvePath(g_folderPath, /*isFolder*/ true);
  outlet(1, ["where", "patcher", _getPatcherDir(), "folder", g_folderPath, "resolved", g_folderPathResolved, "suffix", g_scanSuffix]);
}

function help() {
  // Outlet 1 only (safe to connect outlet 0 directly to [coll])
  outlet(1, ["help", "wire", "js outlet 0 -> coll", "js outlet 1 -> print"]);
  outlet(1, ["help", "start_one_file", "ingest /absolute/path/to/file.txt 0 83 83 1"]);
  outlet(1, ["help", "random_folder", "setfolder /absolute/path/to/folder", ";", "scan .txt", ";", "setrandomstart 1", ";", "jump"]);
  outlet(1, ["help", "mode", "Default mode is full (loads the whole file). Use: setmode bank  for 83-voice banks"]);
  outlet(1, ["help", "note", "Do NOT send 'load' to this js. In Max, 'load' loads a JS script, not your data file."]);
}

function setmode(m) {
  if (m === undefined || m === null) return;
  m = String(m).toLowerCase();
  if (m === "full" || m === "bank") {
    g_mode = m;
    outlet(1, ["mode", g_mode]);
  } else {
    outlet(1, ["error", "bad_mode", m, "expected", "full|bank"]);
  }
}

function loadrandom() {
  jump();
}

function jump() {
  if (!g_files || g_files.length === 0) {
    post("partials_bank_to_coll.js: jump has no files. Call setfolder + scan first.\n");
    outlet(1, ["error", "no_files", "hint", "Send: setfolder <folderPath>  then: scan .txt  then: jump"]);
    return;
  }

  if (g_isIngesting) {
    outlet(1, ["jump_skipped", "reason", "ingesting"]);
    return;
  }
  var nowMs = (Date.now ? Date.now() : (new Date()).getTime());
  if (g_jumpMinIntervalMs > 0 && (nowMs - g_lastJumpMs) < g_jumpMinIntervalMs) {
    outlet(1, ["jump_skipped", "reason", "throttle", "dtMs", (nowMs - g_lastJumpMs), "minMs", g_jumpMinIntervalMs]);
    return;
  }
  g_lastJumpMs = nowMs;

  var nextIdx = _pickRandomIndex(g_files.length, g_currentFileIdx, g_avoidRepeat);
  g_currentFileIdx = nextIdx;

  var nextPath = g_files[nextIdx];
  if (g_randomizeStart) {
    // We need partials-count to randomize start. Do a quick header scan.
    var cnt = _readPartialsCount(nextPath);
    if (cnt > 0) {
      g_lastPartialsCount = cnt;
      var maxStart = cnt - g_bankSize;
      if (maxStart < 0) maxStart = 0;
      g_startPartial = _randInt(0, maxStart);
    }
  }

  post("partials_bank_to_coll.js: jump -> " + nextPath + " (startPartial=" + g_startPartial + ")\n");
  outlet(1, ["jump", nextPath, "startPartial", g_startPartial, "index", g_currentFileIdx, "count", g_files.length]);
  ingest(nextPath);
}

function setstart(n) {
  g_startPartial = parseInt(n, 10) || 0;
}

function setbank(n) {
  var v = parseInt(n, 10);
  if (v > 0) g_bankSize = v;
}

function setpoints(n) {
  var v = parseInt(n, 10);
  if (v > 1) g_pointsPerPartial = v;
}

function setresample(n) {
  g_resample = (parseInt(n, 10) ? 1 : 0);
}

function setkeyoffset(n) {
  g_keyOffset = parseInt(n, 10) || 0;
}

function setwindow(n) {
  g_windowEnable = (parseInt(n, 10) ? 1 : 0);
  outlet(1, ["window", g_windowEnable, "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
}

function setwindowstart(n) {
  g_windowStart = Math.max(0, parseInt(n, 10) || 0);
  _clampWindowStartToFile();
  outlet(1, ["window", g_windowEnable, "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
  if (g_windowEnable) applywindow();
}

function setwindowsize(n) {
  var v = parseInt(n, 10) || 0;
  if (v > 1) g_windowSize = v;
  outlet(1, ["window", g_windowEnable, "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
  if (g_windowEnable) applywindow();
}

function setwindowpad(n) {
  g_windowPadHold = (parseInt(n, 10) ? 1 : 0);
  outlet(1, ["window", g_windowEnable, "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
  if (g_windowEnable) applywindow();
}

function nextwindow(step) {
  var s = parseInt(step, 10);
  var inc = (!isNaN(s) && s > 0) ? s : g_windowSize;

  // If we're in window mode and auto-next is enabled, advance to next file when we hit the end.
  if (g_windowEnable && g_autoNext && g_autoNextMode === "window_end") {
    var limit = _windowPointLimit();
    if (limit > 0 && (g_windowStart + inc) >= limit) {
      outlet(1, ["window_end", "start", g_windowStart, "inc", inc, "limit", limit]);
      _maybeScheduleAutoNext();
      return;
    }
  }

  g_windowStart += inc;
  _clampWindowStartToFile();
  outlet(1, ["window", g_windowEnable, "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
  if (g_windowEnable) applywindow();
}

function prevwindow(step) {
  var s = parseInt(step, 10);
  if (!isNaN(s) && s > 0) g_windowStart -= s;
  else g_windowStart -= g_windowSize;
  if (g_windowStart < 0) g_windowStart = 0;
  _clampWindowStartToFile();
  outlet(1, ["window", g_windowEnable, "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
  if (g_windowEnable) applywindow();
}

function applywindow() {
  if (!g_windowEnable) return;
  _applyPointWindowToColl();
}

function clear() {
  outlet(0, "clear");
}

function bang() {
  if (g_bankLoaded) {
    _emitBankToColl();
    outlet(1, ["bang", "reemit"]);
    return;
  }

  if (g_fullLoaded) {
    outlet(1, ["bang", "full_loaded", "hint", "Query your [coll] with a number (partial index) or click your existing dump controls."]);
    return;
  }

  // If nothing is loaded yet, make bang useful:
  // - If we already have a scanned file list, jump to a random file.
  // - Else, if we have a last path, try loading it.
  // - Else, show a clear hint.
  if (g_files && g_files.length > 0) {
    outlet(1, ["bang", "jump"]);
    jump();
    return;
  }

  if (g_lastSourcePath && String(g_lastSourcePath).length > 0) {
    outlet(1, ["bang", "reload", g_lastSourcePath]);
    ingest(g_lastSourcePath);
    return;
  }

  outlet(1, ["error", "nothing_loaded", "hint", "Send either: ingest <filePath> 0 83 83 1  OR: setfolder <folderPath>, then scan .txt, then jump"]);
}

// IMPORTANT (Max js): the message "load" is used by the [js] object to load a JS script.
// So we use "ingest" to load partials data files.
function ingest(path, startPartial, bankSize, pointsPerPartial, resampleFlag) {
  if (path === undefined || path === null) {
    post("partials_bank_to_coll.js: ingest requires a filepath\n");
    return;
  }

  if (startPartial !== undefined) setstart(startPartial);
  if (bankSize !== undefined) setbank(bankSize);
  if (pointsPerPartial !== undefined) setpoints(pointsPerPartial);
  if (resampleFlag !== undefined) setresample(resampleFlag);

  g_lastSourcePath = _resolvePath(String(path), /*isFolder*/ false);
  g_bankData = {};
  g_bankLoaded = false;
  g_fullLoaded = false;
  g_fullTriplets = {};
  if (g_windowEnable) g_windowStart = Math.max(0, parseInt(g_autoDefaultsWindowStart, 10) || 0);
  g_lastMinPoints = 0;
  g_isIngesting = 1;
  if (g_autoNextTask !== null) {
    try { g_autoNextTask.cancel(); } catch (e) {}
  }
  // Reset coll cache if file changes
  if (String(g_lastSourcePath) !== String(g_collCachePath)) {
    g_collCachePath = String(g_lastSourcePath);
    g_collCacheSawPointType = 0;
    g_collCacheBaseKey = 1;
    g_collCacheOffsets = {};
    g_collCacheMaxKeyIndexed = -1;
    g_collCacheLastPos = 0;
    g_collCacheMaxKeyOverall = -1;
  }

  outlet(1, ["ingest", g_lastSourcePath, "mode", g_mode, "startPartial", g_startPartial, "bankSize", g_bankSize, "points", g_pointsPerPartial, "resample", g_resample]);

  var f = new File(g_lastSourcePath, "read");
  if (!f.isopen) {
    post("partials_bank_to_coll.js: failed to open file: " + g_lastSourcePath + "\n");
    outlet(1, ["error", "open_failed", g_lastSourcePath]);
    return;
  }

  // Detect format using the first non-empty line
  var firstNonEmpty = "";
  var probeLines = 0;
  while (f.position < f.eof && probeLines < 50) {
    var pl = f.readline();
    if (pl === null) break;
    probeLines++;
    pl = String(pl).trim();
    if (!pl.length) continue;
    firstNonEmpty = pl;
    break;
  }
  f.position = 0;

  var isParText = (firstNonEmpty === "par-text-partials-format");
  var isCollText = (/^\d+\s*,/.test(firstNonEmpty));

  // Always clear coll before filling it
  outlet(0, "clear");

  if (isCollText && !isParText) {
    _ingestCollTextFile(f);
    f.close();
    return;
  }

  // Default: par-text format
  _ingestParTextFile(f);
  f.close();
  g_isIngesting = 0;
  return;
}

function _startCollFlush(meta) {
  g_collFlushMeta = meta || null;
  if (g_collFlushTask === null) {
    g_collFlushTask = new Task(_collFlushTick, this);
  } else {
    try { g_collFlushTask.cancel(); } catch (e) {}
  }
  g_collFlushTask.interval = 0;
  g_collFlushTask.repeat(1);
}

function _collFlushTick() {
  // Emit a few store messages per tick to keep Max responsive.
  var n = Math.max(1, parseInt(g_collFlushBatch, 10) || 1);
  var sent = 0;
  while (sent < n && g_collFlushQueue.length > 0) {
    var msg = g_collFlushQueue.shift();
    outlet(0, msg);
    sent++;
  }

  if (g_collFlushQueue.length > 0) {
    // Keep flushing
    try { g_collFlushTask.repeat(1); } catch (e) {}
    return;
  }

  // Done: mark ingest finished and emit "loaded" once.
  var meta = g_collFlushMeta || {};
  g_collFlushMeta = null;
  g_isIngesting = 0;

  outlet(1, meta.loadedMsg);
  _emitAvailFromBank();
  g_autoWindowWaitingForLoad = 0;
  if (g_autoWindow && g_autoWindowMode === "timer") _syncAutoWindow();
  g_autoBankWaitingForLoad = 0;
  if (g_autoBank && g_autoBankMode === "timer") _syncAutoBank();
  if (g_autoNextMode === "loaded") _maybeScheduleAutoNext();
}

function _maybeScheduleAutoNext() {
  if (!g_autoNext) return;
  if (!g_files || g_files.length === 0) return;
  if (g_autoNextMode === "loaded" && g_windowEnable) {
    // In window mode, "loaded" is usually too fast; prefer window_end.
    // Still allow it if user explicitly sets the mode.
  }
  // Avoid tight recursive loops; schedule jump in the future.
  try {
    if (g_autoNextTask === null) {
      g_autoNextTask = new Task(_autoNextTick, this);
    } else {
      g_autoNextTask.cancel();
    }
    // Respect jump throttle: if delay < jumpMinInterval, jump() may get skipped.
    var wantDelay = Math.max(0, parseInt(g_autoNextDelayMs, 10) || 0);
    if (g_jumpMinIntervalMs > 0) wantDelay = Math.max(wantDelay, g_jumpMinIntervalMs + 10);
    g_autoNextTask.interval = wantDelay;
    g_autoNextTask.repeat(1);
    outlet(1, ["autonext_scheduled", "in", g_autoNextTask.interval, "ms"]);
  } catch (e) {
    // If Task isn't available for some reason, fall back to immediate jump (still guarded).
    outlet(1, ["autonext_fallback"]);
    jump();
  }
}

function _autoNextTick() {
  // Only proceed if autoplay is still on.
  if (!g_autoNext) return;
  if (!g_files || g_files.length === 0) return;
  // Reset window when switching files
  if (g_windowEnable) g_windowStart = Math.max(0, parseInt(g_autoDefaultsWindowStart, 10) || 0);
  g_autoBankWaitingForLoad = 0;
  jump();
}

function _sliceFlatTriplets(fullFlat) {
  var wantN = Math.max(1, parseInt(g_windowSize, 10) || 1);
  var start = Math.max(0, parseInt(g_windowStart, 10) || 0) * 3;
  var wantLen = wantN * 3;
  var out = new Array(wantLen);

  var lastT = 0.0, lastF = 0.0, lastA = 0.0;
  if (fullFlat && fullFlat.length >= 3) {
    lastT = fullFlat[fullFlat.length - 3];
    lastF = fullFlat[fullFlat.length - 2];
    lastA = fullFlat[fullFlat.length - 1];
  }

  for (var i = 0; i < wantLen; i++) {
    var idx = start + i;
    if (fullFlat && idx < fullFlat.length) {
      out[i] = fullFlat[idx];
    } else {
      if (!g_windowPadHold) {
        out[i] = 0.0;
      } else {
        var m = i % 3;
        out[i] = (m === 0) ? lastT : (m === 1 ? lastF : lastA);
      }
    }
  }
  return out;
}

function _applyPointWindowToColl() {
  var keys = _sortedNumericKeys(g_fullTriplets);
  if (!keys || keys.length === 0) return;

  outlet(0, "clear");
  g_bankData = {};
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i];
    var full = g_fullTriplets[k];
    var win = _sliceFlatTriplets(full);
    g_bankData[k] = win;
    var msg = ["store", k];
    for (var j = 0; j < win.length; j++) msg.push(win[j]);
    outlet(0, msg);
  }
  g_bankLoaded = true;
  g_fullLoaded = false;
  outlet(1, ["window_applied", "start", g_windowStart, "size", g_windowSize, "padHold", g_windowPadHold]);
  _emitAvailFromBank();
}

function _windowPointLimit() {
  // Window advance limit in points.
  // Old behavior used MIN points across voices, which can collapse the limit if any partial is very short.
  // In practice we prefer MAX points across voices and rely on padHold (or zeros) for shorter partials.
  if (g_lastMinPoints > 0) return g_lastMinPoints;
  var keys = _sortedNumericKeys(g_fullTriplets);
  if (!keys || keys.length === 0) return 0;
  var minP = 0;
  var maxP = 0;
  for (var i = 0; i < keys.length; i++) {
    var flat = g_fullTriplets[keys[i]];
    if (!flat) continue;
    var p = Math.floor(flat.length / 3);
    if (p <= 0) continue;
    if (minP === 0 || p < minP) minP = p;
    if (p > maxP) maxP = p;
  }
  // Use max points so window can advance through long partials even if some voices are short.
  var limitP = (maxP > 0 ? maxP : minP);
  g_lastMinPoints = limitP;
  return limitP;
}

function _clampWindowStartToFile() {
  if (!g_windowEnable) return;
  var limit = _windowPointLimit();
  if (limit <= 0) return;
  var maxStart = Math.max(0, limit - g_windowSize);
  if (g_windowStart > maxStart) g_windowStart = maxStart;
}

function _makeProgressReporter(f) {
  var lastMs = 0;
  var lastPos = -1;
  return function(tag, extraA, extraB) {
    if (!g_progressEnabled) return;
    var now = (Date.now ? Date.now() : (new Date()).getTime());
    if ((now - lastMs) < g_progressMinIntervalMs) return;
    // avoid resending if file position hasn't advanced
    if (lastPos === f.position) return;
    lastPos = f.position;
    lastMs = now;
    var frac = 0.0;
    try {
      if (f.eof > 0) frac = Math.max(0.0, Math.min(1.0, f.position / f.eof));
    } catch (e) {
      frac = 0.0;
    }
    var msg = ["progress", String(tag || "read"), frac, "pos", f.position, "eof", f.eof];
    if (extraA !== undefined) msg.push(extraA);
    if (extraB !== undefined) msg.push(extraB);
    outlet(1, msg);
  };
}

function _ingestCollTextFile(f) {
  // Coll text formats we see in this repo:
  // A) With metadata:
  //    1,point-type time frequency amplitude;
  //    2,partials-data;
  //    3,<triplets...>;     // partialIndex 0
  // B) Without metadata:
  //    1,<triplets...>;     // partialIndex 0

  var baseKey = 1;
  var sawPointType = false;
  var maxKeySeen = -1;
  var report = _makeProgressReporter(f);

  // Detect if there's a point-type header at key 1 (cache per file)
  if (g_collCachePath && String(g_lastSourcePath) === String(g_collCachePath) && (g_collCacheSawPointType === 1 || g_collCacheSawPointType === 0)) {
    // If we already indexed some keys, trust cached header state.
    if (g_collCacheMaxKeyIndexed >= 0) {
      sawPointType = (g_collCacheSawPointType ? true : false);
      baseKey = parseInt(g_collCacheBaseKey, 10) || 1;
    } else {
      var firstPassLines = 0;
      while (f.position < f.eof && firstPassLines < 20) {
        var line = f.readline();
        if (line === null) break;
        firstPassLines++;
        line = String(line).trim();
        if (!line.length) continue;
        var m0 = line.match(/^(\d+)\s*,\s*(.*)$/);
        if (!m0) continue;
        var k0 = parseInt(m0[1], 10);
        var payload0 = String(m0[2]).replace(/;+\s*$/, "").trim();
        if (k0 === 1 && payload0.indexOf("point-type") === 0) {
          sawPointType = true;
          break;
        }
        report("probe");
      }
      f.position = 0;
      baseKey = sawPointType ? 3 : 1;
      g_collCacheSawPointType = (sawPointType ? 1 : 0);
      g_collCacheBaseKey = baseKey;
    }
  }

  // In full mode, store keys as partialIndex (0-based): outKey = key - baseKey (+ keyOffset)
  // In bank mode, store only key range [baseKey+startPartial .. baseKey+startPartial+bankSize-1] into keys keyOffset..keyOffset+bankSize-1
  var wantStartKey = baseKey + g_startPartial;
  var wantEndKey = baseKey + g_startPartial + g_bankSize - 1;

  // If in bank mode, try to seek directly to the start key using cached offsets.
  if (g_mode === "bank") {
    var startPos = g_collCacheOffsets[wantStartKey];
    if (startPos !== undefined && startPos !== null) {
      try {
        f.position = startPos;
      } catch (e) {
        f.position = 0;
      }
    } else if (g_collCacheMaxKeyIndexed >= 0 && g_collCacheLastPos > 0) {
      // Seek to last known position and index forward from there (useful for sequential autobank paging).
      try {
        f.position = g_collCacheLastPos;
      } catch (e2) {
        f.position = 0;
      }
    } else {
      f.position = 0;
    }
  }

  // Estimate max key from tail once (fast) so partialsCount stays correct without full scan.
  if (g_collCacheMaxKeyOverall < 0) {
    try {
      g_collCacheMaxKeyOverall = _coll_tail_max_key(f, sawPointType);
    } catch (e3) {
      g_collCacheMaxKeyOverall = -1;
    }
    // restore to current scanning pos (tail scan moves position)
    // We'll reset below to current f.position by keeping local curPos.
  }

  // Build coll store messages into a queue; we'll flush them in small batches.
  g_collFlushQueue = [];

  while (f.position < f.eof) {
    var posBefore = f.position;
    var lineC = f.readline();
    if (lineC === null) break;
    lineC = String(lineC).trim();
    if (!lineC.length) continue;

    var m = lineC.match(/^(\d+)\s*,\s*(.*)$/);
    if (!m) continue;
    var key = parseInt(m[1], 10);
    if (!(key >= 0)) continue;
    if (key > maxKeySeen) maxKeySeen = key;

    // Cache file offset for this key if not already known
    if (g_collCacheOffsets[key] === undefined) {
      g_collCacheOffsets[key] = posBefore;
      if (key > g_collCacheMaxKeyIndexed) {
        g_collCacheMaxKeyIndexed = key;
        g_collCacheLastPos = posBefore;
      }
    }

    // Skip metadata keys if present
    if (sawPointType && (key === 1 || key === 2)) continue;

    if (g_mode === "bank") {
      if (key < wantStartKey || key > wantEndKey) continue;
    } else {
      if (key < baseKey) continue;
    }

    // Strip trailing ';' and split into numeric atoms
    var payload = String(m[2]).replace(/;+\s*$/, "").trim();
    if (!payload.length) continue;

    var atoms = payload.split(/\s+/);
    var nTrip = Math.floor(atoms.length / 3);
    if (nTrip <= 1) continue;

    var tArr = new Array(nTrip);
    var fArr = new Array(nTrip);
    var aArr = new Array(nTrip);
    var wi = 0;
    for (var i = 0; i < nTrip; i++) {
      tArr[i] = parseFloat(atoms[wi++]);
      fArr[i] = parseFloat(atoms[wi++]);
      aArr[i] = parseFloat(atoms[wi++]);
    }

    var flatFull;
    if (g_resample) flatFull = _resampleToFlatTriplets(tArr, fArr, aArr, tArr[0], tArr[nTrip - 1], g_pointsPerPartial);
    else flatFull = _rawToFlatTriplets(tArr, fArr, aArr, nTrip);

    var outKey;
    if (g_mode === "bank") {
      outKey = g_keyOffset + (key - wantStartKey);
      if (g_windowEnable) {
        g_fullTriplets[outKey] = flatFull;
        g_bankData[outKey] = _sliceFlatTriplets(flatFull);
      } else {
        g_bankData[outKey] = flatFull;
      }
    } else {
      outKey = g_keyOffset + (key - baseKey);
      if (g_windowEnable) {
        g_fullTriplets[outKey] = flatFull;
        g_bankData[outKey] = _sliceFlatTriplets(flatFull);
      }
    }

    // Queue store for chunked flush (avoids UI stalls)
    var msg = ["store", outKey];
    var sendFlat = (g_windowEnable ? g_bankData[outKey] : flatFull);
    for (var j = 0; j < sendFlat.length; j++) msg.push(sendFlat[j]);
    g_collFlushQueue.push(msg);

    // progress (rate-limited)
    report("coll", "key", outKey);

    // In bank mode, keys are ordered; once we passed the end of the window, we can stop.
    if (g_mode === "bank" && key >= wantEndKey) {
      break;
    }
  }

  // Estimate partials count from max key seen
  if (g_collCacheMaxKeyOverall >= baseKey) {
    g_lastPartialsCount = (g_collCacheMaxKeyOverall - baseKey + 1);
  } else if (maxKeySeen >= baseKey) {
    g_lastPartialsCount = (maxKeySeen - baseKey + 1);
  } else {
    g_lastPartialsCount = -1;
  }

  if (g_windowEnable) {
    g_bankLoaded = true;
    g_fullLoaded = false;
  } else if (g_mode === "bank") {
    g_bankLoaded = true;
    g_fullLoaded = false;
  } else {
    g_bankLoaded = false;
    g_fullLoaded = true;
  }

  // Emit "loaded" only after coll flush completes (prevents UI thrash).
  var loadedMsg = ["loaded", g_lastSourcePath, "format", "coll", "mode", g_mode, "startPartial", g_startPartial, "bankSize", g_bankSize, "points", g_pointsPerPartial, "resample", g_resample, "partialsCount", g_lastPartialsCount, "baseKey", baseKey, "window", g_windowEnable, "wStart", g_windowStart, "wSize", g_windowSize];
  _startCollFlush({ loadedMsg: loadedMsg });
}

function _coll_tail_max_key(f, sawPointType) {
  // Fast max-key estimate by scanning last ~64KB of the file.
  // Returns the maximum numeric key found, or -1.
  var oldPos = f.position;
  var maxK = -1;
  try {
    var start = f.eof - 65536;
    if (start < 0) start = 0;
    f.position = start;
    while (f.position < f.eof) {
      var p0 = f.position;
      var line = f.readline();
      if (line === null) break;
      line = String(line).trim();
      if (!line.length) continue;
      var m = line.match(/^(\d+)\s*,\s*(.*)$/);
      if (!m) continue;
      var key = parseInt(m[1], 10);
      if (!(key >= 0)) continue;
      if (sawPointType && (key === 1 || key === 2)) continue;
      if (key > maxK) maxK = key;
    }
  } catch (e) {
    maxK = -1;
  }
  try { f.position = oldPos; } catch (e2) {}
  return maxK;
}

function _ingestParTextFile(f) {
  var wantStart = g_startPartial;
  var wantEnd = g_startPartial + g_bankSize - 1;
  if (wantEnd < wantStart) {
    post("partials_bank_to_coll.js: invalid bank range\n");
    outlet(1, ["error", "invalid_bank_range"]);
    return;
  }

  // Seek to "partials-data" and read partials-count if present
  var inData = false;
  g_lastPartialsCount = -1;
  var report = _makeProgressReporter(f);
  while (f.position < f.eof) {
    var line0 = f.readline();
    if (line0 === null) break;
    line0 = String(line0).trim();
    if (line0.indexOf("partials-count") === 0) {
      var parts = line0.split(/\s+/);
      if (parts.length >= 2) {
        var c = parseInt(parts[1], 10);
        if (c > 0) g_lastPartialsCount = c;
      }
    }
    if (line0 === "partials-data") {
      inData = true;
      break;
    }
    report("seek");
  }
  if (!inData) {
    post("partials_bank_to_coll.js: did not find 'partials-data' section\n");
    outlet(1, ["error", "no_partials_data", g_lastSourcePath]);
    return;
  }

  // Streaming parse state
  var pending = [];
  var needTripletTokens = 0; // number of numeric tokens still needed for current partial (3*pointCount)
  var curPartialId = -1;
  var curPointCount = 0;
  var curStartT = 0.0;
  var curEndT = 0.0;
  var capture = false;
  var rawT = null, rawF = null, rawA = null;
  var writePos = 0;

  function finishPartialIfReady() {
    if (needTripletTokens !== 0) return;
    if (!capture) return;

    var flatFull;
    if (g_resample) flatFull = _resampleToFlatTriplets(rawT, rawF, rawA, curStartT, curEndT, g_pointsPerPartial);
    else flatFull = _rawToFlatTriplets(rawT, rawF, rawA, curPointCount);

    // Determine output key and store/emit
    var outKey;
    if (g_mode === "bank") {
      var voiceIdx = (curPartialId - wantStart);
      outKey = g_keyOffset + voiceIdx;
      if (g_windowEnable) {
        g_fullTriplets[outKey] = flatFull;
        g_bankData[outKey] = _sliceFlatTriplets(flatFull);
      } else {
        g_bankData[outKey] = flatFull;
      }
    } else {
      outKey = g_keyOffset + curPartialId;
      if (g_windowEnable) {
        g_fullTriplets[outKey] = flatFull;
        g_bankData[outKey] = _sliceFlatTriplets(flatFull);
      }
    }

    var msg = ["store", outKey];
    var sendFlat = (g_windowEnable ? g_bankData[outKey] : flatFull);
    for (var j = 0; j < sendFlat.length; j++) msg.push(sendFlat[j]);
    outlet(0, msg);

    // progress (rate-limited)
    report("partial", "id", curPartialId);
  }

  // ... existing streaming parse continues ...

  while (f.position < f.eof) {
    var line = f.readline();
    if (line === null) break;
    line = String(line).trim();
    if (line.length === 0) continue;

    var toks = line.split(/\s+/);

    // Detect header line: "<int> <int> <float> <float>"
    if (toks.length >= 4 && _isIntegerToken(toks[0]) && _isIntegerToken(toks[1])) {
      // If we were in the middle of a partial, try finishing (defensive).
      if (needTripletTokens === 0 && capture) {
        finishPartialIfReady();
      }

      curPartialId = parseInt(toks[0], 10);
      curPointCount = parseInt(toks[1], 10);
      curStartT = parseFloat(toks[2]);
      curEndT = parseFloat(toks[3]);

      needTripletTokens = curPointCount * 3;
      writePos = 0;

      if (g_mode === "bank") capture = (curPartialId >= wantStart && curPartialId <= wantEnd);
      else capture = true;
      if (capture) {
        rawT = new Array(curPointCount);
        rawF = new Array(curPointCount);
        rawA = new Array(curPointCount);
      } else {
        rawT = rawF = rawA = null;
      }

      // Clear any pending tokens (shouldn't exist between headers, but keep it safe).
      pending = [];
      continue;
    }

    // Data line: accumulate numeric tokens
    if (needTripletTokens <= 0) {
      // We're not currently inside a partial (or header missing). Ignore.
      continue;
    }

    for (var i = 0; i < toks.length; i++) {
      if (toks[i].length === 0) continue;
      pending.push(toks[i]);
    }

    // Consume as many triplets as possible
    while (needTripletTokens >= 3 && pending.length >= 3) {
      var t = parseFloat(pending.shift());
      var fr = parseFloat(pending.shift());
      var am = parseFloat(pending.shift());
      needTripletTokens -= 3;

      if (capture) {
        rawT[writePos] = t;
        rawF[writePos] = fr;
        rawA[writePos] = am;
        writePos++;
      }
    }

    if (needTripletTokens === 0) {
      finishPartialIfReady();
      if (g_mode === "bank" && curPartialId >= wantEnd) break; // we have everything we want
    }
  }

  // Validate we got enough in bank mode
  if (g_mode === "bank") {
    var expected = g_bankSize;
    var got = 0;
    for (var k in g_bankData) if (g_bankData.hasOwnProperty(k)) got++;
    if (got < expected) {
      post("partials_bank_to_coll.js: warning: requested " + expected + " partials, parsed " + got + "\n");
    }
    g_bankLoaded = true;
    g_fullLoaded = false;
  } else {
    g_bankLoaded = false;
    g_fullLoaded = true;
  }

  if (g_windowEnable) {
    g_bankLoaded = true;
    g_fullLoaded = false;
  }
  outlet(1, ["loaded", g_lastSourcePath, "format", "par-text", "mode", g_mode, "startPartial", g_startPartial, "bankSize", g_bankSize, "points", g_pointsPerPartial, "resample", g_resample, "partialsCount", g_lastPartialsCount, "window", g_windowEnable, "wStart", g_windowStart, "wSize", g_windowSize]);
  _emitAvailFromBank();
  g_autoWindowWaitingForLoad = 0;
  if (g_autoWindow && g_autoWindowMode === "timer") _syncAutoWindow();
  g_autoBankWaitingForLoad = 0;
  if (g_autoBank && g_autoBankMode === "timer") _syncAutoBank();
  if (g_autoNextMode === "loaded") _maybeScheduleAutoNext();
}

function exportcoll(outfile) {
  if (!g_bankLoaded) {
    post("partials_bank_to_coll.js: exportcoll called but no bank loaded. Call ingest first.\n");
    return;
  }
  if (outfile === undefined || outfile === null) {
    post("partials_bank_to_coll.js: exportcoll requires an output filepath\n");
    return;
  }

  var outPath = String(outfile);
  var wf = new File(outPath, "write");
  if (!wf.isopen) {
    post("partials_bank_to_coll.js: failed to open for write: " + outPath + "\n");
    return;
  }

  // Minimal metadata, similar to your tan_* files
  wf.writeline("1,point-type time frequency amplitude;");
  wf.writeline("2,partials-data;");

  // Write keys in ascending order
  // For compatibility with your existing tan_* files:
  //  - key 1: point-type
  //  - key 2: partials-data
  //  - key 3.. : partial triplets
  for (var i = 0; i < g_bankSize; i++) {
    var inKey = g_keyOffset + i;
    var flat = g_bankData[inKey];
    if (!flat) continue;
    wf.writeline(_collLineFromFlat(i + 3, flat));
  }

  wf.close();
  post("partials_bank_to_coll.js: wrote bank to " + outPath + "\n");
  outlet(1, ["wrote", outPath]);
}

// -----------------------------
// Helpers
// -----------------------------

function _emitBankToColl() {
  var keys = _sortedNumericKeys(g_bankData);
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    var flat = g_bankData[key];
    var msg = ["store", key];
    for (var j = 0; j < flat.length; j++) msg.push(flat[j]);
    outlet(0, msg);
  }
}

function _emitAvailFromBank() {
  if (!g_emitAvail) return;
  // Compute "availability" per voice from current published bank data.
  // We use max amplitude across the current window for each key.
  var n = parseInt(g_bankSize, 10) || 0;
  if (n < 1) n = 1;
  var out = new Array(n);
  for (var i = 0; i < n; i++) {
    var k = g_keyOffset + i;
    var flat = g_bankData[k];
    var maxA = 0.0;
    if (flat && flat.length >= 3) {
      for (var j = 2; j < flat.length; j += 3) {
        var a = parseFloat(flat[j]);
        if (!isNaN(a) && a > maxA) maxA = a;
      }
    }
    out[i] = maxA;
  }
  outlet(1, ["avail", n].concat(out));
}

function _isIntegerToken(s) {
  // Accept "0", "123", "-1" but reject floats like "0.0000"
  return /^-?\d+$/.test(String(s));
}

function _rawToFlatTriplets(tArr, fArr, aArr, n) {
  var out = new Array(n * 3);
  var p = 0;
  for (var i = 0; i < n; i++) {
    out[p++] = tArr[i];
    out[p++] = fArr[i];
    out[p++] = aArr[i];
  }
  return out;
}

function _resampleToFlatTriplets(tArr, fArr, aArr, tStart, tEnd, points) {
  if (!points || points < 2) points = 2;
  var n = tArr.length;
  if (n <= 0) return [];

  // If file-provided bounds are weird, infer from data.
  var t0 = (isFinite(tStart) ? tStart : tArr[0]);
  var t1 = (isFinite(tEnd) ? tEnd : tArr[n - 1]);
  if (!(t1 > t0)) {
    t0 = tArr[0];
    t1 = tArr[n - 1];
    if (!(t1 > t0)) t1 = t0 + 0.001;
  }

  var out = new Array(points * 3);
  var p = 0;
  var idx = 0;
  for (var i = 0; i < points; i++) {
    var u = (points === 1) ? 0.0 : (i / (points - 1));
    var t = t0 + (t1 - t0) * u;

    // advance idx to the segment containing t
    while (idx < n - 2 && tArr[idx + 1] < t) idx++;

    var tA = tArr[idx];
    var tB = tArr[idx + 1];
    var fA = fArr[idx];
    var fB = fArr[idx + 1];
    var aA = aArr[idx];
    var aB = aArr[idx + 1];

    var alpha;
    if (!(tB > tA)) alpha = 0.0;
    else alpha = (t - tA) / (tB - tA);

    var f = fA + (fB - fA) * alpha;
    var a = aA + (aB - aA) * alpha;

    out[p++] = t;
    out[p++] = f;
    out[p++] = a;
  }
  return out;
}

function _sortedNumericKeys(obj) {
  var keys = [];
  for (var k in obj) {
    if (obj.hasOwnProperty(k)) keys.push(parseInt(k, 10));
  }
  keys.sort(function(a, b) { return a - b; });
  return keys;
}

function _collLineFromFlat(key, flat) {
  // coll text format: "<key>,<atoms...>;"
  // Keep it simple: one big line per key.
  var s = "" + key + ",";
  for (var i = 0; i < flat.length; i++) {
    if (i) s += " ";
    s += flat[i];
  }
  s += ";";
  return s;
}

function _scanFolderFiles(folderPath, suffix) {
  var out = [];
  try {
    var fo = new Folder(folderPath);
    while (!fo.end) {
      var nm = fo.filename;
      if (nm && nm.length) {
        if (suffix && suffix.length) {
          if (_endsWith(nm, suffix)) out.push(folderPath + "/" + nm);
        } else {
          out.push(folderPath + "/" + nm);
        }
      }
      fo.next();
    }
    fo.close();
  } catch (e) {
    post("partials_bank_to_coll.js: scan error: " + e + "\n");
    outlet(1, ["error", "scan_exception", String(e)]);
  }
  out.sort();
  return out;
}

function _endsWith(s, suf) {
  s = String(s);
  suf = String(suf);
  if (suf.length > s.length) return false;
  return s.slice(s.length - suf.length) === suf;
}

function _pickRandomIndex(n, avoidIdx, avoid) {
  if (n <= 1) return 0;
  var idx = _randInt(0, n - 1);
  if (!avoid) return idx;
  if (avoidIdx < 0) return idx;
  // Try a few times to avoid repeat
  for (var i = 0; i < 8 && idx === avoidIdx; i++) {
    idx = _randInt(0, n - 1);
  }
  if (idx === avoidIdx) idx = (avoidIdx + 1) % n;
  return idx;
}

function _randInt(minIncl, maxIncl) {
  var a = Math.floor(minIncl);
  var b = Math.floor(maxIncl);
  if (b < a) {
    var t = a;
    a = b;
    b = t;
  }
  return a + Math.floor(Math.random() * (b - a + 1));
}

function _readPartialsCount(path) {
  var f = new File(_resolvePath(String(path), /*isFolder*/ false), "read");
  if (!f.isopen) return -1;
  var count = -1;
  var lines = 0;
  while (f.position < f.eof && lines < 200) {
    var line = f.readline();
    if (line === null) break;
    lines++;
    line = String(line).trim();
    if (line.indexOf("partials-count") === 0) {
      var parts = line.split(/\s+/);
      if (parts.length >= 2) {
        var c = parseInt(parts[1], 10);
        if (c > 0) count = c;
      }
      break;
    }
    if (line === "partials-data") break;
  }
  f.close();
  return count;
}

function _ensureDefaultFolder() {
  // If user didn't set a folder, default to the patcher's directory.
  if (!g_folderPath || g_folderPath.length === 0) {
    g_folderPath = _getPatcherDir();
    g_folderPathResolved = g_folderPath;
  }
}

function _getPatcherDir() {
  // Try to locate the directory containing the Max patcher.
  // If the patch isn't saved yet, this may be empty; in that case return "."
  try {
    if (this && this.patcher && this.patcher.filepath) {
      var fp = String(this.patcher.filepath);
      if (fp && fp.length) return fp;
    }
  } catch (e) {}
  return ".";
}

function _resolvePath(p, isFolder) {
  p = String(p);
  if (!p.length) return p;

  // Expand "~/" to home (macOS)
  if (p.indexOf("~/") === 0) {
    try {
      var home = "";
      // Max doesn't expose env vars directly; use Folder.userpath as a close default.
      // Folder.userpath usually points to ~/Documents/Max 9/ (or similar), so strip after "/Documents".
      var up = Folder.userpath ? String(Folder.userpath) : "";
      var ix = up.indexOf("/Documents");
      if (ix > 0) home = up.slice(0, ix);
      if (home.length) p = home + p.slice(1); // replace leading "~"
    } catch (e) {}
  }

  // If already absolute, return as-is
  if (p.indexOf("/") === 0 || /^[A-Za-z]:[\\/]/.test(p)) return p;

  // Otherwise, resolve relative to patcher dir (when possible)
  var base = _getPatcherDir();
  if (!base || base === ".") return p;

  // If base already ends with "/", don't double it
  if (_endsWith(base, "/")) return base + p;
  return base + "/" + p;
}


