// Four distinguishable sources exercise the production mixer without hardware.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var list = List.new;
var options = ServerOptions.new.numOutputBusChannels_(2).numInputBusChannels_(0);
(root +/+ "sound/supercollider/synthdefs.scd").load;
~imolDefs = ~imolDefs.select { |def| [\imolChannel, \imolMaster, \imolMeter].includes(def.name) };
~imolDefs = ~imolDefs.add(SynthDef(\imolTestTone, { |out=16, freq=220| Out.ar(out, SinOsc.ar(freq, 0, 0.02) ! 2) }));
~imolDefs.do { |def|
    def.writeDefFile(root +/+ "runtime");
    list.add([0, [\d_load, root +/+ "runtime" +/+ def.name ++ ".scsyndef"]]);
};
list.add([0.1, [\g_new, 100, 0, 0], [\g_new, 200, 3, 100], [\g_new, 300, 3, 200]]);
4.do { |i|
    list.add([0.2, [\s_new, \imolTestTone, 101 + i, 0, 100, \out, 16 + (i * 2), \freq, 220 * (2 ** i)]]);
    list.add([0.2, [\s_new, \imolChannel, 201 + i, 0, 200, \in, 16 + (i * 2), \out, 24, \meterID, i]]);
};
list.add([0.2, [\s_new, \imolMaster, 301, 0, 300, \in, 24, \amp, 0.35]]);
list.add([0.2, [\s_new, \imolMeter, 302, 1, 300, \in, 0, \meterID, 4]]);
4.do { |solo|
    list.add([solo + 1] ++ Array.fill(4, { |i| [\n_set, 201 + i, \level, (i == solo).binaryValue] }));
};
list.add([5] ++ Array.fill(4, { |i| [\n_set, 201 + i, \level, 0] }));
list.add([6] ++ Array.fill(4, { |i| [\n_set, 201 + i, \level, 1] }));
Score(list.asArray).recordNRT(outputFilePath: root +/+ "runtime/routing_check.wav", sampleRate: 48000,
    headerFormat: "WAV", sampleFormat: "float", options: options, duration: 7,
    action: { "RENDERED routing_check.wav".postln; 0.exit });
)
