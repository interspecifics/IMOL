// Relative to imol_light. Set audioFolder to an absolute folder if desired.
// Portable bank: run tools/prepare_audio.py once after installing Python dependencies.
(
    audioFolder: "assets/audio",
    oscPort: 9001,
    device: nil,
    outputChannels: 2,
    outputBus: 0,
    master: 0.30,
    outputGainDb: 24, // Compensate the quiet ambient mix before the output limiter (0..30 dB).
    spectralLevel: 0.10,
    granularLevel: 0.14,
    grooveLevel: 0.10,
    reflectionLevel: 0.10,
    spectralHoldSeconds: 8, // Minimum time between banks of the same recording.
    sampleHoldSeconds: 12, // Minimum time between sample replacements.
    sampleSettleSeconds: 1.5, // A new sample selection must remain stable this long.
    reflectionTimeout: 3.0, // Fade when camera/OSC updates stop.
    monitor: true, // OSC reception, real audio meters, Solo/Mute and granular details.
    // Limit resident memory and avoid phase precision loss on very long files.
    // v0.1 reads the first 60 seconds; all scene start ranges fit within it.
    sampleSeconds: 60
)
