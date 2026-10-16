import subprocess
import os

print("Synthesizing cinematic SFX using ffmpeg...")

# 1. Glitch / Shock impact for DECLARE (Phase 1)
subprocess.run([
    'ffmpeg', '-y', '-f', 'lavfi',
    '-i', 'sine=frequency=120:duration=0.6,afade=t=out:st=0.1:d=0.5',
    'sfx_shock.wav'
], check=True)

# 2. Tech Scanner Beep for ASSESS (Phase 2)
subprocess.run([
    'ffmpeg', '-y', '-f', 'lavfi',
    '-i', 'sine=frequency=1800:duration=0.15,afade=t=out:st=0.05:d=0.1',
    'sfx_scan.wav'
], check=True)

# 3. Crisp Switch Click for ISOLATE (Phase 3)
subprocess.run([
    'ffmpeg', '-y', '-f', 'lavfi',
    '-i', 'sine=frequency=800:duration=0.08,afade=t=out:st=0.02:d=0.06',
    'sfx_click.wav'
], check=True)

# 4. Electric Connection Zap for PROCESS (Phase 4)
subprocess.run([
    'ffmpeg', '-y', '-f', 'lavfi',
    '-i', 'sine=frequency=440:duration=0.3,tremolo=f=40:d=0.8,afade=t=out:st=0.1:d=0.2',
    'sfx_zap.wav'
], check=True)

# 5. Energy Riser Sweep for BUILD (Phase 5)
# Generates a frequency sweep from 300Hz to 1200Hz over 3 seconds
subprocess.run([
    'ffmpeg', '-y', '-f', 'lavfi',
    '-i', 'anoisesrc=d=3:c=pink:a=0.15,bandpass=f=800:width_type=h:w=300,afade=t=in:st=0:d=1,afade=t=out:st=2.5:d=0.5',
    'sfx_riser.wav'
], check=True)

# 6. Sparkle Chime for REVEAL (Phase 6)
subprocess.run([
    'ffmpeg', '-y', '-f', 'lavfi',
    '-i', 'sine=frequency=2400:duration=0.5,afade=t=out:st=0.1:d=0.4',
    'sfx_chime.wav'
], check=True)

print("All sound effects created successfully!")
