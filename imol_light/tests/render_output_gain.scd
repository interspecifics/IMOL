// Actual master gain, stereo preservation, limiter and mute; no audio device.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var list = List.new;
var options = ServerOptions.new.numOutputBusChannels_(6).numInputBusChannels_(0);
(root +/+ "sound/supercollider/synthdefs.scd").load;
~imolDefs = ~imolDefs.select { |def| def.name == \imolMaster };
~imolDefs = ~imolDefs.add(SynthDef(\gainTestSource, { |out=16, amp=0.001|
    Out.ar(out, SinOsc.ar([220, 330], 0, amp) * [1, 0.5]);
}));
~imolDefs.do { |def|
    def.writeDefFile(root +/+ "runtime");
    list.add([0, [\d_load, root +/+ "runtime" +/+ def.name ++ ".scsyndef"]]);
};
list.add([0.1, [\g_new, 100, 0, 0], [\g_new, 200, 3, 100]]);
list.add([0.2, [\s_new, \gainTestSource, 101, 0, 100, \out, 16],
    [\s_new, \gainTestSource, 102, 0, 100, \out, 18, \amp, 0.5],
    [\s_new, \imolMaster, 201, 0, 200, \in, 16, \out, 0, \amp, 0.3],
    [\s_new, \imolMaster, 202, 0, 200, \in, 16, \out, 2, \amp, 0.3, \gainDb, 24],
    [\s_new, \imolMaster, 203, 0, 200, \in, 18, \out, 4, \amp, 1, \gainDb, 30]]);
list.add([8, [\n_set, 202, \gainDb, 6]]);
list.add([12, [\n_set, 201, \amp, 0], [\n_set, 202, \amp, 0], [\n_set, 203, \amp, 0]]);
Score(list.asArray).recordNRT(outputFilePath: root +/+ "runtime/output_gain.wav", sampleRate: 48000,
    headerFormat: "WAV", sampleFormat: "float", options: options, duration: 15,
    action: { "RENDERED output_gain.wav".postln; 0.exit });
)
