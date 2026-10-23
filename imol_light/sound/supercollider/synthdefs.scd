// Standalone SynthDefs: no server boot and no automatic audio output.
// Three Max approximations plus the adapted resonantReflection voice; core UGens only.
(
~imolDefs = [
    SynthDef(\imolSpectral, { |out=0, amp=0.12, motion=0.3, gate=1|
        var freqs = Lag.kr(\freqs.kr(440 ! 83), 0.3).clip(20, 18000);
        var weights = Lag.kr(\weights.kr(0 ! 83), 0.3).clip(0, 1);
        var mask = LFNoise2.kr(motion.clip(0.03, 4) ! 83).range(0, 1).squared;
        // Truncated triangle series; omit harmonics above Nyquist.
        var wave = Mix.fill(5, { |i|
            var h = (i * 2) + 1;
            SinOsc.ar(freqs * h) * ((-1 ** i) / h.squared)
                * ((freqs * h) < (SampleRate.ir * 0.45));
        });
        var sig = Splay.ar(wave * weights * mask, 0.9, 1, 0, true);
        var env = EnvGen.kr(Env.asr(0.5, 1, 0.6), gate, doneAction: 2);
        Out.ar(out, LeakDC.ar(sig) * amp * env);
    }),
    SynthDef(\imolGranular, { |out=0, buf=0, amp=0.2, gate=1,
        density=0.65, position=0.25, spread=0.025, durLo=0.55, durHi=1.2,
        rateLo=0.55, rateHi=0.65, width=0.6, cutoff=1800|
        // Irregular, breathing arrivals instead of a continuous metronomic stream.
        var breath = LFNoise2.kr(0.07).range(0.35, 1);
        var trig = Dust.kr(Lag.kr(density.clip(0.25, 1.8), 2) * breath) * (gate > 0);
        var duration = TRand.kr(Lag.kr(durLo.clip(0.35, 1.8), 2),
            Lag.kr(durHi.clip(0.35, 1.8).max(durLo.clip(0.35, 1.8)), 2), trig);
        var center = Lag.kr(position.clip(0, 1), 2.5);
        var radius = Lag.kr(spread.clip(0.005, 0.1), 2.5);
        var start = (center + TRand.kr(radius.neg, radius, trig)).clip(0, 0.999);
        var rate = TRand.kr(Lag.kr(rateLo.clip(0.35, 1), 3),
            Lag.kr(rateHi.clip(0.35, 1).max(rateLo.clip(0.35, 1)), 3), trig);
        var pan = LFNoise2.kr(0.09) * Lag.kr(width.clip(0, 0.85), 3);
        // Built-in Hann envelope starts/ends at zero, including long sparse grains.
        var sig = GrainBuf.ar(2, trig, duration, buf, rate, start, 4, pan, -1, 16);
        var env = EnvGen.kr(Env.asr(2, 1, 2.5), gate, doneAction: 2);
        sig = LPF.ar(LeakDC.ar(sig), Lag.kr(cutoff.clip(650, 4000), 3));
        Out.ar(out, sig * Lag.kr(amp, 0.5) * env);
    }),
    SynthDef(\imolGroove, { |out=0, buf=0, amp=0.15, gate=1,
        rateBase=0.1, rateStep=0.05, panBase=0.2, panStep=0.03, pitchRatio=1|
        var sig = Mix.fill(10, { |i|
            var rate = Lag.kr(((rateBase + (rateStep * i)) * pitchRatio).clip(0.000001, 4), 0.5);
            var phase = Phasor.ar(0, BufRateScale.kr(buf) * rate, 0, BufFrames.kr(buf));
            var voice = BufRd.ar(1, buf, phase, 1, 4);
            var pan = SinOsc.kr((panBase + (panStep * i)).clip(0.005, 4));
            Pan2.ar(voice, pan, 0.1);
        });
        var env = EnvGen.kr(Env.asr(0.5, 1, 0.6), gate, doneAction: 2);
        Out.ar(out, sig * amp * env);
    }),
    // Adapted from IMOL_SC_RESREFLEC_SINTH1.scd (Paloma Lopez).
    SynthDef(\imolReflection, { |out=0, gate=1, x=0.5, y=0.5, brightness=0.5,
        size=0, velocity=0, amp=0.18, t_update=0, timeout=3|
        var controls = Lag.kr([x, y, brightness, size, velocity].clip(0, 1), [3, 4, 3, 2, 3]);
        // Seven minor-pentatonic zones; long glides replace literal camera pitch.
        var note = Select.kr((y.clip(0, 1) * 6).round, [0, 3, 5, 7, 10, 12, 15]) + 45;
        var freq = Lag.kr(note.midicps, 4) * LFNoise2.kr(0.07).range(-0.08, 0.08).midiratio;
        var pan = controls[0].linlin(0, 1, -1, 1);
        var cutoff = controls[2].squared.linexp(0, 1, 500, 5000).min(SampleRate.ir * 0.45);
        var breaths = Decay2.kr(Dust.kr(controls[4].squared.linlin(0, 1, 0.15, 3)), 0.08, 1.6);
        var excitation = PinkNoise.ar(0.012) * (0.35 + breaths);
        var resonances = DynKlank.ar(`[
            freq * [1, 1.5, 2, 2.5, 3],
            [1, 0.55, 0.30, 0.18, 0.10], [2.8, 3.5, 4.2, 5, 5.8]
        ], LPF.ar(excitation, cutoff));
        var shimmer = Splay.ar(SinOsc.ar(freq * [3.005, 4.01], 0,
            controls[2].squared * LFNoise2.kr(0.09).range(0.002, 0.005)), 0.65);
        var env = EnvGen.kr(Env.asr(3, 1, 6), gate, doneAction: 2);
        // Keep one node; silence both resonances and shimmer on loss of detection.
        var present = Lag.kr((size > 0) * (Sweep.kr(t_update) < timeout.max(0.5)), 2);
        var sig = LPF.ar(resonances * controls[3].sqrt.linlin(0, 1, 0.2, 0.8), cutoff);
        sig = Pan2.ar(sig, pan) + shimmer;
        sig = FreeVerb2.ar(sig[0], sig[1], 0.35, 0.85, 0.65);
        Out.ar(out, Limiter.ar(LeakDC.ar(sig), 0.8) * env * present * Lag.kr(amp, 0.2));
    }),
    // Meters measure real stereo audio after effects and listening controls.
    SynthDef(\imolChannel, { |in=0, out=0, level=1, meterID=0|
        var sig = In.ar(in, 2) * Lag.kr(level, 0.08);
        SendPeakRMS.kr(sig, 10, 0.4, '/imol/meter', meterID);
        Out.ar(out, sig);
    }),
    SynthDef(\imolMeter, { |in=0, meterID=4|
        SendPeakRMS.kr(In.ar(in, 2), 10, 0.4, '/imol/meter', meterID);
    }),
    SynthDef(\imolEffects, { |in=0, out=0, wet=0.4, delay=0.3, decay=2,
        damp=0.5, width=0.6, feedback=0.35, diffuse=0|
        var dry = In.ar(in, 2);
        var local = LocalIn.ar(2);
        var delayTime = Lag.kr(delay.clip(0.003, 1.9), 0.5);
        var loop = DelayC.ar((dry + (local.reverse * feedback.clip(0, 0.85))).tanh,
            2, [delayTime, (delayTime * 1.013).min(1.99)]);
        var filtered = LPF.ar(loop, Lag.kr(damp.clip(0, 1).linexp(0, 1, 16000, 500), 0.3));
        var chorus = DelayC.ar(filtered, 0.06, SinOsc.kr([0.13, 0.17]).range(0.012, 0.024));
        var tail = CombC.ar(filtered, 2, delayTime, decay.clip(0.05, 6)) * 0.15;
        var space = FreeVerb2.ar(dry[0], dry[1], 1, 0.78, 0.75);
        var effected = Select.ar(diffuse.clip(0, 1), [filtered + (chorus * width.clip(0, 1)) + tail, space]);
        var mixed = XFade2.ar(dry, effected,
            Lag.kr(wet.clip(0, 1), 0.3) * 2 - 1);
        LocalOut.ar(LeakDC.ar(filtered));
        Out.ar(out, LeakDC.ar(mixed).tanh);
    }),
    SynthDef(\imolMaster, { |in=0, out=0, amp=0.5, gate=1|
        var sig = In.ar(in, 2);
        var env = EnvGen.kr(Env.asr(0.1, 1, 0.5), gate, doneAction: 2);
        Out.ar(out, Limiter.ar(LeakDC.ar(sig) * Lag.kr(amp.clip(0, 1), 0.2), 0.85) * env);
    })
];
)
