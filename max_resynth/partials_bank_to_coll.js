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
  outlet(1, ["autonext", g_autoNext, "delayMs", g_autoNextDelayMs]);
}

function setautonextdelay(ms) {
  var v = parseInt(ms, 10);
  if (isNaN(v)) return;
  g_autoNextDelayMs = Math.max(0, v);
  outlet(1, ["autonext", g_autoNext, "delayMs", g_autoNextDelayMs]);
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
  return;
}

function _maybeScheduleAutoNext() {
  if (!g_autoNext) return;
  if (!g_files || g_files.length === 0) return;
  // Avoid tight recursive loops; schedule jump in the future.
  try {
    if (g_autoNextTask === null) {
      g_autoNextTask = new Task(_autoNextTick, this);
    } else {
      g_autoNextTask.cancel();
    }
    g_autoNextTask.interval = Math.max(0, parseInt(g_autoNextDelayMs, 10) || 0);
    g_autoNextTask.repeat(1);
    outlet(1, ["autonext_scheduled", "in", g_autoNextDelayMs, "ms"]);
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
  jump();
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

  // First pass: detect if there's a point-type header at key 1
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

  // In full mode, store keys as partialIndex (0-based): outKey = key - baseKey (+ keyOffset)
  // In bank mode, store only key range [baseKey+startPartial .. baseKey+startPartial+bankSize-1] into keys keyOffset..keyOffset+bankSize-1
  var wantStartKey = baseKey + g_startPartial;
  var wantEndKey = baseKey + g_startPartial + g_bankSize - 1;

  while (f.position < f.eof) {
    var lineC = f.readline();
    if (lineC === null) break;
    lineC = String(lineC).trim();
    if (!lineC.length) continue;

    var m = lineC.match(/^(\d+)\s*,\s*(.*)$/);
    if (!m) continue;
    var key = parseInt(m[1], 10);
    if (!(key >= 0)) continue;
    if (key > maxKeySeen) maxKeySeen = key;

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

    var flat;
    if (g_resample) {
      flat = _resampleToFlatTriplets(tArr, fArr, aArr, tArr[0], tArr[nTrip - 1], g_pointsPerPartial);
    } else {
      flat = _rawToFlatTriplets(tArr, fArr, aArr, nTrip);
    }

    var outKey;
    if (g_mode === "bank") {
      outKey = g_keyOffset + (key - wantStartKey);
      g_bankData[outKey] = flat;
    } else {
      outKey = g_keyOffset + (key - baseKey);
    }

    // Store into coll immediately
    var msg = ["store", outKey];
    for (var j = 0; j < flat.length; j++) msg.push(flat[j]);
    outlet(0, msg);

    // progress (rate-limited)
    report("coll", "key", outKey);
  }

  // Estimate partials count from max key seen
  if (maxKeySeen >= baseKey) g_lastPartialsCount = (maxKeySeen - baseKey + 1);
  else g_lastPartialsCount = -1;

  if (g_mode === "bank") {
    g_bankLoaded = true;
    g_fullLoaded = false;
  } else {
    g_bankLoaded = false;
    g_fullLoaded = true;
  }

  outlet(1, ["loaded", g_lastSourcePath, "format", "coll", "mode", g_mode, "startPartial", g_startPartial, "bankSize", g_bankSize, "points", g_pointsPerPartial, "resample", g_resample, "partialsCount", g_lastPartialsCount, "baseKey", baseKey]);
  _maybeScheduleAutoNext();
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

    var flat;
    if (g_resample) {
      flat = _resampleToFlatTriplets(rawT, rawF, rawA, curStartT, curEndT, g_pointsPerPartial);
    } else {
      flat = _rawToFlatTriplets(rawT, rawF, rawA, curPointCount);
    }

    // Determine output key and store/emit
    var outKey;
    if (g_mode === "bank") {
      var voiceIdx = (curPartialId - wantStart);
      outKey = g_keyOffset + voiceIdx;
      g_bankData[outKey] = flat;
    } else {
      outKey = g_keyOffset + curPartialId;
    }

    var msg = ["store", outKey];
    for (var j = 0; j < flat.length; j++) msg.push(flat[j]);
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

  outlet(1, ["loaded", g_lastSourcePath, "format", "par-text", "mode", g_mode, "startPartial", g_startPartial, "bankSize", g_bankSize, "points", g_pointsPerPartial, "resample", g_resample, "partialsCount", g_lastPartialsCount]);
  _maybeScheduleAutoNext();
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


