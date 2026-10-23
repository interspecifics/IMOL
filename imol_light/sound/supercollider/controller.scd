// Control functions are separated from boot so they can be checked without audio.
(
var state = ~imol;
state[\tracks] = IdentityDictionary.new;
state[\layers] = IdentityDictionary.new;
state[\levels] = (spectral: state[\config][\spectralLevel],
    granular: state[\config][\granularLevel], groove: state[\config][\grooveLevel],
    reflection: state[\config][\reflectionLevel] ? 0.18);
state[\bank] = 0;
state[\audioId] = nil;
state[\activeBanks] = [];
state[\eventCount] = 0;
state[\lastState] = nil;
state[\lastEvent] = 0;
state[\oscKeys] = List.new;
state[\channelNames] = [\spectral, \granular, \groove, \reflection];
state[\muted] = IdentitySet.new;
state[\solo] = nil;
state[\dry] = IdentitySet.new;
state[\channelNodes] = IdentityDictionary.new;
state[\spectralStatus] = "Esperando audio del score";

state[\updateMix] = {
    state[\channelNames].do { |kind|
        var audible = state[\muted].includes(kind).not and: {
            state[\solo].isNil or: { state[\solo] == kind }
        };
        if(state[\channelNodes][kind].notNil) { state[\channelNodes][kind].set(\level, audible.binaryValue) };
    };
};
state[\setLevel] = { |kind, level|
    state[\levels][kind] = level.clip(0, 0.5);
    if([\spectral, \reflection].includes(kind)) {
        if(state[kind].notNil) { state[kind].set(\amp, state[\levels][kind]) };
    } { state[\updateLayer].value(kind) };
};
state[\setDry] = { |kind, enabled|
    if(enabled) { state[\dry].add(kind) } { state[\dry].remove(kind) };
    if(kind == \spectral) {
        if(state[\spectralFx].notNil) { state[\spectralFx].set(\wet, if(enabled) { 0 } { 0.35 }) };
    } { state[\updateLayer].value(kind) };
};

state[\updateReflection] = { |values|
    state[\reflectionValues] = values;
    if(state[\reflection].notNil) {
        state[\reflection].set(\x, values[0], \y, values[1], \brightness, values[2],
            \size, values[3], \velocity, values[4], \t_update, 1);
    };
};

state[\applyBank] = {
    var banks = state[\activeBanks];
    if(state[\spectral].notNil) {
        if(banks.isEmpty) {
            state[\spectral].setn(\weights, Array.fill(83, 0));
        } {
            var bank = banks[state[\bank]];
            state[\spectral].setn(\freqs, bank[\freqs], \weights, bank[\amps]);
        };
    };
    state[\bankAppliedAt] = Main.elapsedTime;
};

state[\selectAudio] = { |identifier|
    var changed = state[\audioId] != identifier;
    // Heartbeats must not reset the evolving bank. Retry a missing file so a
    // newly generated bank can be picked up without restarting the engine.
    if(changed or: { state[\activeBanks].isEmpty }) {
        var track, path;
        var safe = identifier.notEmpty and: { identifier.size <= 180 } and: {
            identifier.every { |c| "abcdefghijklmnopqrstuvwxyz0123456789-_".includes(c) }
        };
        state[\audioId] = identifier;
        state[\activeBanks] = [];
        state[\bank] = 0;
        state[\eventCount] = 0;
        state[\lastState] = nil;
        state[\spectralStatus] = if(identifier.isEmpty) { "Sin audio / cargando" } { "Parciales no disponibles" };
        state[\partialPath] = "";
        if(safe and: { state[\root].notNil }) {
            path = state[\root] +/+ "sound/data/partials" +/+ (identifier ++ ".scd");
            state[\partialPath] = path;
            if(PathName(path).isFile) {
                try { track = path.load } { |error| error.reportError };
                if(track.isKindOf(Dictionary) and: { track[\id] == identifier } and: {
                    track[\banks].isArray and: { track[\banks].notEmpty }
                } and: {
                    track[\banks].every { |bank|
                        bank.isKindOf(Dictionary) and: { [\freqs, \amps].every { |key|
                            bank[key].isArray and: { bank[key].size == 83 } and: {
                                bank[key].every { |v| v.isNumber and: { v.isNaN.not } and: {
                                    if(key == \freqs) { (v >= 20) and: { v <= 18000 } }
                                    { (v >= 0) and: { v <= 1 } }
                                } }
                            }
                        } }
                    }
                }) {
                    state[\activeBanks] = track[\banks];
                    state[\spectralStatus] = "Parciales cargados";
                };
            };
        };
        state[\applyBank].value;
        if(changed) {
            if(state[\activeBanks].notEmpty) {
                ("IMOL partials: " ++ identifier).postln;
            } {
                if(identifier.notEmpty) { ("IMOL: no valid partials for " ++ identifier ++ "; spectral layer muted").warn };
            };
        };
    };
};

state[\interpolate] = { |rows, value|
    var position = value.clip(1, rows.size) - 1;
    var lo = position.floor.asInteger;
    var hi = (lo + 1).min(rows.size - 1);
    var mix = position - lo;
    var result = IdentityDictionary.new;
    rows[lo].keysValuesDo { |key, val|
        result[key] = if(key == \sample) {
            rows[position.round.asInteger][key].asInteger
        } {
            val.blend(rows[hi][key], mix)
        };
    };
    result
};

state[\controls] = { |kind|
    var row = state[\layers][kind][\scene].copy;
    var e = state[\tracks][\E];
    var b = state[\tracks][\B];
    var a = state[\tracks][\A];
    row.removeAt(\sample);
    if(kind == \granular) {
        var track = e ? a;
        var scene = ((state[\sceneValue] ? 1) - 1).linlin(0, 13, 0, 1);
        var size = if(track.isNil) { 0.25 } { (track[5].sqrt * 2).clip(0, 1) };
        var motion = if(track.isNil) { 0 } { ((track[6].squared + track[7].squared).sqrt * 4).clip(0, 1) };
        var y = if(track.isNil) { scene } { track[2] };
        var rate = y.linexp(0, 1, 0.45, 0.9);
        // Keep archived Max scenes intact; reinterpret only the live granular voice.
        row = (density: 0.35 + (size * 0.85) + (motion * 0.6),
            position: if(track.isNil) { scene.linlin(0, 1, 0.15, 0.85) } { track[1] },
            spread: 0.015 + (motion * 0.06),
            durLo: 0.45 + (size * 0.45), durHi: 1 + (size * 0.8),
            rateLo: rate * 0.97, rateHi: rate * 1.03,
            cutoff: y.linexp(0, 1, 800, 3500),
            width: if(b.isNil) { 0.6 } { b[3].linlin(0, 1, 0.2, 0.85) });
    } {
        if(e.notNil) {
            row[\panBase] = e[1]; row[\panStep] = e[2];
            row[\rateBase] = e[3]; row[\rateStep] = e[4];
        };
    };
    if((kind == \groove) and: { a.notNil }) { row[\pitchRatio] = a[5].linexp(0, 1, 0.5, 2) };
    // Effect parameters go to separate nodes, not the source SynthDef.
    [\delay, \decay, \wet, \damp].do { |key| row.removeAt(key) };
    row[\amp] = state[\levels][kind];
    row.asPairs
};

state[\updateLayer] = { |kind|
    var layer = state[\layers][kind];
    var b = state[\tracks][\B];
    var c = state[\tracks][\C];
    var a = state[\tracks][\A];
    if(layer.notNil) {
        if(layer[\node].notNil) { layer[\node].set(*state[\controls].value(kind)) };
        if(layer[\fx].notNil) {
            layer[\fx].set(\delay, layer[\scene][\delay], \decay, layer[\scene][\decay],
                \wet, if(state[\dry].includes(kind)) { 0 } { if(kind == \granular) { 0.3 } { layer[\scene][\wet] } },
                \diffuse, (kind == \granular).binaryValue,
                \damp, if(c.isNil) { layer[\scene][\damp] } { c[2] },
                \feedback, if(b.isNil) { 0.35 } { b[2].clip(0, 0.85) },
                \width, if(b.isNil) { 0.6 } { b[3] });
            if((kind == \groove) and: { a.notNil }) {
                layer[\fx].set(\delay, a[2].linlin(0, 1, 0.005, 1.5), \feedback, a[4] * 0.8);
            };
        };
    };
};

state[\selectSample] = { |kind, index|
    var layer = state[\layers][kind];
    var path = state[\audioFolder] +/+ state[\data][\files][index];
    if(layer[\requested] != index) {
        layer[\requested] = index;
        layer[\sampleStatus] = "Cargando";
        layer[\version] = layer[\version] + 1;
        if(PathName(path).isFile.not) {
            layer[\sampleStatus] = "Archivo ausente";
            ("IMOL: missing sample " ++ path).warn;
        } {
            var version = layer[\version];
            var soundFile = SoundFile.openRead(path);
            if(soundFile.isNil) {
                layer[\sampleStatus] = "Error de lectura";
                ("IMOL: cannot read " ++ path).warn;
            } {
                var frames = (soundFile.sampleRate * state[\config][\sampleSeconds]).asInteger.min(soundFile.numFrames);
                soundFile.close;
                Buffer.readChannel(state[\server], path, 0, frames, [0], { |buffer|
                    if(state[\running] and: { layer[\version] == version }) {
                        var oldNode = layer[\node];
                        var oldBuffer = layer[\buffer];
                        var name = if(kind == \granular) { \imolGranular } { \imolGroove };
                        var args = [\out, layer[\bus].index, \buf, buffer.bufnum]
                            ++ state[\controls].value(kind);
                        layer[\buffer] = buffer;
                        layer[\loadedSample] = state[\data][\files][index];
                        layer[\sampleStatus] = "Cargado";
                        layer[\node] = Synth.head(state[\sources], name, args);
                        if(oldNode.notNil) { oldNode.set(\gate, 0) };
                        if(oldBuffer.notNil) {
                            // Granular release is 2.5 s; retain its sample until the node ends.
                            SystemClock.sched(if(kind == \granular) { 3.0 } { 1.0 }, { oldBuffer.free; nil });
                        };
                    } {
                        buffer.free;
                    };
                });
            };
        };
    };
};

state[\applyScene] = { |value|
    state[\sceneValue] = value;
    [\granular, \groove].do { |kind|
        var layer = state[\layers][kind];
        if(layer.notNil) {
            layer[\scene] = state[\interpolate].value(state[\data][kind], value);
            state[\updateLayer].value(kind);
            state[\selectSample].value(kind, layer[\scene][\sample]);
        };
    };
};

state[\spectralEvent] = { |value|
    var previous = state[\lastState];
    var now = Main.elapsedTime;
    if(state[\activeBanks].notEmpty and: { previous.notNil }
        and: { (value - previous).abs >= 0.04 } and: { (now - state[\lastEvent]) > 0.06 }) {
        state[\eventCount] = state[\eventCount] + 1;
        state[\lastEvent] = now;
        if((value.floor != previous.floor) or: { state[\eventCount] % 25 == 0 }) {
            state[\bank] = (state[\bank] + 1) % state[\activeBanks].size;
            state[\applyBank].value;
        };
        state[\spectral].set(\motion, (value - previous).abs.linlin(0, 2, 0.1, 3).clip(0.1, 3));
    };
    state[\lastState] = value;
};

// Shared validation lets the monitor distinguish received, rejected and ignored.
state[\acceptOSC] = { |msg|
    var path = msg[0].asString;
    var numeric = { |count|
        (msg.size == (count + 1)) and: { msg.copyRange(1, count).every { |x|
            x.isNumber and: { x.isNaN.not } and: { x.abs < 1e10 }
        } }
    };
    var string = { |x| x.isString or: { x.isKindOf(Symbol) } };
    case
    { path == "/score/audio" } { (msg.size == 2) and: { string.value(msg[1]) } }
    { ["/system/state", "/system/stateB", "/imol/master"].includesEqual(path) } { numeric.value(1) }
    { path == "/reflection/1" } { numeric.value(5) }
    { ["/track/A", "/track/B", "/track/C", "/track/E"].includesEqual(path) } { numeric.value(8) }
    { path == "/imol/layer" } {
        (msg.size == 3) and: { string.value(msg[1]) } and: { state[\levels].includesKey(msg[1].asSymbol) }
        and: { msg[2].isNumber } and: { msg[2].isNaN.not } and: { msg[2].abs < 1e10 }
    }
    { ["/imol/stop", "/imol/monitor"].includesEqual(path) } { msg.size == 1 }
    { nil }
};

state[\installOSC] = {
    var port = state[\config][\oscPort];
    var register = { |key, path, func|
        state[\oscKeys].add(key);
        OSCdef(key, { |msg|
            if(state[\acceptOSC].value(msg) == true) { func.value(msg) };
        }, path, recvPort: port);
    };
    var valid = { |message, count|
        (message.size == (count + 1)) and: {
            message.copyRange(1, count).every { |x|
                x.isNumber and: { x.isNaN.not } and: { x.abs < 1e10 }
            }
        }
    };
    register.value(\imolAudioSelection, '/score/audio', { |msg|
        // sclang decodes incoming OSC strings as Symbols.
        if((msg.size == 2) and: { msg[1].isString or: { msg[1].isKindOf(Symbol) } }) {
            state[\selectAudio].value(msg[1].asString)
        };
    });
    register.value(\imolState, '/system/state', { |msg|
        if(valid.value(msg, 1)) { state[\spectralEvent].value(msg[1].clip(1, 14)) };
    });
    register.value(\imolReflectionControl, '/reflection/1', { |msg|
        if(valid.value(msg, 5)) {
            state[\updateReflection].value(msg.copyRange(1, 5).collect { |v| v.clip(0, 1) });
        };
    });
    register.value(\imolStateB, '/system/stateB', { |msg|
        if(valid.value(msg, 1)) { state[\applyScene].value(msg[1].clip(1, 14)) };
    });
    [\A, \B, \C, \E].do { |letter|
        register.value(("imolTrack" ++ letter).asSymbol, "/track/" ++ letter, { |msg|
            if(valid.value(msg, 8)) {
                var values = msg.copyRange(1, 8);
                (1..5).do { |i| values[i] = values[i].clip(0, 1) };
                values[6] = values[6].clip(-1, 1); values[7] = values[7].clip(-1, 1);
                // Missing detections retain the last values, matching the default score.
                state[\tracks][letter] = values;
                [\granular, \groove].do { |kind| state[\updateLayer].value(kind) };
            };
        });
    };
    register.value(\imolMasterControl, '/imol/master', { |msg|
        if(valid.value(msg, 1)) { state[\master].set(\amp, msg[1].clip(0, 1)) };
    });
    register.value(\imolLayerControl, '/imol/layer', { |msg|
        if((msg.size == 3) and: { msg[1].isString or: { msg[1].isKindOf(Symbol) } } and: { msg[2].isNumber }) {
            var kind = msg[1].asSymbol;
            if(state[\levels].includesKey(kind) and: { msg[2].isNaN.not }) {
                state[\setLevel].value(kind, msg[2]);
            };
        };
    });
    register.value(\imolStopControl, '/imol/stop', {
        if(~imolStop.notNil) {
            ~imolStop.value;
            if("IMOL_LAUNCHER".getenv == "1") { SystemClock.sched(1.0, { 0.exit; nil }) };
        };
    });
    register.value(\imolMonitorControl, '/imol/monitor', {
        if(state[\openMonitor].notNil) { state[\openMonitor].value };
    });
};
)
