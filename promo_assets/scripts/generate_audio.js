const fs = require('fs');
const path = require('path');

/**
 * Generates the synchronized sound effects WAV file matching
 * cartoon_promo_video.html exactly.
 */
function generatePromoAudio(outputPath = 'cartoon_sfx.wav', totalSeconds = 27) {
  const sampleRate = 44100;
  const numChannels = 2; // Stereo
  const bytesPerSample = 2; // 16-bit PCM
  const totalSamples = Math.ceil(sampleRate * totalSeconds);
  
  // Left and Right channel float buffers (-1.0 to 1.0)
  const left = new Float32Array(totalSamples);
  const right = new Float32Array(totalSamples);

  function addTone(startTime, duration, freq, type = 'sine', volume = 0.15) {
    const startSample = Math.floor(startTime * sampleRate);
    const lengthSamples = Math.floor(duration * sampleRate);
    const endSample = Math.min(totalSamples, startSample + lengthSamples);

    for (let i = startSample; i < endSample; i++) {
      const t = (i - startSample) / sampleRate;
      // Exponential decay from volume to ~0.001
      const decay = Math.exp(-t * (Math.log(volume / 0.001) / duration));
      const currentVol = volume * decay;

      let wave = 0;
      const phase = 2 * Math.PI * freq * t;
      if (type === 'sine') {
        wave = Math.sin(phase);
      } else if (type === 'triangle') {
        wave = (2 / Math.PI) * Math.asin(Math.sin(phase));
      } else if (type === 'square') {
        wave = Math.sin(phase) >= 0 ? 1 : -1;
      } else if (type === 'sawtooth') {
        wave = 2 * ((freq * t) % 1) - 1;
      }

      const sample = wave * currentVol;
      left[i] += sample;
      right[i] += sample;
    }
  }

  function addSiren(startTime, duration = 1.5, startFreq = 400, peakFreq = 800, volume = 0.12) {
    const startSample = Math.floor(startTime * sampleRate);
    const lengthSamples = Math.floor(duration * sampleRate);
    const endSample = Math.min(totalSamples, startSample + lengthSamples);

    let phase = 0;
    for (let i = startSample; i < endSample; i++) {
      const t = (i - startSample) / sampleRate;
      let currentFreq;
      if (t < 0.5) {
        currentFreq = startFreq + (peakFreq - startFreq) * (t / 0.5);
      } else if (t < 1.0) {
        currentFreq = peakFreq - (peakFreq - startFreq) * ((t - 0.5) / 0.5);
      } else {
        currentFreq = startFreq;
      }

      phase += 2 * Math.PI * currentFreq / sampleRate;
      const decay = Math.exp(-t * 2.5);
      const wave = 2 * ((phase / (2 * Math.PI)) % 1) - 1; // Sawtooth
      const sample = wave * volume * decay;

      left[i] += sample;
      right[i] += sample;
    }
  }

  // ─── Scene 0: Thief Sneaking (t = 0.0s) ───
  addTone(0.0, 0.3, 200, 'triangle', 0.15);
  addTone(0.3, 0.2, 180, 'triangle', 0.12);

  // ─── Scene 1: Thief Grabbing / Unplugging (t = 4.4s) ───
  addTone(4.4, 0.15, 300, 'sawtooth', 0.16);
  addTone(4.5, 0.25, 150, 'sawtooth', 0.18);

  // ─── Scene 2: Alarm Triggered! (t = 8.3s, 4 seconds of alarm beeps) ───
  const alarmStart = 8.3;
  addTone(alarmStart, 0.2, 880, 'square', 0.22);
  let high = false;
  for (let beep = 1; beep < 16; beep++) {
    const beepTime = alarmStart + beep * 0.25;
    const freq = high ? 988 : 784;
    addTone(beepTime, 0.2, freq, 'square', 0.22);
    high = !high;
  }

  // ─── Scene 3: Thief Running / Police Sirens (t = 12.7s) ───
  addSiren(12.7, 1.5, 400, 850, 0.18);
  addSiren(14.3, 1.5, 400, 850, 0.18);

  // ─── Scene 4: Police Caught Him / Fanfare (t = 16.6s) ───
  addTone(16.6, 0.2, 523, 'sine', 0.16);
  addTone(16.8, 0.2, 659, 'sine', 0.16);
  addTone(17.0, 0.3, 784, 'sine', 0.18);
  addTone(17.25, 0.5, 1047, 'sine', 0.22);

  // ─── Scene 5: End Card Chime (t = 21.0s) ───
  addTone(21.0, 0.3, 659, 'sine', 0.15);
  addTone(21.25, 0.3, 784, 'sine', 0.15);
  addTone(21.5, 0.6, 1047, 'sine', 0.20);

  // Convert Float32 to 16-bit PCM Buffer with WAV header
  const dataByteLength = totalSamples * numChannels * bytesPerSample;
  const buffer = Buffer.alloc(44 + dataByteLength);

  // RIFF Chunk Descriptor
  buffer.write('RIFF', 0);
  buffer.writeUInt32LE(36 + dataByteLength, 4);
  buffer.write('WAVE', 8);

  // "fmt " Sub-chunk
  buffer.write('fmt ', 12);
  buffer.writeUInt32LE(16, 16); // Subchunk1Size (16 for PCM)
  buffer.writeUInt16LE(1, 20);  // AudioFormat (1 for PCM)
  buffer.writeUInt16LE(numChannels, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(sampleRate * numChannels * bytesPerSample, 28); // ByteRate
  buffer.writeUInt16LE(numChannels * bytesPerSample, 32); // BlockAlign
  buffer.writeUInt16LE(16, 34); // BitsPerSample

  // "data" Sub-chunk
  buffer.write('data', 36);
  buffer.writeUInt32LE(dataByteLength, 40);

  // Interleave L and R channels as int16
  let offset = 44;
  for (let i = 0; i < totalSamples; i++) {
    // Clamp sample between -1 and 1
    const l = Math.max(-1, Math.min(1, left[i]));
    const r = Math.max(-1, Math.min(1, right[i]));

    const intL = l < 0 ? l * 32768 : l * 32767;
    const intR = r < 0 ? r * 32768 : r * 32767;

    buffer.writeInt16LE(Math.floor(intL), offset);
    buffer.writeInt16LE(Math.floor(intR), offset + 2);
    offset += 4;
  }

  fs.writeFileSync(outputPath, buffer);
  console.log(`[Audio] Generated WAV: ${outputPath} (${(buffer.length / (1024 * 1024)).toFixed(2)} MB, ${totalSeconds}s)`);
  return outputPath;
}

if (require.main === module) {
  generatePromoAudio('test_audio.wav', 27);
}

module.exports = { generatePromoAudio };
