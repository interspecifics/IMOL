// Standalone SynthDefs: no server boot and no automatic audio output.
// Three Max approximations plus the adapted resonantReflection voice; core UGens only.
(
~imolDefs = [
    SynthDef(\imolSpectral, { |out=0, amp=0.10, motion=0.03, gate=1|
        var target = \freqs.kr(440 ! 83).clip(20, 18000);
        // Fade down before retuning: avoid audible frequency sweeps between banks.
        var changing = Changed.kr(target).sum > 0;
        var transition = EnvGen.kr(Env([1, 0, 0, 1], [1.4, 0.2, 3], \sine), changing);
        var freqs = DelayN.kr(target, 1.5, 1.5).max(20);
        var weights = Lag.kr(\weights.kr(0 ! 83), 4).clip(0, 1);
        var mask = LFNoise2.kr(Lag.kr(motion.clip(0.008, 0.07), 5) ! 83).range(0.05, 0.85).squared;
        var wave = SinOsc.ar(freqs) + (SinOsc.ar(freqs * 2) * 0.06 * (freqs < 3000));
        var sig = Splay.ar(wave * weights * mask, 0.9, 1, 0, true);
        var env = EnvGen.kr(Env.asr(4, 1, 5, \sine), gate, doneAction: 2);
        sig = LPF.ar(HPF.ar(sig, 65), 2400);
        Out.ar(out, LeakDC.ar(sig) * Lag.kr(amp, 2) * env * transition);
    }),
    SynthDef(\imolGranular, { |out=0, buf=0, amp=0.2, gate=1,
        density=0.65, position=0.25, spread=0.025, durLo=0.55, durHi=1.2,
        rateLo=0.55, rateHi=0.65, width=0.6, cutoff=1800|
        // Irregular, breathing arrivals instead of a continuous metronomic stream.
        var breath = LFNoise2.kr(0.035).range(0.2, 1).squared;
        var trig = Dust.kr(Lag.kr(density.clip(0.2, 1.1), 4) * breath) * (gate > 0);
        var duration = TRand.kr(Lag.kr(durLo.clip(0.35, 1.8), 2),
            Lag.kr(durHi.clip(0.35, 1.8).max(durLo.clip(0.35, 1.8)), 2), trig);
        var center = Lag.kr(position.clip(0, 1), 5);
        var radius = Lag.kr(spread.clip(0.005, 0.06), 5);
        var start = (center + TRand.kr(radius.neg, radius, trig)).clip(0, 0.999);
        var rate = TRand.kr(Lag.kr(rateLo.clip(0.35, 1), 3),
            Lag.kr(rateHi.clip(0.35, 1).max(rateLo.clip(0.35, 1)), 3), trig);
        var pan = LFNoise2.kr(0.035) * Lag.kr(width.clip(0, 0.7), 5);
        // Built-in Hann envelope starts/ends at zero, including long sparse grains.
        var sig = GrainBuf.ar(2, trig, duration, buf, rate, start, 4, pan, -1, 16);
        var env = EnvGen.kr(Env.asr(4, 1, 5, \sine), gate, doneAction: 2);
        sig = LPF.ar(HPF.ar(LeakDC.ar(sig), 65), Lag.kr(cutoff.clip(650, 2200), 5));
        sig = Compander.ar(sig, sig, 0.08, 1, 0.5, 0.05, 0.8);
        Out.ar(out, sig * Lag.kr(amp, 2) * env);
    }),
    SynthDef(\imolGroove, { |out=0, buf=0, amp=0.15, gate=1,
        rateBase=0.22, rateStep=0.008, panBase=0.015, panStep=0.003, pitchRatio=1, cutoff=1300|
        var frames = BufFrames.kr(buf).max(2);
        var sig = Mix.fill(4, { |i|
            var rate = Lag.kr(((rateBase + (rateStep * i)) * pitchRatio).clip(0.12, 0.65), 8);
            var phase = (Phasor.ar(0, BufRateScale.kr(buf) * rate, 0, frames) + (frames * i / 4)).wrap(0, frames);
            var voice = BufRd.ar(1, buf, phase, 1, 4);
            // Offset, tapered loops hide the discontinuity at each sample boundary.
            var taper = (phase / frames * pi).sin.squared;
            var breath = LFNoise2.kr(0.012 + (i * 0.003)).range(0.1, 1).squared;
            var pan = LFNoise2.kr(Lag.kr((panBase + (panStep * i)).clip(0.008, 0.04), 6)) * 0.65;
            voice = LPF.ar(HPF.ar(voice, 65), Lag.kr(cutoff.clip(650, 2000), 6));
            voice = Compander.ar(voice, voice, 0.08, 1, 0.5, 0.08, 1);
            Pan2.ar(voice * taper * breath, pan, 0.55);
        });
        var env = EnvGen.kr(Env.asr(5, 1, 5, \sine), gate, doneAction: 2);
        Out.ar(out, sig * Lag.kr(amp, 2) * env);
    }),
    // Adapted from IMOL_SC_RESREFLEC_SINTH1.scd (Paloma Lopez).
    SynthDef(\imolReflection, { |out=0, gate=1, x=0.5, y=0.5, brightness=0.5,
        size=0, velocity=0, amp=0.18, t_update=0, timeout=3|
        var controls = Lag.kr([x, y, brightness, size, velocity].clip(0, 1), [4, 7, 6, 5, 6]);
        // Camera height shades a fixed voicing rather than sweeping its pitch.
        var freqs = ([0, 3, 7, 10, 14, 19, 24] + 36).midicps;
        var weights = Array.fill(7, { |i| ((i - (controls[1] * 6)).squared * -0.45).exp });
        var pan = controls[0].linlin(0, 1, -1, 1);
        var cutoff = controls[2].squared.linexp(0, 1, 500, 2200);
        var breaths = Decay2.kr(Dust.kr(controls[4].squared.linlin(0, 1, 0.05, 0.35)), 0.7, 3);
        var excitation = PinkNoise.ar(0.008) * (0.12 + breaths);
        var resonances = DynKlank.ar(`[
            freqs, weights * 0.5, [2.5, 3, 3.5, 4, 4.5, 5, 5.5]
        ], LPF.ar(excitation, cutoff));
        var shimmer = Splay.ar(SinOsc.ar(freqs * 1.002, 0,
            weights * controls[2].squared * 0.0008), 0.5);
        var env = EnvGen.kr(Env.asr(4, 1, 6, \sine), gate, doneAction: 2);
        // Keep one node; silence both resonances and shimmer on loss of detection.
        var present = Lag.kr((size > 0) * (Sweep.kr(t_update) < timeout.max(0.5)), 2);
        var sig = LPF.ar(resonances * controls[3].sqrt.linlin(0, 1, 0.2, 0.65), cutoff);
        sig = Pan2.ar(sig, pan) + shimmer;
        sig = FreeVerb2.ar(sig[0], sig[1], 0.45, 0.82, 0.8);
        Out.ar(out, Limiter.ar(LeakDC.ar(sig), 0.6) * env * present * Lag.kr(amp, 2));
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
        // Legacy arguments remain accepted, but no rhythmic delay or feedback loop.
        var dark = Lag.kr(damp.clip(0, 1).linlin(0, 1, 0.6, 0.9), 6);
        var space = FreeVerb2.ar(dry[0], dry[1], 1, 0.82, dark);
        var mix = Lag.kr(wet.clip(0, 0.65), 3);
        var mixed = (dry * (1 - mix)) + (LPF.ar(space, 2200) * mix);
        Out.ar(out, LeakDC.ar(mixed));
    }),
    SynthDef(\imolMaster, { |in=0, out=0, amp=0.5, gate=1, gainDb=0|
        var sig = In.ar(in, 2);
        // Fixed makeup gain preserves the voices' dynamics and pauses.
        var gain = Lag.kr(gainDb.clip(0, 30), 2).dbamp;
        var env = EnvGen.kr(Env.asr(0.1, 1, 0.5), gate, doneAction: 2);
        Out.ar(out, Limiter.ar(LeakDC.ar(sig) * Lag.kr(amp.clip(0, 1), 0.2) * gain, 0.85) * env);
    })
];
)
