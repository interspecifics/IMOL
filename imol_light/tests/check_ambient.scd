// Sample changes must settle, respect the hold time and cancel on stop.
(
var root = thisProcess.nowExecutingPath.absolutePath.dirname.dirname;
var config = (root +/+ "sound/supercollider/config.scd").load.copy;
var calls = List.new;
var check = { |ok, message| if(ok.not) { Error(message).throw } };
config[\sampleHoldSeconds] = 0.6; config[\sampleSettleSeconds] = 0.15;
~imol = (config: config, running: true);
(root +/+ "sound/supercollider/controller.scd").load;
~imol[\layers][\groove] = (requested: nil);
~imol[\selectSample] = { |kind, index| calls.add(index); ~imol[\layers][kind][\requested] = index };
Routine({
    var failed = false;
    try {
        var controls;
        ~imol[\requestSample].value(\groove, 0);
        check.value(calls.asArray == [0], "First sample not immediate");
        ~imol[\requestSample].value(\groove, 1);
        0.05.wait;
        ~imol[\requestSample].value(\groove, 2);
        0.3.wait;
        check.value(calls.asArray == [0], "Hold time ignored");
        0.35.wait;
        check.value(calls.asArray == [0, 2], "Latest stable scene not applied");
        ~imol[\requestSample].value(\groove, 3);
        0.05.wait;
        ~imol[\requestSample].value(\groove, 2);
        0.65.wait;
        check.value(calls.asArray == [0, 2], "Returning to active sample did not cancel pending change");
        ~imol[\requestSample].value(\groove, 4);
        ~imol[\running] = false;
        0.2.wait;
        check.value(calls.asArray == [0, 2], "Pending sample loaded after stop");
        ~imol[\layers][\groove][\scene] = (sample: 0);
        ~imol[\tracks][\E] = [4, 1, 1, 1, 1, 1, 1, 1];
        controls = Dictionary.newFrom(~imol[\controls].value(\groove));
        check.value(controls[\rateBase] < 0.4, "Tracker extremes cause fast loops");
        check.value(controls[\panBase] < 0.04, "Tracker extremes cause fast panning");
        check.value(controls[\cutoff] <= 2000, "Multichannel filter too bright");
        "PASS: sample hold, stable/latest selection, cancellation, shutdown and bounded groove controls".postln;
    } { |error| failed = true; error.reportError };
    if(failed) { 1.exit } { 0.exit };
}).play(SystemClock);
)
