// Passive OSC logging plus audio telemetry. GUI work stays on AppClock.
(
var state = ~imol;
state[\oscRows] = Dictionary.new;
state[\oscCount] = 0;
state[\oscRejected] = 0;
state[\oscLastAt] = nil;
state[\meters] = Array.fill(5, { nil });

state[\recordOSC] = { |msg, addr|
    var path = msg[0].asString;
    var accepted = state[\acceptOSC].value(msg);
    var previous = state[\oscRows][path];
    var row = (count: if(previous.isNil) { 1 } { previous[\count] + 1 },
        time: Main.elapsedTime, values: msg.drop(1).keep(8).collect { |v|
            if(v.isNumber) { v.round(0.0001).asString } { v.asString.keep(120) }
        }.join("  "), status: if(accepted.isNil) { "ignorado" } {
            if(accepted) { "OK" } { "INVALIDO" }
        }, source: addr.ip ++ ":" ++ addr.port);
    state[\oscRows][path] = row;
    state[\oscCount] = state[\oscCount] + 1;
    state[\oscLastAt] = Main.elapsedTime;
    if(accepted == false) { state[\oscRejected] = state[\oscRejected] + 1 };
    if(state[\oscRows].size > 48) {
        var oldest = state[\oscRows].keys.asArray.minItem { |key| state[\oscRows][key][\time] };
        state[\oscRows].removeAt(oldest);
    };
};

state[\receiveMeter] = { |msg|
    if((msg.size == 7) and: { msg[2].isInteger } and: { msg[2] >= 0 } and: { msg[2] < 5 }
        and: { msg.copyRange(3, 6).every { |v|
            v.isNumber and: { v.isNaN.not } and: { v >= 0 } and: { v < 10000 }
        } }) {
        state[\meters][msg[2]] = (time: Main.elapsedTime, values: msg.copyRange(3, 6));
    };
};

state[\granularDescription] = {
    var layer = state[\layers][\granular];
    if(layer.isNil or: { layer[\scene].isNil }) { "Granulador: esperando muestra" } {
        var controls = Dictionary.newFrom(state[\controls].value(\granular));
        var lo = controls[\durLo], hi = controls[\durHi];
        var density = controls[\density];
        "Granular ambient: %-% granos/s | duracion %-% s | posicion % +/- % pct.\nLectura %-%x | filtro % Hz | reverb % | control % (objetivos; transicion 2-3 s)".format(
            (density * 0.35).round(0.01), density.round(0.01), lo.round(0.01), hi.round(0.01),
            (controls[\position] * 100).round(0.1), (controls[\spread] * 100).round(0.1),
            controls[\rateLo].min(controls[\rateHi]).round(0.01), controls[\rateLo].max(controls[\rateHi]).round(0.01),
            controls[\cutoff].round,
            if(state[\dry].includes(\granular)) { "SECO" } { "30%" },
            if(state[\tracks][\E].notNil) { "tracker E" } {
                if(state[\tracks][\A].notNil) { "tracker A" } { "escena" }
            })
    }
};

state[\openMonitor] = {
    {
        if(state[\monitorWindow].notNil and: { state[\monitorWindow].isClosed.not }) {
            state[\monitorWindow].front;
        } {
            var window = Window("IMOL Light — Monitor audio", Rect(60, 60, 1040, 775), resizable: false);
            var heading, spectral, partial, granular, samples, table, meterViews, levelBoxes, soloButtons, muteButtons, dryButtons;
            var labels = ["Espectral", "Granular", "Multicanal", "Reflection", "Salida general"];
            // Match the Python score's palette and compact, monospaced controls.
            var background = Color.gray(20/255), panel = Color.gray(26/255);
            var foreground = Color.gray(200/255), secondary = Color.gray(154/255);
            var border = Color.gray(51/255), buttonColor = Color.gray(21/255);
            var accent = Color(10/255, 132/255, 1);
            var palette = QPalette.dark.window_(background).windowText_(foreground)
                .base_(Color.gray(25/255)).baseText_(foreground)
                .button_(buttonColor).buttonText_(foreground)
                .highlight_(accent).highlightText_(Color.white);
            var text = { |rect, value, size=12|
                StaticText(window, rect).string_(value).font_(Font("Menlo", size)).stringColor_(foreground)
            };
            var line = { |y| View(window, Rect(0, y, 1040, 1)).background_(border) };
            var button = { |rect, states|
                Button(window, rect).font_(Font("Menlo", 11)).states_(states)
                    .setProperty(\styleSheet, "QcButton { border: 1px solid #333; border-radius: 0px; } QcButton:hover { border-color: #555; }")
            };
            window.view.palette = palette;
            window.background_(background);
            View(window, Rect(0, 0, 1040, 38)).background_(panel);
            View(window, Rect(0, 132, 1040, 28)).background_(panel);
            View(window, Rect(0, 480, 1040, 28)).background_(panel);
            [38, 75, 132, 160, 377, 480, 508, 733].do(line);
            state[\monitorWindow] = window;
            text.value(Rect(18, 6, 600, 26), "IMOL Light / Monitor audio", 14);
            text.value(Rect(715, 8, 301, 22), "GRAPHIC SCORE / SUPERCOLLIDER", 11).stringColor_(secondary);
            heading = text.value(Rect(18, 44, 1000, 24), "Esperando OSC...", 12);
            spectral = text.value(Rect(18, 81, 1000, 23), "", 11);
            partial = text.value(Rect(18, 105, 1000, 22), "", 11).stringColor_(secondary);
            text.value(Rect(18, 136, 605, 20), "CANALES / L-R / RMS + pico (-60 a 0 dBFS)", 11).stringColor_(secondary);
            text.value(Rect(635, 136, 70, 20), "Nivel", 11).stringColor_(secondary);
            text.value(Rect(715, 136, 301, 20), "Escucha / despues de efectos", 11).stringColor_(secondary);
            meterViews = Array.newClear(5);
            levelBoxes = Array.newClear(4); soloButtons = Array.newClear(4);
            muteButtons = Array.newClear(4); dryButtons = Array.newClear(4);
            labels.do { |label, i|
                var y = 165 + (i * 43);
                var db;
                text.value(Rect(18, y, 115, 28), label, 11);
                meterViews[i] = Array.fill(2, { |channel|
                    LevelIndicator(window, Rect(135, y + 4 + (channel * 14), 305, 7))
                        .drawsPeak_(true).warning_(0.9).critical_(0.98)
                        .background_(border).meterColor_(accent)
                        .warningColor_(Color(1, 0.65, 0.2)).criticalColor_(Color(1, 0.3, 0.3))
                });
                db = text.value(Rect(450, y, 180, 28), "Sin medicion", 11).stringColor_(secondary);
                meterViews[i] = meterViews[i].add(db);
                if(i < 4) {
                    var kind = state[\channelNames][i];
                    levelBoxes[i] = NumberBox(window, Rect(635, y, 70, 28)).decimals_(2)
                        .font_(Font("Menlo", 12)).background_(buttonColor).normalColor_(accent)
                        .typingColor_(Color.white).stringColor_(accent)
                        .clipLo_(0).clipHi_(0.5).value_(state[\levels][kind])
                        .action_({ |view| state[\setLevel].value(kind, view.value) });
                    soloButtons[i] = button.value(Rect(715, y, 78, 28), [
                        ["Solo", foreground, buttonColor], ["SOLO", Color.white, accent]])
                        .action_({ |view|
                            state[\solo] = if(view.value == 1) { kind } { nil };
                            state[\updateMix].value;
                        });
                    muteButtons[i] = button.value(Rect(803, y, 78, 28), [
                        ["Mute", foreground, buttonColor], ["MUTE", Color.white, Color(0.65, 0.2, 0.2)]])
                        .action_({ |view|
                            if(view.value == 1) { state[\muted].add(kind) } { state[\muted].remove(kind) };
                            state[\updateMix].value;
                        });
                    if(i < 3) {
                        dryButtons[i] = button.value(Rect(891, y, 125, 28), [
                            ["Con efectos", foreground, buttonColor], ["SECO", Color.white, accent]])
                            .action_({ |view| state[\setDry].value(kind, view.value == 1) });
                    };
                } {
                    button.value(Rect(715, y, 301, 28), [["Quitar Solo / Mute", foreground, buttonColor]]).action_({
                        state[\solo] = nil; state[\muted].clear; state[\updateMix].value;
                    });
                };
            };
            granular = text.value(Rect(18, 385, 1000, 46), "", 11);
            samples = text.value(Rect(18, 436, 1000, 42), "", 11).stringColor_(secondary);
            text.value(Rect(18, 484, 1000, 20), "OSC / direccion / estado / contador / antiguedad / ultimos valores", 11).stringColor_(secondary);
            table = ListView(window, Rect(0, 509, 1040, 224)).font_(Font("Menlo", 11))
                .background_(Color.black).stringColor_(foreground)
                .hiliteColor_(Color(0.04, 0.19, 0.32)).selectedStringColor_(Color.white);
            text.value(Rect(18, 743, 1000, 22), "Cerrar no detiene el sonido. Reabrir: Monitor audio en el score. Solo / Mute y niveles son temporales.", 11).stringColor_(secondary);
            state[\monitorRefresh] = {
                var now = Main.elapsedTime;
                var age = if(state[\oscLastAt].isNil) { nil } { now - state[\oscLastAt] };
                var bankCount = state[\activeBanks].size;
                var rows = state[\oscRows].keys.asArray.sort { |a, b| state[\oscRows][a][\time] > state[\oscRows][b][\time] };
                heading.string = "OSC :% | % | % mensajes | % invalidos".format(state[\config][\oscPort],
                    if(age.isNil) { "SIN MENSAJES" } {
                        if(age < 3) { "RECIBIENDO" } { "SIN TRAFICO RECIENTE" }
                    }, state[\oscCount], state[\oscRejected]);
                heading.stringColor = if(age.notNil and: { age < 3 }) { accent } { secondary };
                spectral.string = "Audio recibido: % | Banco %/% | %".format(
                    if((state[\audioId] ? "").isEmpty) { "ninguno" } { state[\audioId] },
                    if(bankCount == 0) { 0 } { state[\bank] + 1 }, bankCount, state[\spectralStatus]);
                partial.string = "Parciales: " ++ if((state[\partialPath] ? "").isEmpty) { "sin seleccionar" } {
                    "sound/data/partials/" ++ PathName(state[\partialPath]).fileName
                };
                partial.toolTip = state[\partialPath] ? "";
                meterViews.do { |views, i|
                    var meter = state[\meters][i];
                    var fresh = meter.notNil and: { now - meter[\time] < 2 };
                    var values = if(fresh) { meter[\values] } { [0, 0, 0, 0] };
                    2.do { |ch|
                        views[ch].value = values[(ch * 2) + 1].max(1e-6).ampdb.linlin(-60, 0, 0, 1).clip(0, 1);
                        views[ch].peakLevel = values[ch * 2].max(1e-6).ampdb.linlin(-60, 0, 0, 1).clip(0, 1);
                    };
                    views[2].string = if(fresh) {
                        "L % / R % dB".format(values[0].max(1e-6).ampdb.round(0.1), values[2].max(1e-6).ampdb.round(0.1))
                    } { "SIN MEDICION" };
                    if(i < 4) {
                        var kind = state[\channelNames][i];
                        if(levelBoxes[i].hasFocus.not) { levelBoxes[i].value = state[\levels][kind] };
                        soloButtons[i].value = (state[\solo] == kind).binaryValue;
                        muteButtons[i].value = state[\muted].includes(kind).binaryValue;
                        if(dryButtons[i].notNil) { dryButtons[i].value = state[\dry].includes(kind).binaryValue };
                    };
                };
                granular.string = state[\granularDescription].value;
                samples.string = [\granular, \groove].collect { |kind|
                    var layer = state[\layers][kind];
                    "%: % | %".format(kind, if(layer.isNil) { "sin muestra" } { layer[\loadedSample] ? "sin muestra" },
                        if(layer.isNil) { "" } { layer[\sampleStatus] ? "" })
                }.join("\n");
                table.items = rows.collect { |key|
                    var row = state[\oscRows][key];
                    "% | % | #% | %s | %".format(key, row[\status], row[\count],
                        (now - row[\time]).round(0.1), row[\values])
                };
            };
            window.onClose = {
                if(state[\monitorTask].notNil) { state[\monitorTask].stop };
                state[\monitorWindow] = nil;
            };
            state[\monitorTask] = Routine({ loop { state[\monitorRefresh].value; 0.2.wait } }).play(AppClock);
            window.front;
        };
    }.defer;
};

state[\startMonitor] = {
    if(state[\monitorReceiver].isNil) {
        state[\monitorReceiver] = { |msg, time, addr, port|
            if(port == state[\config][\oscPort]) { state[\recordOSC].value(msg, addr) };
        };
        thisProcess.addOSCRecvFunc(state[\monitorReceiver]);
        OSCdef(\imolMeterReply, { |msg| state[\receiveMeter].value(msg) }, '/imol/meter', srcID: state[\server].addr);
        state[\oscKeys].add(\imolMeterReply);
    };
    if(state[\config][\monitor] != false) { state[\openMonitor].value };
};
state[\closeMonitor] = {
    if(state[\monitorReceiver].notNil) {
        thisProcess.removeOSCRecvFunc(state[\monitorReceiver]); state[\monitorReceiver] = nil;
    };
    { if(state[\monitorWindow].notNil) { state[\monitorWindow].close } }.defer;
};
~imolMonitor = { state[\openMonitor].value };
)
