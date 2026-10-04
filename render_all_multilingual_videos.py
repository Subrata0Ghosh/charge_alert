import subprocess
import os

def run(cmd):
    print(">>", " ".join(cmd) if isinstance(cmd, list) else cmd)
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if res.returncode != 0:
        print("ERROR:", res.stderr[-600:])
        raise RuntimeError(f"FFmpeg failed with code {res.returncode}")
    return res

print("=== STARTING MASTER MULTILINGUAL VIDEO PRODUCTION ===")

# ==========================================
# 1. BUILD HINDI EDITION VIDEO (35.7s)
# ==========================================
print("\n--- BUILDING HINDI EDITION ---")

# Hi Scene 1: 7.56s (img_hook_hi.jpg + ov_hi_1.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_hook_hi.jpg',
    '-loop', '1', '-i', 'ov_hi_1.png',
    '-i', 'hi_s1.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov];"
    "[base][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '2:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.56',
    'hi_cut1.mp4'
])

# Hi Scene 2: 11.35s (app_demo.mp4 inside phone mockup + ov_hi_2.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-ss', '1.0', '-i', 'app_demo.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_hi_2.png',
    '-i', 'hi_s2.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '11.35',
    'hi_cut2.mp4'
])

# Hi Scene 3: 9.19s (app_clip2.mp4 inside phone mockup + ov_hi_3.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-i', 'app_clip2.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_hi_3.png',
    '-i', 'hi_s3.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '9.19',
    'hi_cut3.mp4'
])

# Hi Scene 4: 7.58s (0-3s: img_cta.jpg + ov_hi_4.png, 3-7.58s: ugc_end_card_hi.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_cta.jpg',
    '-loop', '1', '-i', 'ov_hi_4.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov];"
    "[base][ov]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '3.0',
    'hi_s4_p1.mp4'
])

run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'ugc_end_card_hi.png',
    '-filter_complex', "[0:v]scale=1080:1920,fps=30[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '4.58',
    'hi_s4_p2.mp4'
])

with open('concat_hi_s4.txt', 'w') as f:
    f.write("file 'hi_s4_p1.mp4'\nfile 'hi_s4_p2.mp4'\n")

run([
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_hi_s4.txt',
    '-i', 'hi_s4.mp3',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.58',
    'hi_cut4.mp4'
])

# Concat Hindi Scenes
with open('concat_hi.txt', 'w') as f:
    f.write("file 'hi_cut1.mp4'\nfile 'hi_cut2.mp4'\nfile 'hi_cut3.mp4'\nfile 'hi_cut4.mp4'\n")

run([
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_hi.txt',
    '-c', 'copy',
    'hi_raw.mp4'
])

# Mix with background music
run([
    'ffmpeg', '-y',
    '-i', 'hi_raw.mp4',
    '-i', 'bg_music.wav',
    '-filter_complex',
    "[1:a]volume=0.18[bg]; [0:a][bg]amix=inputs=2:duration=first:dropout_transition=2[aout]",
    '-map', '0:v', '-map', '[aout]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    'charge_alert_hindi_video.mp4'
])
print(">>> SUCCESS: charge_alert_hindi_video.mp4 generated!")

# ==========================================
# 2. BUILD BENGALI EDITION VIDEO (35.5s)
# ==========================================
print("\n--- BUILDING BENGALI EDITION ---")

# Bn Scene 1: 8.98s (img_hook_bn.jpg + ov_bn_1.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_hook_bn.jpg',
    '-loop', '1', '-i', 'ov_bn_1.png',
    '-i', 'bn_s1.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov];"
    "[base][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '2:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '8.98',
    'bn_cut1.mp4'
])

# Bn Scene 2: 8.69s (app_clip2.mp4 inside phone mockup + ov_bn_2.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-i', 'app_clip2.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_bn_2.png',
    '-i', 'bn_s2.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '8.69',
    'bn_cut2.mp4'
])

# Bn Scene 3: 8.66s (app_demo.mp4 inside phone mockup + ov_bn_3.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-ss', '0.5', '-i', 'app_demo.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_bn_3.png',
    '-i', 'bn_s3.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '8.66',
    'bn_cut3.mp4'
])

# Bn Scene 4: 9.19s (0-3.2s: img_cta.jpg + ov_bn_4.png, 3.2-9.19s: ugc_end_card_bn.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_cta.jpg',
    '-loop', '1', '-i', 'ov_bn_4.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov];"
    "[base][ov]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '3.2',
    'bn_s4_p1.mp4'
])

run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'ugc_end_card_bn.png',
    '-filter_complex', "[0:v]scale=1080:1920,fps=30[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '5.99',
    'bn_s4_p2.mp4'
])

