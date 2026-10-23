// Real OSC input and captured synth controls, without a running audio server.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var target = NetAddr("127.0.0.1", 19003);
var fakeServer = Server(\imolReflectionTest, NetAddr("127.0.0.1", 19004));
var packets = List.new;
var update;
var check = { |condition, message| if(condition.not) { Error(message).throw } };
~imol = (config: (oscPort: 19003, spectralLevel: 0.1, granularLevel: 0.1, grooveLevel: 0.1));
(root +/+ "sound/supercollider/controller.scd").load;
~imol[\reflection] = Synth.basicNew(\imolReflection, fakeServer, 1000);
update = ~imol[\updateReflection];
~imol[\updateReflection] = { |values|
    packets.addAll(fakeServer.makeBundle(false, { update.value(values) }));
};
~imol[\installOSC].value;
Routine({
    var failed = false;
    try {
        var count;
        0.1.wait;
        target.sendMsg('/reflection/1', 0.25, 0.75, 0.5, 0.25, 0.125);
        0.1.wait;
        check.value(~imol[\reflectionValues] == [0.25, 0.75, 0.5, 0.25, 0.125], "Five-value mapping failed");
        check.value(packets.last == [15, 1000, \x, 0.25, \y, 0.75, \brightness, 0.5,
            \size, 0.25, \velocity, 0.125, \t_update, 1], "Incorrect synth controls");
        count = packets.size;
        target.sendMsg('/reflection/1', 1, 1, 1, 1); // incomplete
        target.sendMsg('/reflection/1', 1, 1, 1, 1, 1, 1, 1, 1); // old RGB layout
        target.sendMsg('/reflection/1', 1, 1, "bad", 1, 1);
        target.sendMsg('/reflection/1', 1, 1, 1e20, 1, 1);
        0.1.wait;
        check.value(packets.size == count, "Malformed OSC changed the voice");
        target.sendMsg('/reflection/1', -1, 2, 0.5, 0, 2);
        0.1.wait;
        check.value(~imol[\reflectionValues] == [0, 1, 0.5, 0, 1], "Clamping or loss signal failed");
        // Level control uses the common handler and existing node, no new synth.
        fakeServer.openBundle;
        target.sendMsg('/imol/layer', "reflection", 0.12);
        0.1.wait;
        packets.addAll(fakeServer.closeBundle(false));
        check.value((~imol[\levels][\reflection] - 0.12).abs < 0.00001, "Layer level ignored");
        check.value(packets.last[2] == \amp, "Level not applied to voice");
        "PASS: reflection five-value OSC, synth mapping, validation, clamping and layer gain".postln;
    } { |error| failed = true; error.reportError };
    ~imol[\oscKeys].do { |key| OSCdef(key).free };
    if(failed) { 1.exit } { 0.exit };
}).play(SystemClock);
)
