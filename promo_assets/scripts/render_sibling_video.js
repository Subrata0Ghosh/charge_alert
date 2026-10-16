/**
 * Charge Alert - Sibling Story Cartoon Promo Video Rendering Pipeline
 * Uses Puppeteer + FFmpeg
 * Renders sibling_promo_video.html into an MP4 video file.
 */

const fs = require('fs');
const path = require('path');
const { spawn, execSync } = require('child_process');
const puppeteer = require('puppeteer-core');
const { PuppeteerScreenRecorder } = require('puppeteer-screen-recorder');
const { generateSiblingAudio } = require('./generate_sibling_audio');

// ─── Command Line Arguments & Configuration ───
const args = process.argv.slice(2);

function getArg(name, defaultValue) {
  const index = args.indexOf(name);
  if (index !== -1 && index + 1 < args.length) {
    return args[index + 1];
  }
  return defaultValue;
}

const hasFlag = (name) => args.includes(name);

// Resolution: default 720x1280 (HD 9:16)
const resolutionArg = getArg('--resolution', '720x1280');
const [width, height] = resolutionArg.split('x').map(Number);
const fps = parseInt(getArg('--fps', '30'), 10);
const outputFile = path.resolve(getArg('--output', 'charge_alert_sibling_story.mp4'));
const includeMusic = !hasFlag('--no-music'); // Enabled by default if bg_music.wav exists
const keepTemp = hasFlag('--keep-temp');

// Chrome executable detection
function findChrome() {
  const candidates = [
    'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
    'C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe'
  ];
  for (const c of candidates) {
    if (fs.existsSync(c)) return c;
  }
  throw new Error('No compatible Chrome or Edge executable found.');
}

async function runPipeline() {
  console.log('====================================================');
  console.log('   CHARGE ALERT - SIBLING STORY VIDEO RENDERER      ');
  console.log('====================================================');
  console.log(`• Target Resolution : ${width}x${height} (9:16 Vertical)`);
  console.log(`• Frame Rate        : ${fps} FPS`);
  console.log(`• Output File       : ${outputFile}`);
  console.log(`• Background Music  : ${includeMusic ? 'Enabled' : 'Disabled'}`);
  console.log('----------------------------------------------------');

  const chromePath = findChrome();
  console.log(`[1/5] Launching Chrome: ${chromePath}...`);

  const browser = await puppeteer.launch({
    executablePath: chromePath,
    headless: 'new',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--autoplay-policy=no-user-gesture-required',
      `--window-size=${width},${height}`
    ]
  });

  const page = await browser.newPage();
  await page.setViewport({ width, height, deviceScaleFactor: 1 });

  // Load HTML
  const htmlFile = path.resolve(__dirname, 'sibling_promo_video.html');
  const htmlUrl = 'file:///' + htmlFile.replace(/\\/g, '/');
  console.log(`[2/5] Loading animation: ${htmlUrl}...`);
  await page.goto(htmlUrl, { waitUntil: 'networkidle0' });

  // Activate render-mode (full screen 9:16, no borders, no controls)
  await page.evaluate(() => {
    document.body.classList.add('render-mode');
  });

  const tempVideo = path.resolve(__dirname, 'temp_sibling_raw.mp4');
  const tempAudio = path.resolve(__dirname, 'temp_sibling_sfx.wav');

  if (fs.existsSync(tempVideo)) fs.unlinkSync(tempVideo);
  if (fs.existsSync(tempAudio)) fs.unlinkSync(tempAudio);

  const recorder = new PuppeteerScreenRecorder(page, {
    fps: fps,
    videoFrame: { width, height },
    aspectRatio: '16:9',
    videoCodec: 'libx264',
    videoCrf: 18,
    videoBitrate: 8000,
    videoPreset: 'fast',
    videOutputOptions: ['-pix_fmt yuv420p']
  });

  console.log(`[3/5] Recording animation frames at ${fps} FPS...`);
  await recorder.start(tempVideo);

  // Trigger animation start inside page
  await page.evaluate(() => {
    if (typeof startVideo === 'function') {
      startVideo();
    }
  });

  // Wait for the video to finish all scenes (including end card)
  await page.waitForFunction(() => window.videoEnded === true, {
    timeout: 90000,
    polling: 100
  });

  // Allow 1.5 seconds on the end card so it holds nicely
  await new Promise(resolve => setTimeout(resolve, 1500));

  console.log('[4/5] Finalizing video stream and stopping recorder...');
  await recorder.stop();
  await browser.close();

  // Get actual recorded video duration via ffprobe
  let recordedDuration = 31;
  try {
    const probeOut = execSync(
      `ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${tempVideo}"`,
      { encoding: 'utf-8' }
    ).trim();
    recordedDuration = parseFloat(probeOut) || 31;
    console.log(`• Captured video duration: ${recordedDuration.toFixed(2)}s`);
  } catch (e) {
    console.warn('Could not determine exact duration via ffprobe, using default 31s');
  }

  // Generate synchronized audio track
  console.log('[5/5] Synthesizing audio and muxing with FFmpeg...');
  generateSiblingAudio(tempAudio, recordedDuration);

  // FFmpeg Muxing command
  const bgMusicPath = path.resolve(__dirname, 'bg_music.wav');
  let ffmpegArgs = [];

  if (includeMusic && fs.existsSync(bgMusicPath)) {
    console.log('• Mixing sound effects with background music track...');
    ffmpegArgs = [
      '-y',
      '-i', tempVideo,
      '-i', tempAudio,
      '-i', bgMusicPath,
      '-filter_complex',
      '[1:a]volume=1.25[sfx];[2:a]volume=0.22[bgm];[sfx][bgm]amix=inputs=2:duration=first:dropout_transition=2[aout]',
      '-map', '0:v',
      '-map', '[aout]',
      '-c:v', 'copy',
      '-c:a', 'aac',
      '-b:a', '192k',
      '-shortest',
      outputFile
    ];
  } else {
    ffmpegArgs = [
      '-y',
      '-i', tempVideo,
      '-i', tempAudio,
      '-c:v', 'copy',
      '-c:a', 'aac',
      '-b:a', '192k',
      '-shortest',
      outputFile
    ];
  }

  await new Promise((resolve, reject) => {
    const proc = spawn('ffmpeg', ffmpegArgs, { stdio: 'inherit' });
    proc.on('close', code => {
      if (code === 0) resolve();
      else reject(new Error(`FFmpeg exited with code ${code}`));
    });
    proc.on('error', reject);
  });

  // Cleanup temporary files
  if (!keepTemp) {
    if (fs.existsSync(tempVideo)) fs.unlinkSync(tempVideo);
    if (fs.existsSync(tempAudio)) fs.unlinkSync(tempAudio);
  }

  const outStats = fs.statSync(outputFile);
  console.log('\n====================================================');
  console.log('   🎉 VIDEO RENDERING COMPLETED SUCCESSFULLY!       ');
  console.log('====================================================');
  console.log(`• Output File : ${outputFile}`);
  console.log(`• File Size   : ${(outStats.size / (1024 * 1024)).toFixed(2)} MB`);
  console.log(`• Resolution  : ${width}x${height}`);
  console.log(`• Ready for YouTube Shorts, Reels, TikTok & Play Store!`);
  console.log('====================================================\n');
}

runPipeline().catch(err => {
  console.error('\n❌ Video Rendering Failed:', err);
  process.exit(1);
});
