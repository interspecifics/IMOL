// OSC reception, mix isolation and a real Qt window; no audio hardware.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var config = (root +/+ "sound/supercollider/config.scd").load.copy;
var server = Server(\imolMonitorTest, NetAddr("127.0.0.1", 19008));
var target = NetAddr("127.0.0.1", 19007);
var check = { |condition, message| if(condition.not) { Error(message).throw } };
config[\oscPort] = 19007; config[\monitor] = false;
~imol = (root: root, config: config, data: (root +/+ "sound/data/sound_data.scd").load, server: server);
(root +/+ "sound/supercollider/controller.scd").load;
(root +/+ "sound/supercollider/monitor.scd").load;
~imol[\layers][\granular] = (scene: ~imol[\data][\granular][0], loadedSample: "test.wav", sampleStatus: "Prueba sin audio");
~imol[\channelNames].do { |kind, i| ~imol[\channelNodes][kind] = Synth.basicNew(\imolChannel, server, 100 + i) };
~imol[\installOSC].value;
~imol[\startMonitor].value;
Routine({
    var failed = false;
    try {
        var commands, snapshot;
        0.1.wait;
        target.sendMsg('/score/audio', "a-protest-in-bogota-colombia");
        target.sendMsg('/reflection/1', 0.2, 0.5, 0.7, 0.2, 0.1);
        target.sendMsg('/track/E', "invalid");
        target.sendMsg('/feat/test', 0.5);
        0.1.wait;
        check.value(~imol[\oscCount] == 4, "OSC total incorrect");
        check.value(~imol[\oscRejected] == 1, "Invalid OSC not counted");
        check.value(~imol[\oscRows]["/feat/test"][\status] == "ignorado", "Ignored stream not labelled");
        check.value(~imol[\spectralStatus] == "Parciales cargados", "Spectral selection status missing");
        check.value(~imol[\partialPath].endsWith("a-protest-in-bogota-colombia.scd"), "Wrong partial path");
        ~imol[\solo] = \granular;
        commands = server.makeBundle(false, { ~imol[\updateMix].value });
        check.value(commands.collect { |c| c.last } == [0, 1, 0, 0], "Solo does not isolate granular");
        ~imol[\muted].add(\granular);
        commands = server.makeBundle(false, { ~imol[\updateMix].value });
        check.value(commands.collect { |c| c.last }.sum == 0, "Mute does not override solo");
        ~imol[\solo] = nil; ~imol[\muted].clear;
        commands = server.makeBundle(false, { ~imol[\updateMix].value });
        check.value(commands.collect { |c| c.last }.sum == 4, "Mix did not restore");
        ~imol[\layers][\granular][\fx] = Synth.basicNew(\imolEffects, server, 200);
        commands = server.makeBundle(false, { ~imol[\setDry].value(\granular, true) });
        check.value(commands[0][commands[0].indexOf(\wet) + 1] == 0, "Dry mix failed");
        commands = server.makeBundle(false, { ~imol[\updateLayer].value(\granular) });
        check.value(commands[0][commands[0].indexOf(\wet) + 1] == 0, "Tracker overwrote dry mode");
        ~imol[\receiveMeter].value(['/imol/meter', 100, 0, 0.1, 0.05, 0.2, 0.08]);
        snapshot = ~imol[\meters][0];
        ~imol[\receiveMeter].value(['/imol/meter', 100, 0, -1, 0.1, 0.1, 0.1]);
        check.value(~imol[\meters][0] === snapshot, "Invalid meter accepted");
        ~imol[\openMonitor].value;
        0.5.wait;
        check.value(~imol[\monitorWindow].notNil, "Monitor window did not open");
        ~imol[\monitorRefresh].value;
        Image.fromWindow(~imol[\monitorWindow]).write(root +/+ "runtime/monitor_preview.png");
        ~imol[\closeMonitor].value;
        0.1.wait;
        check.value(~imol[\monitorReceiver].isNil, "Monitor receiver leaked");
        check.value(~imol[\monitorWindow].isNil, "Monitor window leaked");
        // The score can reopen it even when sclang was started by the launcher.
        target.sendMsg('/imol/monitor');
        0.2.wait;
        check.value(~imol[\monitorWindow].notNil, "OSC reopen failed");
        "PASS: monitor OSC, validation, bank status, Solo/Mute, dry mode, telemetry and Qt window".postln;
    } { |error| failed = true; error.reportError };
    ~imol[\closeMonitor].value;
    ~imol[\oscKeys].do { |key| OSCdef(key).free };
    if(failed) { 1.exit } { 0.exit };
}).play(AppClock);
)
