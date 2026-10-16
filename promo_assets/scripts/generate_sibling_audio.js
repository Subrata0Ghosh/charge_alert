const fs = require('fs');
const path = require('path');

/**
 * Generates synchronized sound effects WAV file for the Sibling Story promo video.
 * Matches sibling_promo_video.html scene transitions and dramatic beats.
 */
function generateSiblingAudio(outputPath = 'sibling_sfx.wav', totalSeconds = 31) {
  const sampleRate = 44100;
  const numChannels = 2; // Stereo
  const bytesPerSample = 2; // 16-bit PCM
  const totalSamples = Math.ceil(sampleRate * totalSeconds);

  // Left and Right channel float buffers (-1.0 to 1.0)
  const left = new Float32Array(totalSamples);
  const right = new Float32Array(totalSamples);

  function addTone(startTime, duration, freq, type = 'sine', volume = 0.15, pan = 0.0) {
    const startSample = Math.floor(startTime * sampleRate);
    const lengthSamples = Math.floor(duration * sampleRate);
    const endSample = Math.min(totalSamples, startSample + lengthSamples);

    const leftGain = Math.cos((pan + 1) * Math.PI / 4);
    const rightGain = Math.sin((pan + 1) * Math.PI / 4);

    for (let i = startSample; i < endSample; i++) {
      const t = (i - startSample) / sampleRate;
      // Exponential decay
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
      left[i] += sample * leftGain;
      right[i] += sample * rightGain;
    }
  }

  // Comedic tiptoe / sneak sound
  function addTiptoe(startTime, count = 5) {
    const notes = [220, 247, 262, 294, 330];
    for (let i = 0; i < count; i++) {
      const t = startTime + i * 0.45;
      addTone(t, 0.15, notes[i % notes.length], 'triangle', 0.14, (i % 2 === 0 ? -0.3 : 0.3));
    }
  }

  // Cartoon boing / surprise shock pitch bend
  function addCartoonBoing(startTime, duration = 0.45, startFreq = 200, endFreq = 650, volume = 0.22) {
    const startSample = Math.floor(startTime * sampleRate);
    const lengthSamples = Math.floor(duration * sampleRate);
    const endSample = Math.min(totalSamples, startSample + lengthSamples);

    let phase = 0;
    for (let i = startSample; i < endSample; i++) {
      const t = (i - startSample) / sampleRate;
      const curFreq = startFreq + (endFreq - startFreq) * Math.sin((t / duration) * (Math.PI / 2));
      phase += 2 * Math.PI * curFreq / sampleRate;
      const decay = Math.exp(-t * 4);
      const wave = Math.sin(phase);
      const sample = wave * volume * decay;
      left[i] += sample;
      right[i] += sample;
    }
  }

  // ─── Scene 1: Sister studying peacefully (t = 0.0s) ───
  // Gentle ambient study chime
  addTone(0.2, 0.6, 523.25, 'sine', 0.12, -0.2); // C5
  addTone(0.5, 0.6, 659.25, 'sine', 0.12, 0.2);  // E5
  addTone(0.8, 0.8, 783.99, 'sine', 0.15, 0.0);  // G5

  // ─── Scene 2: Mischievous brother sneaks in (t = 4.2s) ───
  addTiptoe(4.4, 6);

  // ─── Scene 3: Unplugging cable swap (t = 8.2s) ───
  // Snick / pull click
  addTone(8.3, 0.08, 450, 'sawtooth', 0.18, 0.1);
  addTone(8.4, 0.18, 180, 'sawtooth', 0.22, 0.2);
  // Suspense riser
  addCartoonBoing(8.8, 0.5, 220, 440, 0.15);

  // ─── Scene 4: CHARGE ALERT ALARM BLASTS! (t = 12.0s to 16.4s) ───
  // Jump scare shock sound
  addCartoonBoing(12.0, 0.4, 250, 800, 0.25);
  // Pulsing rapid anti-theft alarm sirens
  const alarmStart = 12.2;
  const alarmEnd = 16.2;
  let toggle = true;
  for (let t = alarmStart; t < alarmEnd; t += 0.22) {
    const f1 = toggle ? 940 : 700;
    const f2 = toggle ? 1175 : 880;
    addTone(t, 0.18, f1, 'square', 0.24, toggle ? -0.3 : 0.3);
    addTone(t, 0.18, f2, 'sawtooth', 0.12, toggle ? 0.3 : -0.3);
    toggle = !toggle;
  }

  // ─── Scene 5: Caught red-handed! Laugh & sibling tease (t = 16.8s) ───
  // Funny comic slide down (wah-wah trombone tease)
  addTone(17.0, 0.35, 466.16, 'triangle', 0.16); // Bb4
  addTone(17.4, 0.35, 440.00, 'triangle', 0.16); // A4
  addTone(17.8, 0.35, 415.30, 'triangle', 0.16); // Ab4
  addTone(18.2, 0.65, 392.00, 'triangle', 0.18); // G4
  // Playful chuckle chime
  addTone(19.2, 0.25, 587.33, 'sine', 0.14);
  addTone(19.45, 0.25, 739.99, 'sine', 0.15);

  // ─── Scene 6: Sweet sibling bond & app showcase (t = 21.2s) ───
  // Heartwarming progression (D - F# - A - D)
  addTone(21.4, 0.5, 587.33, 'sine', 0.15, -0.2); // D5
  addTone(21.8, 0.5, 739.99, 'sine', 0.16, 0.2);  // F#5
  addTone(22.2, 0.5, 880.00, 'sine', 0.18, -0.1); // A5
  addTone(22.6, 0.9, 1174.66, 'sine', 0.20, 0.0); // D6
  // Sparkle
  addTone(23.6, 0.4, 987.77, 'sine', 0.14, 0.3);
  addTone(23.9, 0.6, 1318.51, 'sine', 0.16, -0.3);

  // ─── Scene 7: Outro End Card (t = 25.8s) ───
  // Grand friendly finale fanfare
  addTone(26.0, 0.25, 659.25, 'sine', 0.18, -0.3); // E5
  addTone(26.25, 0.25, 783.99, 'sine', 0.18, 0.3); // G5
  addTone(26.5, 0.35, 1046.50, 'sine', 0.22, 0.0); // C6
  addTone(26.9, 0.8, 1318.51, 'sine', 0.24, 0.0);  // E6

  // ─── Encode to 16-bit PCM WAV File ───
  const dataSize = totalSamples * numChannels * bytesPerSample;
  const buffer = Buffer.alloc(44 + dataSize);

  // RIFF Chunk
  buffer.write('RIFF', 0);
  buffer.writeUInt32LE(36 + dataSize, 4);
  buffer.write('WAVE', 8);

  // "fmt " sub-chunk
  buffer.write('fmt ', 12);
  buffer.writeUInt32LE(16, 16); // SubChunk1Size (16 for PCM)
  buffer.writeUInt16LE(1, 20);  // AudioFormat (1 = PCM)
  buffer.writeUInt16LE(numChannels, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(sampleRate * numChannels * bytesPerSample, 28); // ByteRate
  buffer.writeUInt16LE(numChannels * bytesPerSample, 32);             // BlockAlign
  buffer.writeUInt16LE(bytesPerSample * 8, 34);                       // BitsPerSample (16)

  // "data" sub-chunk
  buffer.write('data', 36);
  buffer.writeUInt32LE(dataSize, 40);

  // Write samples with limiter / soft clipping
  let offset = 44;
  for (let i = 0; i < totalSamples; i++) {
    let sL = Math.max(-1.0, Math.min(1.0, left[i]));
    let sR = Math.max(-1.0, Math.min(1.0, right[i]));

    // Soft knee limiter
    sL = Math.tanh(sL);
    sR = Math.tanh(sR);

    const intL = sL < 0 ? Math.floor(sL * 32768) : Math.floor(sL * 32767);
    const intR = sR < 0 ? Math.floor(sR * 32768) : Math.floor(sR * 32767);

    buffer.writeInt16LE(intL, offset);
    buffer.writeInt16LE(intR, offset + 2);
    offset += 4;
  }

  fs.writeFileSync(path.resolve(outputPath), buffer);
  console.log(`✓ Generated Sibling Story audio SFX: ${outputPath} (${totalSeconds}s, ${(buffer.length / 1024).toFixed(1)} KB)`);
}

module.exports = { generateSiblingAudio };

if (require.main === module) {
  generateSiblingAudio('test_sibling_sfx.wav', 31);
}
