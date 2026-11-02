// Full mix, four post-effect stems, and a dry spectral tap. No sound card.
// Optional baseline uses the previous sources saved locally in runtime/.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var baseline = "IMOL_AMBIENT_BASELINE".getenv == "1";
var config = (root +/+ "sound/supercollider/config.scd").load.copy;
var data = (root +/+ "sound/data/sound_data.scd").load;
var list = List.new;
var output = root +/+ if(baseline) { "runtime/ambient_before.wav" } { "runtime/ambient_after.wav" };
var options = ServerOptions.new.numOutputBusChannels_(12).numInputBusChannels_(0)
    .memSize_(131072).numWireBufs_(2048);
if(baseline) {
    config.putAll((master: 0.35, spectralLevel: 0.12, granularLevel: 0.2, grooveLevel: 0.15, reflectionLevel: 0.18));
};
~imol = (config: config, data: data);
(root +/+ if(baseline) { "runtime/ambient_before_controller.scd" } { "sound/supercollider/controller.scd" }).load;
(root +/+ if(baseline) { "runtime/ambient_before_synthdefs.scd" } { "sound/supercollider/synthdefs.scd" }).load;
~imol[\layers][\granular] = (scene: data[\granular][0]);
~imol[\layers][\groove] = (scene: data[\groove][0]);
~imolDefs = ~imolDefs.add(SynthDef(\ambientStem, { |in=24, stem=2, amp=0.3|
    var sig = In.ar(in, 2);
    Out.ar(stem, sig * amp); Out.ar(32, sig);
}));
~imolDefs = ~imolDefs.add(SynthDef(\ambientSpectralDry, { Out.ar(10, In.ar(16, 2)) }));
~imolDefs.do { |def|
    var seeded = SynthDef(def.name, { RandSeed.ir(1, 1979); SynthDef.wrap(def.func) });
    seeded.writeDefFile(root +/+ "runtime");
    list.add([0, [\d_load, root +/+ "runtime" +/+ def.name ++ ".scsyndef"]]);
};
list.add([0, [\b_allocReadChannel, 0, (root +/+ config[\audioFolder] +/+ data[\files][0]).standardizePath, 0, -1, 0]]);
list.add([0.1, [\g_new, 100, 0, 0], [\g_new, 200, 3, 100], [\g_new, 300, 3, 200], [\g_new, 400, 3, 300]]);
3.do { |i|
    list.add([0.2, [\s_new, \imolEffects, 201 + i, 0, 200, \in, 16 + (2*i), \out, 24 + (2*i),
        \wet, if(baseline) { if(i == 1) { 0.3 } { 0.4 } } { if(i == 1) { 0.4 } { 0.45 } },
        \diffuse, if(baseline) { (i == 1).binaryValue } { 1 }]]);
};
4.do { |i|
    list.add([0.3, [\s_new, \ambientStem, 301+i, 0, 300, \in, 24+(2*i), \stem, 2+(2*i), \amp, config[\master]]]);
};
list.add([0.3, [\s_new, \imolMaster, 401, 0, 400, \in, 32, \amp, config[\master]]]);
list.add([0.3, [\s_new, \ambientSpectralDry, 305, 0, 300]]);
list.add([0.5, [\s_new, \imolSpectral, 101, 0, 100, \out, 16, \amp, config[\spectralLevel]],
    [\n_setn, 101, \freqs, 83] ++ data[\banks][0][\freqs] ++ [\weights, 83] ++ data[\banks][0][\amps],
    [\s_new, \imolGranular, 102, 0, 100, \out, 18, \buf, 0] ++ ~imol[\controls].value(\granular),
    [\s_new, \imolGroove, 103, 0, 100, \out, 20, \buf, 0] ++ ~imol[\controls].value(\groove),
    [\s_new, \imolReflection, 104, 0, 100, \out, 30, \amp, config[\reflectionLevel]]]);
(1..80).do { |t|
    var active = (t >= 25) and: { t < 55 };
    var y = if(active) { 0.9 } { 0.15 };
    var track = [4, if(active) { 0.8 } { 0.2 }, y, 0.5, 0.5,
        if(active) { 0.25 } { 0.01 }, if(active) { 0.4 } { 0.01 }, 0];
    ~imol[\tracks][\E] = track; ~imol[\tracks][\A] = track;
    list.add([t, [\n_set, 102] ++ ~imol[\controls].value(\granular),
        [\n_set, 103] ++ ~imol[\controls].value(\groove),
        [\n_set, 104, \x, track[1], \y, y, \brightness, y, \size, 0.5,
            \velocity, if(active) { 0.8 } { 0.1 }, \t_update, 1]]);
    if(t % 20 == 0) {
        var bank = data[\banks][(t / 20).asInteger];
        list.add([t, [\n_setn, 101, \freqs, 83] ++ bank[\freqs] ++ [\weights, 83] ++ bank[\amps]]);
    };
};
list.add([82] ++ (101..104).collect { |id| [\n_set, id, \gate, 0] });
list.add([94, [\n_set, 401, \gate, 0]]);
Score(list.asArray).recordNRT(outputFilePath: output, sampleRate: 48000,
    headerFormat: "WAV", sampleFormat: "float", options: options, duration: 100,
    action: { ("RENDERED " ++ output).postln; 0.exit });
)
