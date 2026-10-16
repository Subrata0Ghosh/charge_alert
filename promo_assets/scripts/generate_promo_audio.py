import urllib.request
import urllib.parse
import subprocess
import os

lines = [
    ("vo_1", "Stop charging your phone overnight! You are literally boiling your battery alive."),
    ("vo_2", "Extreme heat destroys lithium battery cells permanently. Look at Volt running hot at forty-eight degrees!"),
    ("vo_3", "Isolate the danger! Set your smart limit to eighty percent and arm Guardian anti-theft protection."),
    ("vo_4", "Now plug in. Volt wakes up and guards your device with real-time liquid current monitoring."),
    ("vo_5", "Watch the charge climb smoothly to eighty percent... almost at the golden safe zone!"),
    ("vo_6", "Target reached! Unplug now for three times longer battery life. Download Charge Alert free on Google Play!")
]

print("Generating voiceover audio files...")
for name, text in lines:
    fname = f"{name}.mp3"
    url = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=" + urllib.parse.quote(text)
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as resp, open(fname, 'wb') as f:
        f.write(resp.read())
    
    # Check duration with ffprobe
    r = subprocess.run([
        'ffprobe', '-v', 'error', '-show_entries', 'format=duration',
        '-of', 'default=noprint_wrappers=1:nokey=1', fname
    ], stdout=subprocess.PIPE, text=True)
    dur = float(r.stdout.strip())
    print(f"{fname}: {dur:.2f}s -> {text}")

print("All voiceover files generated successfully!")
