// Relative to imol_light. Set audioFolder to an absolute folder if desired.
// Portable bank: run tools/prepare_audio.py once after installing Python dependencies.
(
    audioFolder: "assets/audio",
    oscPort: 9001,
    device: nil,
    outputChannels: 2,
    outputBus: 0,
    master: 0.35,
    spectralLevel: 0.12,
    granularLevel: 0.20,
    grooveLevel: 0.15,
    reflectionLevel: 0.18,
    reflectionTimeout: 3.0, // Fade when camera/OSC updates stop.
    monitor: true, // OSC reception, real audio meters, Solo/Mute and granular details.
    // Limit resident memory and avoid phase precision loss on very long files.
    // v0.1 reads the first 60 seconds; all scene start ranges fit within it.
    sampleSeconds: 60
)
