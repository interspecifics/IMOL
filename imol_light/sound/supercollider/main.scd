// Evaluate the whole file. Uses a dedicated audio server and only IMOL resources.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname.dirname;
var config = (root +/+ "sound/supercollider/config.scd").load;
var data = (root +/+ "sound/data/sound_data.scd").load;
var options = ServerOptions.new;
var state;
if(~imol.notNil and: { ~imol[\running] == true }) {
    Error("IMOL is already running. Call ~imolStop.value; and wait one second before restarting.").throw;
};
options.numOutputBusChannels = config[\outputChannels];
options.numInputBusChannels = 0;
options.memSize = 131072;
options.maxNodes = 2048;
options.numWireBufs = 2048;
if(config[\device].notNil) { options.device = config[\device] };
~imol = (root: root, config: config, data: data, running: true);
state = ~imol;
state[\audioFolder] = if(PathName(config[\audioFolder]).isAbsolutePath) { config[\audioFolder].standardizePath }
    { (root +/+ config[\audioFolder]).standardizePath };
state[\server] = Server(\imolLight, NetAddr("127.0.0.1", 57130), options);
(root +/+ "sound/supercollider/synthdefs.scd").load;
(root +/+ "sound/supercollider/controller.scd").load;
(root +/+ "sound/supercollider/monitor.scd").load;

~imolStop = {
    state[\running] = false;
    state[\closeMonitor].value;
    state[\oscKeys].do { |key| OSCdef(key).free };
    if(state[\master].notNil) { state[\master].set(\gate, 0) };
    // A private server means cleanup cannot free another project's nodes/buffers.
    SystemClock.sched(0.7, { state[\server].quit; nil });
};

if(~imolCheckOnly == true) {
    state[\running] = false;
    "IMOL: initialization checked without booting audio".postln;
} {
if(PathName(state[\audioFolder]).isFolder.not) {
    ("IMOL: audio folder not found: " ++ state[\audioFolder]).warn;
    state[\running] = false;
} {
    state[\server].waitForBoot({
        var server = state[\server];
        Routine({
            // The 83-voice definition exceeds a UDP packet; load it from disk.
            ~imolDefs.do { |def| def.load(server, dir: root +/+ "runtime/") };
            server.sync;
            state[\mixBus] = Bus.audio(server, 2);
            state[\sources] = Group.head(server);
            state[\effects] = Group.after(state[\sources]);
            state[\mixers] = Group.after(state[\effects]);
            state[\output] = Group.after(state[\mixers]);
            state[\voiceBuses] = IdentityDictionary.new;
            state[\channelNames].do { |kind, index|
                state[\voiceBuses][kind] = Bus.audio(server, 2);
                state[\channelNodes][kind] = Synth.tail(state[\mixers], \imolChannel,
                    [\in, state[\voiceBuses][kind].index, \out, state[\mixBus].index, \meterID, index]);
            };
            server.sync;
            [\granular, \groove].do { |kind|
                var layer = (bus: Bus.audio(server, 2), version: 0, requested: nil);
                layer[\fx] = Synth.head(state[\effects], \imolEffects,
                    [\in, layer[\bus].index, \out, state[\voiceBuses][kind].index]);
                state[\layers][kind] = layer;
            };
            state[\spectralBus] = Bus.audio(server, 2);
            state[\spectralFx] = Synth.head(state[\effects], \imolEffects,
                [\in, state[\spectralBus].index, \out, state[\voiceBuses][\spectral].index, \wet, 0.35]);
            state[\spectral] = Synth.head(state[\sources], \imolSpectral,
                [\out, state[\spectralBus].index, \amp, state[\levels][\spectral]]);
            state[\applyBank].value; // Silent until the score announces its loaded audio.
            state[\reflection] = Synth.head(state[\sources], \imolReflection,
                [\out, state[\voiceBuses][\reflection].index, \amp, state[\levels][\reflection],
                    \timeout, config[\reflectionTimeout] ? 3.0]);
            state[\master] = Synth.head(state[\output], \imolMaster,
                [\in, state[\mixBus].index, \out, config[\outputBus], \amp, config[\master]]);
            state[\masterMeter] = Synth.tail(state[\output], \imolMeter, [\in, config[\outputBus], \meterID, 4]);
            state[\applyScene].value(1);
            state[\installOSC].value;
            state[\startMonitor].value;
            ("IMOL Light v0.1 ready. OSC port " ++ config[\oscPort] ++ ". Stop: ~imolStop.value;").postln;
        }).play(SystemClock);
    });
};
};
)