with open('concat_bn_s4.txt', 'w') as f:
    f.write("file 'bn_s4_p1.mp4'\nfile 'bn_s4_p2.mp4'\n")

run([
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_bn_s4.txt',
    '-i', 'bn_s4.mp3',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '9.19',
    'bn_cut4.mp4'
])

with open('concat_bn.txt', 'w') as f:
    f.write("file 'bn_cut1.mp4'\nfile 'bn_cut2.mp4'\nfile 'bn_cut3.mp4'\nfile 'bn_cut4.mp4'\n")

run([
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_bn.txt',
    '-c', 'copy',
    'bn_raw.mp4'
])

run([
    'ffmpeg', '-y',
    '-i', 'bn_raw.mp4',
    '-i', 'bg_music.wav',
    '-filter_complex',
    "[1:a]volume=0.18[bg]; [0:a][bg]amix=inputs=2:duration=first:dropout_transition=2[aout]",
    '-map', '0:v', '-map', '[aout]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    'charge_alert_bengali_video.mp4'
])
print(">>> SUCCESS: charge_alert_bengali_video.mp4 generated!")

# ==========================================
# 3. BUILD ENGLISH CYBERPUNK MOTION VIDEO (41.9s)
# ==========================================
print("\n--- BUILDING ENGLISH CYBERPUNK MOTION EDITION ---")

# En Scene 1: 7.66s (img_hook.jpg + ov_en_1.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_hook.jpg',
    '-loop', '1', '-i', 'ov_en_1.png',
    '-i', 'en_s1.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov];"
    "[base][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '2:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.66',
    'en_cut1.mp4'
])

# En Scene 2: 8.78s (app_clip2.mp4 inside phone mockup + ov_en_2.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-i', 'app_clip2.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_en_2.png',
    '-i', 'en_s2.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '8.78',
    'en_cut2.mp4'
])

# En Scene 3: 10.01s (app_demo.mp4 inside phone mockup + ov_en_3.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-ss', '1.5', '-i', 'app_demo.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_en_3.png',
    '-i', 'en_s3.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '10.01',
    'en_cut3.mp4'
])

# En Scene 4: 8.18s (app_demo.mp4 telemetry inside phone mockup + ov_en_4.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'bg_dark.png',
    '-ss', '0.0', '-i', 'app_demo.mp4',
    '-loop', '1', '-i', 'phone_frame.png',
    '-loop', '1', '-i', 'ov_en_4.png',
    '-i', 'en_s4.mp3',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=724:1464,fps=30[screen];"
    "[2:v]scale=1080:1920[frame];"
    "[3:v]scale=1080:1920[ov];"
    "[bg][screen]overlay=178:238[step1];"
    "[step1][frame]overlay=0:0[step2];"
    "[step2][ov]overlay=0:0[v]",
    '-map', '[v]', '-map', '4:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '8.18',
    'en_cut4.mp4'
])

# En Scene 5: 7.32s (0-3.0s: img_cta.jpg + ov_en_5.png, 3.0-7.32s: ugc_end_card.png)
run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_cta.jpg',
    '-loop', '1', '-i', 'ov_en_5.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov];"
    "[base][ov]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '3.0',
    'en_s5_p1.mp4'
])

run([
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'ugc_end_card.png',
    '-filter_complex', "[0:v]scale=1080:1920,fps=30[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '4.32',
    'en_s5_p2.mp4'
])

with open('concat_en_s5.txt', 'w') as f:
    f.write("file 'en_s5_p1.mp4'\nfile 'en_s5_p2.mp4'\n")

run([
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_en_s5.txt',
    '-i', 'en_s5.mp3',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.32',
    'en_cut5.mp4'
])

with open('concat_en.txt', 'w') as f:
    f.write("file 'en_cut1.mp4'\nfile 'en_cut2.mp4'\nfile 'en_cut3.mp4'\nfile 'en_cut4.mp4'\nfile 'en_cut5.mp4'\n")

run([
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_en.txt',
    '-c', 'copy',
    'en_raw.mp4'
])

run([
    'ffmpeg', '-y',
    '-i', 'en_raw.mp4',
    '-i', 'bg_music.wav',
    '-filter_complex',
    "[1:a]volume=0.18[bg]; [0:a][bg]amix=inputs=2:duration=first:dropout_transition=2[aout]",
    '-map', '0:v', '-map', '[aout]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    'charge_alert_cyberpunk_motion_video.mp4'
])
print(">>> SUCCESS: charge_alert_cyberpunk_motion_video.mp4 generated!")

print("\n=== ALL 3 MULTILINGUAL VIDEOS PRODUCED SUCCESSFULLY! ===")
