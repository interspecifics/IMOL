(
SynthDef(\resonantReflection, {
    |out=0, gate=1, x=0.5, y=0.5, brightness=0.5, size=0.5, velocity=0.0,
    amp=0.18|

    var freq, pan, cutoff;
    var excitation, resonances, shimmer;
    var env, sig;

    // -------------------------
    // MAPEO
    // -------------------------

    // Posicion Vertical
    // arriba = frecuencias más altas
    freq = y.linexp(0, 1, 80, 900);

    // Horizontal position:
    // izquierda / derecha
    pan = x.linlin(0, 1, -1, 1);

    // Brightness controls spectral brightness
    cutoff = brightness.linexp(0, 1, 800, 9000);

    // -------------------------
    // EXITACION
    // -------------------------

    // Exitaci{on contínua
    excitation =
        PinkNoise.ar(0.025)
        +
        Dust2.ar(
            velocity.linexp(0, 1, 0.3, 12),
            0.12
        );

    excitation = LPF.ar(excitation, cutoff);

    // -------------------------
    // RESONANTE
    // -------------------------

    resonances = DynKlank.ar(
        `[
            [
                freq,
                freq * 1.414,
                freq * 2.07,
                freq * 2.73,
                freq * 3.91
            ],

            [
                1.0,
                0.7,
                0.45,
                0.30,
                0.18
            ],

            [
                1.8,
                2.4,
                3.2,
                4.1,
                5.0
            ]
        ],
        excitation
    );

    // -------------------------
    // SHIMMER
    // -------------------------

    shimmer =
        SinOsc.ar(
            freq * [4.01, 5.13],
            0,
            brightness * 0.012
        );

    shimmer = Splay.ar(shimmer, 0.4);

    // -------------------------
    // ENVELOPE
    // -------------------------

    env = EnvGen.kr(
        Env.asr(
            attackTime: 1.5,
            sustainLevel: 1,
            releaseTime: 4
        ),
        gate,
        doneAction: 2
    );

    // Filtros y controles de salida
    sig = resonances * size.linlin(0, 1, 0.15, 1);

    sig = LPF.ar(sig, cutoff);

    sig = Pan2.ar(sig, pan);

    sig = sig + shimmer;

    sig = LeakDC.ar(sig);

    // Limiter
    sig = Limiter.ar(sig, 0.8);

    Out.ar(out, sig * env * amp);

}).add;
)

/// PRUEBAS DE CAMBIOS
~reflection1 = Synth(\resonantReflection);

~reflection1.set(\x, 0.1);
~reflection1.set(\x, 0.9);

~reflection1.set(\y, 0.2);
~reflection1.set(\y, 0.8);

~reflection1.set(\brightness, 0.15);
~reflection1.set(\brightness, 0.9);

~reflection1.set(\size, 0.2);
~reflection1.set(\size, 1.0);

~reflection1.set(\velocity, 0.05);
~reflection1.set(\velocity, 0.8);
~reflection1.set.free;
~reflection1.set(\gate, 0);

//ESCUCHADOR OSC

(
OSCdef(\reflection1, { |msg, time, addr, recvPort|

    var x          = msg[1].asFloat;
    var y          = msg[2].asFloat;
    var brightness = msg[3].asFloat;
    var size       = msg[4].asFloat;
    var r          = msg[5].asFloat;
    var g          = msg[6].asFloat;
    var b          = msg[7].asFloat;
    var velocity   = msg[8].asFloat;

    // Debug
    [
        "reflection 1",
        "x:", x,
        "y:", y,
        "brightness:", brightness,
        "size:", size,
        "RGB:", [r, g, b],
        "velocity:", velocity
    ].postln;

    // Create synth if it doesn't exist
    if(
        ~reflection1.isNil or:
        { ~reflection1.isRunning.not }
    ) {
        ~reflection1 = Synth(\resonantReflection);
    };

    // Send values to synth
    ~reflection1.set(
        \x, x.clip(0, 1),
        \y, y.clip(0, 1),
        \brightness, brightness.clip(0, 1),
        \size, size.clip(0, 1),
        \velocity, velocity.clip(0, 1)
    );

}, '/reflection/1');
)