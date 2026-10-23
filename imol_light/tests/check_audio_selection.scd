// Real OSC selection, captured server commands; no audio server or hardware.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var target = NetAddr("127.0.0.1", 19001);
var packets = List.new;
var check = { |condition, message| if(condition.not) { Error(message).throw } };
var fakeServer = Server(\imolSelectionTest, NetAddr("127.0.0.1", 19002));
var select, evolve, capture;
~imol = (root: root, config: (oscPort: 19001, spectralLevel: 0.1, granularLevel: 0.1, grooveLevel: 0.1),
    data: (root +/+ "sound/data/sound_data.scd").load);
(root +/+ "sound/supercollider/controller.scd").load;
~imol[\spectral] = Synth.basicNew(\imolSpectral, fakeServer, 1000);
// Collect the actual Node.setn commands without sending to a server.
select = ~imol[\selectAudio]; evolve = ~imol[\spectralEvent];
capture = { |func, value|
    fakeServer.makeBundle(false, { func.value(value) }).do { |msg|
        if(msg[0] == 16) { packets.add(msg) };
    };
};
~imol[\selectAudio] = { |value| capture.value(select, value) };
~imol[\spectralEvent] = { |value| capture.value(evolve, value) };
~imol[\installOSC].value;
Routine({
    var failed = false;
    try {
        var ids = ~imol[\data][\recordings].collect { |track| track[\id] };
        check.value(~imol[\activeBanks].isEmpty, "Must start without a selected recording");
        0.2.wait;
        ids.do { |identifier|
            var expected = (root +/+ "sound/data/partials" +/+ (identifier ++ ".scd")).load;
            target.sendMsg('/score/audio', identifier);
            0.04.wait;
            check.value(~imol[\audioId] == identifier, "OSC did not select " ++ identifier);
            check.value(~imol[\activeBanks][0][\freqs] == expected[\banks][0][\freqs], "Wrong recording bank");
            check.value(~imol[\bank] == 0, "New recording did not reset bank");
        };
        // Evolution wraps within one recording, never crosses into another.
        target.sendMsg('/system/state', 1);
        0.08.wait;
        8.do { |i|
            target.sendMsg('/system/state', (i % 2) + 2);
            0.08.wait;
            check.value(~imol[\bank] == ((i + 1) % 6), "Bank did not wrap within recording");
        };
        target.sendMsg('/score/audio', ids.last);
        0.04.wait;
        check.value(~imol[\bank] == 2, "Heartbeat reset the bank");
        check.value(packets.last[2].asString == "freqs", "No frequency control packet");
        check.value((packets.last.copyRange(4, 86) - ~imol[\activeBanks][2][\freqs]).abs.maxItem < 0.002,
            "Synth did not receive selected frequencies");
        // Type-invalid messages are ignored; unknown/unsafe IDs explicitly mute.
        target.sendMsg('/score/audio', 123);
        0.04.wait;
        check.value(~imol[\audioId] == ids.last, "Malformed selection was accepted");
        ["missing-recording", "../config", ""].do { |identifier|
            target.sendMsg('/score/audio', identifier);
            0.04.wait;
            check.value(~imol[\activeBanks].isEmpty, "Unknown selection retained old banks");
            check.value(packets.last[2].asString == "weights", "No mute control packet");
            check.value(packets.last.copyRange(4, 86).sum == 0, "Unknown selection did not mute");
        };
        target.sendMsg('/score/audio', ids.first);
        0.04.wait;
        check.value(~imol[\activeBanks].size == 6, "Selection did not recover after mute");
        "PASS: 19 recordings via OSC, synth controls, local bank cycling, heartbeat, mute and recovery".postln;
    } { |error| failed = true; error.reportError };
    ~imol[\oscKeys].do { |key| OSCdef(key).free };
    if(failed) { 1.exit } { 0.exit };
}).play(SystemClock);
)
