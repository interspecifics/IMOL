// Actual loopback OSC messages, with synthesis callbacks replaced by captures.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var received = List.new;
var target = NetAddr("127.0.0.1", 19001);
~imol = (config: (oscPort: 19001, spectralLevel: 0.1, granularLevel: 0.1, grooveLevel: 0.1));
(root +/+ "sound/supercollider/controller.scd").load;
~imol[\spectralEvent] = { |value| received.add([\state, value]) };
~imol[\applyScene] = { |value| received.add([\scene, value]) };
~imol[\updateLayer] = { |kind| received.add([\track, kind]) };
~imol[\installOSC].value;
SystemClock.sched(0.1, {
    target.sendMsg('/system/state', 4);
    target.sendMsg('/system/stateB', 2.5);
    target.sendMsg('/track/E', 4, 0.2, 0.3, 0.1, 0.05, 0.005, -0.2, 0.1);
    target.sendMsg('/track/E', "invalid");
    target.sendMsg('/system/state', "invalid");
    nil
});
SystemClock.sched(0.5, {
    var passed = (received.size == 4) and: { received[0] == [\state, 4] }
        and: { received[1] == [\scene, 2.5] }
        and: { ~imol[\tracks][\E][0] == 4 };
    ~imol[\oscKeys].do { |key| OSCdef(key).free };
    if(passed) { "PASS: OSC state, scene, tracker, malformed-message rejection".postln; 0.exit }
    { received.postln; "FAIL: OSC contract".postln; 1.exit };
    nil
});
)
