// Offline audio: sparse region 0.5-30 s, large moving region 33-63 s.
// Channels 1/2 = audible wet mix; 3/4 = dry grains for measuring space between events.
// Use IMOL_GRANULAR_DEMO=1 to render a real archive sample instead of the test tone.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var config = (root +/+ "sound/supercollider/config.scd").load;
var data = (root +/+ "sound/data/sound_data.scd").load;
var demo = "IMOL_GRANULAR_DEMO".getenv == "1";
var sample = if(demo) { (root +/+ config[\audioFolder] +/+ data[\files][0]).standardizePath }
    { root +/+ "runtime/granular_fixture.wav" };
var output = root +/+ if(demo) { "runtime/granular_demo_4ch.wav" } { "runtime/granular_check.wav" };
var options = ServerOptions.new.numOutputBusChannels_(4).numInputBusChannels_(0).memSize_(131072);
var list = List.new;
var controls;
~imol = (config: config, data: data);
(root +/+ "sound/supercollider/controller.scd").load;
(root +/+ "sound/supercollider/synthdefs.scd").load;
~imol[\layers][\granular] = (scene: data[\granular][0]);
~imolDefs = ~imolDefs.select { |def| [\imolGranular, \imolEffects, \imolMaster].includes(def.name) };
~imolDefs = ~imolDefs.add(SynthDef(\granularDryTap, { Out.ar(2, In.ar(16, 2)) }));
~imolDefs.do { |def|
    def.writeDefFile(root +/+ "runtime");
    list.add([0, [\d_load, root +/+ "runtime" +/+ def.name ++ ".scsyndef"]]);
};
list.add([0, [\b_allocReadChannel, 0, sample, 0, 48000 * 60, 0]]);
list.add([0.1, [\g_new, 100, 0, 0], [\g_new, 200, 3, 100], [\g_new, 300, 3, 200]]);
list.add([0.2, [\s_new, \imolEffects, 201, 0, 200, \in, 16, \out, 18, \diffuse, 1, \wet, 0.3],
    [\s_new, \granularDryTap, 202, 1, 200],
    [\s_new, \imolMaster, 301, 0, 300, \in, 18, \amp, config[\master]]]);
~imol[\tracks][\A] = [0, 0.2, 0.5, 0.1, 0.1, 0, 0, 0];
controls = ~imol[\controls].value(\granular);
list.add([0.5, [\s_new, \imolGranular, 101, 0, 100, \out, 16, \buf, 0] ++ controls]);
list.add([30, [\n_set, 101, \gate, 0]]);
// Freeing the old buffer at 33 s also exercises the longer source release.
list.add([33, [\b_free, 0], [\b_allocReadChannel, 1, sample, 0, 48000 * 60, 0]]);
~imol[\tracks][\A] = [0, 0.7, 0.5, 0.8, 0.8, 0.25, 0.25, 0];
controls = ~imol[\controls].value(\granular);
list.add([33.5, [\s_new, \imolGranular, 102, 0, 100, \out, 16, \buf, 1] ++ controls]);
list.add([63, [\n_set, 102, \gate, 0]]);
Score(list.asArray).recordNRT(outputFilePath: output, sampleRate: 48000,
    headerFormat: "WAV", sampleFormat: "float", options: options, duration: 72,
    action: { ("RENDERED " ++ output).postln; 0.exit });
)
