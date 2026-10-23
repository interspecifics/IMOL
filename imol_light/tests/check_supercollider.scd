// Compile sources and validate mappings without starting the audio server.
(
var root = thisProcess.nowExecutingPath.dirname.dirname;
var failed = false;
try {
    var config = (root +/+ "sound/supercollider/config.scd").load;
    var data = (root +/+ "sound/data/sound_data.scd").load;
    var midpoint;
    if(config.isNil or: { data.isNil }) { Error("Configuration/data did not load").throw };
    if(File.readAllString(root +/+ "sound/supercollider/main.scd").compile.isNil) {
        Error("main.scd did not compile").throw
    };
    (root +/+ "sound/supercollider/synthdefs.scd").load;
    if(~imolDefs.size != 8) { Error("Expected eight SynthDefs").throw };
    ~imolDefs.do { |def| def.asBytes; ("COMPILED " ++ def.name).postln };
    ~imol = (config: config, data: data);
    (root +/+ "sound/supercollider/controller.scd").load;
    if(~imol[\interpolate].isNil) { Error("Controller did not load").throw };
    if(data[\granular].size != 14 or: { data[\groove].size != 21 }) { Error("Missing scenes").throw };
    data[\banks].do { |bank|
        if(bank[\freqs].size != 83 or: { bank[\amps].size != 83 }) { Error("Bad spectral bank").throw };
    };
    midpoint = ~imol[\interpolate].value(data[\granular], 2.5);
    if((midpoint[\durHi] - ((data[\granular][1][\durHi] + data[\granular][2][\durHi]) / 2)).abs > 0.00001) {
        Error("Scene interpolation failed").throw
    };
    if(midpoint[\sample].isInteger.not) { Error("Sample selection must be discrete").throw };
    ~imolCheckOnly = true;
    (root +/+ "sound/supercollider/main.scd").load;
    if(~imol[\server].isNil) { Error("Initialization failed").throw };
    if(PathName(~imol[\audioFolder]).isFolder.not) { Error("Audio folder does not resolve").throw };
    ~imolCheckOnly = false;
    "PASS: compilation, bank sizes, scene counts, interpolation, discrete sample selection".postln;
} { |error|
    failed = true;
    error.reportError;
};
if(failed) { 1.exit } { 0.exit };
)
