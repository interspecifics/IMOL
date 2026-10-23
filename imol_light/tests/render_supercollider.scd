// Offline render: spectral 0.5–3s, granular 4.5–16s, groove 20–23s.
// Nothing is sent to a sound card.
(
var root = thisProcess.nowExecutingPath.dirname.dirname;
var config = (root +/+ "sound/supercollider/config.scd").load;
var data = (root +/+ "sound/data/sound_data.scd").load;
var sample = (root +/+ config[\audioFolder] +/+ data[\files][0]).standardizePath;
var output = root +/+ "runtime/sound_check.wav";
var options = ServerOptions.new.numOutputBusChannels_(2).numInputBusChannels_(0).memSize_(131072).numWireBufs_(2048);
var list = List.new;
var bank = data[\banks][0];
(root +/+ "sound/supercollider/synthdefs.scd").load;
~imolDefs.do { |def|
    def.writeDefFile(root +/+ "runtime");
    list.add([0.0, [\d_load, (root +/+ "runtime" +/+ def.name ++ ".scsyndef").standardizePath]]);
};
list.add([0.0, [\b_allocReadChannel, 0, sample, 0, 48000 * 15, 0]]);
list.add([0.2, [\g_new, 100, 0, 0], [\g_new, 200, 3, 100], [\g_new, 300, 3, 200]]);
list.add([0.3, [\s_new, \imolEffects, 201, 0, 200, \in, 16, \out, 18, \wet, 0.3, \decay, 0.3]]);
list.add([0.3, [\s_new, \imolMaster, 301, 0, 300, \in, 18, \amp, 0.5]]);
list.add([0.5, [\s_new, \imolSpectral, 101, 0, 100, \out, 16, \amp, 0.12],
    [\n_setn, 101, \freqs, 83] ++ bank[\freqs] ++ [\weights, 83] ++ bank[\amps]]);
list.add([3.0, [\n_set, 101, \gate, 0]]);
list.add([4.5, [\s_new, \imolGranular, 102, 0, 100, \out, 16, \buf, 0, \amp, 0.3, \density, 1.8]]);
list.add([16.0, [\n_set, 102, \gate, 0]]);
list.add([20.0, [\s_new, \imolGroove, 103, 0, 100, \out, 16, \buf, 0, \amp, 0.3]]);
list.add([23.0, [\n_set, 103, \gate, 0]]);
Score(list.asArray).recordNRT(outputFilePath: output, sampleRate: 48000,
    headerFormat: "WAV", sampleFormat: "float", options: options, duration: 25,
    action: { ("RENDERED " ++ output).postln; 0.exit });
)
