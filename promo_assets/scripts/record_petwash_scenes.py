import subprocess
import time
import os

adb = r"C:\Users\sulat\AppData\Local\Android\Sdk\platform-tools\adb.exe"

def run_adb(args):
    return subprocess.run([adb] + args, capture_output=True, text=True)

def record_clip(remote_path, duration_sec, action_fn):
    run_adb(['shell', 'rm', '-f', remote_path])
    p = subprocess.Popen([adb, 'shell', f'screenrecord --time-limit {duration_sec} {remote_path}'])
    time.sleep(1.0)
    action_fn()
    p.wait()
    time.sleep(0.5)

print("Starting emulator scene recording...")

# Ensure app is in front
run_adb(['shell', 'am', 'start', '-n', 'com.technorchid.charge_alert/.MainActivity'])
time.sleep(1.5)

# 1. SCENE: DECLARE & ASSESS (Volt hot/distressed at 48°C)
def action_declare():
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'status', '3'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'ac', '0'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'temp', '480'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'level', '24'])
    time.sleep(1.0)
    # Tap Volt to make him react
    run_adb(['shell', 'input', 'tap', '540', '580'])
    time.sleep(2.0)
    run_adb(['shell', 'input', 'tap', '540', '580'])
    time.sleep(2.0)

print("Recording clip_declare.mp4 (7s)...")
record_clip('/sdcard/clip_declare.mp4', 7, action_declare)
run_adb(['pull', '/sdcard/clip_declare.mp4', 'clip_declare.mp4'])
print("clip_declare.mp4 saved:", os.path.exists('clip_declare.mp4'))

# 2. SCENE: ISOLATE (Slide 80% threshold & toggle controls)
def action_isolate():
    # Slide alert percentage smoothly from 50% to 80%
    run_adb(['shell', 'input', 'swipe', '350', '2234', '750', '2234', '600'])
    time.sleep(1.0)
    # Tap Volt
    run_adb(['shell', 'input', 'tap', '540', '580'])
    time.sleep(1.5)
    # Plug in AC
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'status', '2'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'ac', '1'])
    time.sleep(1.0)

print("Recording clip_isolate.mp4 (6s)...")
record_clip('/sdcard/clip_isolate.mp4', 6, action_isolate)
run_adb(['pull', '/sdcard/clip_isolate.mp4', 'clip_isolate.mp4'])
print("clip_isolate.mp4 saved:", os.path.exists('clip_isolate.mp4'))

# 3. SCENE: PROCESS (Liquid core wave, Volt happy floating)
def action_process():
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'status', '2'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'ac', '1'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'temp', '290'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'level', '72'])
    time.sleep(1.0)
    # Tap Volt to wave and float
    run_adb(['shell', 'input', 'tap', '540', '580'])
    time.sleep(2.5)
    run_adb(['shell', 'input', 'tap', '540', '580'])
    time.sleep(2.5)

print("Recording clip_process.mp4 (7s)...")
record_clip('/sdcard/clip_process.mp4', 7, action_process)
run_adb(['pull', '/sdcard/clip_process.mp4', 'clip_process.mp4'])
print("clip_process.mp4 saved:", os.path.exists('clip_process.mp4'))

# 4. SCENE: BUILD & REVEAL (Climbing to 80% and alarm trigger)
def action_build_reveal():
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'status', '2'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'ac', '1'])
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'level', '78'])
    time.sleep(1.5)
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'level', '79'])
    time.sleep(1.5)
    run_adb(['shell', 'dumpsys', 'battery', 'set', 'level', '80'])
    time.sleep(1.5)
    # Volt celebration reaction
    run_adb(['shell', 'input', 'tap', '540', '580'])
    time.sleep(3.0)

print("Recording clip_reveal.mp4 (9s)...")
record_clip('/sdcard/clip_reveal.mp4', 9, action_build_reveal)
run_adb(['pull', '/sdcard/clip_reveal.mp4', 'clip_reveal.mp4'])
print("clip_reveal.mp4 saved:", os.path.exists('clip_reveal.mp4'))

# Reset battery state
run_adb(['shell', 'dumpsys', 'battery', 'reset'])
print("All emulator clips recorded successfully!")
