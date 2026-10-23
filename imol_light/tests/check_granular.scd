// Mapping, listening controls and sample-release contract; no sound card.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var config = (root +/+ "sound/supercollider/config.scd").load;
var data = (root +/+ "sound/data/sound_data.scd").load;
var server = Server(\granularTest, NetAddr("127.0.0.1", 19010));
var check = { |ok, message| if(ok.not) { Error(message).throw } };
var failed = false;
~imol = (config: config, data: data, server: server);
(root +/+ "sound/supercollider/controller.scd").load;
try {
    var quiet, active, effects, original = data[\granular][0].copy;
    ~imol[\layers][\granular] = (scene: data[\granular][0], fx: Synth.basicNew(\imolEffects, server, 200));
    ~imol[\tracks][\A] = [0, 0.2, 0.1, 0.1, 0.1, 0, 0, 0];
    quiet = Dictionary.newFrom(~imol[\controls].value(\granular));
    ~imol[\tracks][\A] = [0, 0.8, 0.9, 0.8, 0.8, 0.25, 0.25, 0];
    active = Dictionary.newFrom(~imol[\controls].value(\granular));
    check.value(active[\density] > (quiet[\density] * 4), "Score movement/size does not change density");
    check.value(active[\position] > quiet[\position], "Score x does not move sample position");
    check.value(active[\cutoff] > (quiet[\cutoff] * 2), "Score y does not change timbre");
    check.value(active[\durHi] > quiet[\durHi], "Score area does not change grain length");
    check.value(active[\rateHi] < 1, "Ambient reading rate unexpectedly high");
    ~imol[\tracks][\E] = [4, 0.4, 0.5, 0.1, 0.1, 0.01, 0, 0];
    check.value(Dictionary.newFrom(~imol[\controls].value(\granular))[\position] == 0.4, "Tracker E priority lost");
    effects = server.makeBundle(false, { ~imol[\updateLayer].value(\granular) });
    check.value(effects[0][effects[0].indexOf(\diffuse) + 1] == 1, "Granular still uses rhythmic delay");
    check.value(effects[0][effects[0].indexOf(\wet) + 1] == 0.3, "Wrong ambient reverb mix");
    ~imol[\setDry].value(\granular, true);
    effects = server.makeBundle(false, { ~imol[\updateLayer].value(\granular) });
    check.value(effects[0][effects[0].indexOf(\wet) + 1] == 0, "Updates overwrite dry listening mode");
    check.value(data[\granular][0] == original, "Archived Max scene was mutated");
    "PASS: ambient score response, E/A selection, diffuse effects, dry mode and preserved source data".postln;
} { |error| failed = true; error.reportError };
if(failed) { 1.exit } { 0.exit };
)
