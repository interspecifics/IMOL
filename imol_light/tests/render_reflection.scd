// Offline voice test: silence, left/right controls, timeout, recovery, size=0.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var output = root +/+ "runtime/reflection_check.wav";
var options = ServerOptions.new.numOutputBusChannels_(2).numInputBusChannels_(0).memSize_(131072);
var list = List.new;
(root +/+ "sound/supercollider/synthdefs.scd").load;
~imolDefs.select { |def| [\imolReflection, \imolMaster].includes(def.name) }.do { |def|
    def.writeDefFile(root +/+ "runtime");
    list.add([0.0, [\d_load, root +/+ "runtime" +/+ def.name ++ ".scsyndef"]]);
};
list.add([0.1, [\s_new, \imolReflection, 100, 0, 0, \out, 16, \amp, 0.18]]);
list.add([0.1, [\s_new, \imolMaster, 200, 1, 0, \in, 16, \amp, 0.35]]);
(1..4).do { |t| list.add([t, [\n_set, 100, \x, 0, \y, 0.8, \brightness, 0.2,
    \size, 0.5, \velocity, 0.1, \t_update, 1]]) };
(5..7).do { |t| list.add([t, [\n_set, 100, \x, 1, \y, 0.2, \brightness, 0.9,
    \size, 0.8, \velocity, 0.8, \t_update, 1]]) };
list.add([13, [\n_set, 100, \x, 0.5, \size, 0.8, \t_update, 1]]);
list.add([14, [\n_set, 100, \size, 0, \t_update, 1]]);
Score(list.asArray).recordNRT(outputFilePath: output, sampleRate: 48000,
    headerFormat: "WAV", sampleFormat: "float", options: options, duration: 17,
    action: { ("RENDERED " ++ output).postln; 0.exit });
)
