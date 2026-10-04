import subprocess
import os

def run_cmd(cmd):
    print("Running:", " ".join(cmd) if isinstance(cmd, list) else cmd)
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if res.returncode != 0:
        print("ERROR:", res.stderr[-500:])
        raise RuntimeError(f"Command failed: {res.returncode}")
    return res

print("=== STARTING UGC VIDEO ASSEMBLY ===")

# SCENE 1: Hook (7.45s)
# YouTuber lady selfie + dynamic overlays + scene1.wav
cmd_s1 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_hook.jpg',
    '-loop', '1', '-i', 'ov_s1_1.png',
    '-loop', '1', '-i', 'ov_s1_2.png',
    '-i', 'scene1.wav',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov1];"
    "[2:v]scale=1080:1920[ov2];"
    "[base][ov1]overlay=0:0:enable='between(t,0,3.6)'[tmp1];"
    "[tmp1][ov2]overlay=0:0:enable='gte(t,3.6)'[v]",
    '-map', '[v]', '-map', '3:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.45',
    'scene1.mp4'
]
run_cmd(cmd_s1)
print("Scene 1 complete!")

# SCENE 2: The Solution & 80% Alert (9.10s)
# 0-4.2s: img_explain.jpg + ov_s2_1.png
# 4.2-9.10s (4.9s): app_clip2.mp4 + ov_s2_2.png
# Audio: scene2.wav
cmd_s2_part1 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_explain.jpg',
    '-loop', '1', '-i', 'ov_s2_1.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov1];"
    "[base][ov1]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '4.2',
    's2_p1.mp4'
]
run_cmd(cmd_s2_part1)

cmd_s2_part2 = [
    'ffmpeg', '-y',
    '-i', 'app_clip2.mp4',
    '-loop', '1', '-i', 'ov_s2_2.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=0x0F172A,fps=30[base];"
    "[1:v]scale=1080:1920[ov2];"
    "[base][ov2]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '4.9',
    's2_p2.mp4'
]
run_cmd(cmd_s2_part2)

# Join s2_p1 and s2_p2 with scene2.wav
with open('concat_s2.txt', 'w') as f:
    f.write("file 's2_p1.mp4'\nfile 's2_p2.mp4'\n")

cmd_s2_join = [
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_s2.txt',
    '-i', 'scene2.wav',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '9.10',
    'scene2.mp4'
]
run_cmd(cmd_s2_join)
print("Scene 2 complete!")

# SCENE 3: Anti-Theft Siren & Guardian Mode (9.35s)
# 0-4.3s: img_alert.jpg + ov_s3_1.png
# 4.3-9.35s (5.05s): app_demo.mp4 (starting at 4s) + ov_s3_2.png
# Audio: scene3.wav
cmd_s3_part1 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_alert.jpg',
    '-loop', '1', '-i', 'ov_s3_1.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov1];"
    "[base][ov1]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '4.3',
    's3_p1.mp4'
]
run_cmd(cmd_s3_part1)

cmd_s3_part2 = [
    'ffmpeg', '-y',
    '-ss', '3.5', '-i', 'app_demo.mp4',
    '-loop', '1', '-i', 'ov_s3_2.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=0x0F172A,fps=30[base];"
    "[1:v]scale=1080:1920[ov2];"
    "[base][ov2]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '5.05',
    's3_p2.mp4'
]
run_cmd(cmd_s3_part2)

with open('concat_s3.txt', 'w') as f:
    f.write("file 's3_p1.mp4'\nfile 's3_p2.mp4'\n")

cmd_s3_join = [
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_s3.txt',
    '-i', 'scene3.wav',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '9.35',
    'scene3.mp4'
]
run_cmd(cmd_s3_join)
print("Scene 3 complete!")

# SCENE 4: Telemetry & Volt Mascot (7.43s)
# 0-3.7s: app_demo.mp4 (start 0) + ov_s4_1.png
# 3.7-7.43s (3.73s): app_demo.mp4 + ov_s4_2.png
# Audio: scene4.wav
cmd_s4 = [
    'ffmpeg', '-y',
    '-i', 'app_demo.mp4',
    '-loop', '1', '-i', 'ov_s4_1.png',
    '-loop', '1', '-i', 'ov_s4_2.png',
    '-i', 'scene4.wav',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=0x0F172A,fps=30[base];"
    "[1:v]scale=1080:1920[ov1];"
    "[2:v]scale=1080:1920[ov2];"
    "[base][ov1]overlay=0:0:enable='between(t,0,3.7)'[tmp1];"
    "[tmp1][ov2]overlay=0:0:enable='gte(t,3.7)'[v]",
    '-map', '[v]', '-map', '3:a',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.43',
    'scene4.mp4'
]
run_cmd(cmd_s4)
print("Scene 4 complete!")

# SCENE 5: Outro & Download CTA (7.27s)
# 0-3.2s: img_cta.jpg + ov_s5_1.png
# 3.2-7.27s (4.07s): img_end.png (official App Icon, Play store badge, CTA)
# Audio: scene5.wav
cmd_s5_part1 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_cta.jpg',
    '-loop', '1', '-i', 'ov_s5_1.png',
    '-filter_complex',
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[base];"
    "[1:v]scale=1080:1920[ov1];"
    "[base][ov1]overlay=0:0[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '3.2',
    's5_p1.mp4'
]
run_cmd(cmd_s5_part1)

cmd_s5_part2 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'img_end.png',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '4.07',
    's5_p2.mp4'
]
run_cmd(cmd_s5_part2)

with open('concat_s5.txt', 'w') as f:
    f.write("file 's5_p1.mp4'\nfile 's5_p2.mp4'\n")

cmd_s5_join = [
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_s5.txt',
    '-i', 'scene5.wav',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '7.27',
    'scene5.mp4'
]
run_cmd(cmd_s5_join)
print("Scene 5 complete!")

# FINAL STAGE: Concatenate all 5 scenes
with open('concat_all.txt', 'w') as f:
    f.write("file 'scene1.mp4'\nfile 'scene2.mp4'\nfile 'scene3.mp4'\nfile 'scene4.mp4'\nfile 'scene5.mp4'\n")

cmd_concat_all = [
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_all.txt',
    '-c', 'copy',
    'ugc_video_raw.mp4'
]
run_cmd(cmd_concat_all)
print("Raw full video concatenated!")

# MIX WITH BACKGROUND MUSIC
# Duck background music to -20dB and combine with voiceover
cmd_final = [
    'ffmpeg', '-y',
    '-i', 'ugc_video_raw.mp4',
    '-i', 'bg_music.wav',
    '-filter_complex',
    "[1:a]volume=0.18[bg]; [0:a][bg]amix=inputs=2:duration=first:dropout_transition=2[aout]",
    '-map', '0:v', '-map', '[aout]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    'charge_alert_ugc_video.mp4'
]
run_cmd(cmd_final)
print("=== SUCCESS: charge_alert_ugc_video.mp4 GENERATED! ===")
