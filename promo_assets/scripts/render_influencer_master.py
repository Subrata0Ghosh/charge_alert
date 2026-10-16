import os
import subprocess
import sys

print("=== STARTING INFLUENCER FACECAM MASTER BUILD ===")

# Verify inputs
required_files = [
    'full_interactive_demo.mp4',
    'fc_talk.png', 'fc_smile.png', 'fc_alert.png', 'fc_cta.png',
    'fc_badge_compact.png',
    'cap1.png', 'cap2.png', 'cap3.png', 'cap4.png', 'cap5.png', 'cap6.png',
    'ugc_influencer_end_card.png',
    'influencer_master_voice.mp3',
    'assets/sounds/alarm.mp3',
    'bg_music.wav'
]

for f in required_files:
    if not os.path.exists(f):
        print(f"Error: Missing {f}")
        sys.exit(1)
print("All required assets verified!")

# Step 1: Render Part 1 (25.46s)
print("\n--- STEP 1: RENDERING PART 1 (Interactive Demo + Facecam + Dynamic Capsules) ---")
cmd_p1 = [
    'ffmpeg', '-y',
    '-i', 'full_interactive_demo.mp4',
    '-loop', '1', '-i', 'fc_talk.png',
    '-loop', '1', '-i', 'fc_smile.png',
    '-loop', '1', '-i', 'fc_alert.png',
    '-loop', '1', '-i', 'fc_badge_compact.png',
    '-loop', '1', '-i', 'cap1.png',
    '-loop', '1', '-i', 'cap2.png',
    '-loop', '1', '-i', 'cap3.png',
    '-loop', '1', '-i', 'cap4.png',
    '-loop', '1', '-i', 'cap5.png',
    '-loop', '1', '-i', 'cap6.png',
    '-filter_complex',
    # Scale background ambient blur
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=30:10,fps=30[bg];"
    # Crisp full height phone app
    "[0:v]scale=864:1920,fps=30[fg];"
    "[1:v]scale=280:280[fc_talk];"
    "[2:v]scale=280:280[fc_smile];"
    "[3:v]scale=280:280[fc_alert];"
    "[4:v]scale=200:36[badge];"
    "[5:v]scale=820:56[c1];"
    "[6:v]scale=820:56[c2];"
    "[7:v]scale=820:56[c3];"
    "[8:v]scale=820:56[c4];"
    "[9:v]scale=820:56[c5];"
    "[10:v]scale=820:56[c6];"
    # Compose app on ambient bg
    "[bg][fg]overlay=108:0[v0];"
    # Compose dynamic top capsules
    "[v0][c1]overlay=130:35:enable='lt(t,4.82)'[v1];"
    "[v1][c2]overlay=130:35:enable='between(t,4.82,9.67)'[v2];"
    "[v2][c3]overlay=130:35:enable='between(t,9.67,14.28)'[v3];"
    "[v3][c4]overlay=130:35:enable='between(t,14.28,18.53)'[v4];"
    "[v4][c5]overlay=130:35:enable='between(t,18.53,22.31)'[v5];"
    "[v5][c6]overlay=130:35:enable='gte(t,22.31)'[v6];"
    # Compose animated facecam (alternates talking/smiling, alert during siren)
    "[v6][fc_talk]overlay=780:1600:enable='(lt(t,18.53)+gt(t,22.31))*eq(mod(floor(t*3.5),2),0)'[v7];"
    "[v7][fc_smile]overlay=780:1600:enable='(lt(t,18.53)+gt(t,22.31))*eq(mod(floor(t*3.5),2),1)'[v8];"
    "[v8][fc_alert]overlay=780:1600:enable='between(t,18.53,22.31)'[v9];"
    # Badge over facecam
    "[v9][badge]overlay=820:1560[v_out]",
    '-map', '[v_out]',
    '-c:v', 'libx264', '-preset', 'medium', '-crf', '18', '-pix_fmt', 'yuv420p',
    '-t', '25.46',
    'ifc_p1.mp4'
]
subprocess.run(cmd_p1, check=True)
print("Part 1 rendered successfully!")

# Step 2: Render Part 2 (5.54s End Card + CTA Facecam)
print("\n--- STEP 2: RENDERING PART 2 (Outro End Card + CTA Facecam) ---")
cmd_p2 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'ugc_influencer_end_card.png',
    '-loop', '1', '-i', 'fc_cta.png',
    '-loop', '1', '-i', 'fc_badge_compact.png',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=280:280[fc];"
    "[2:v]scale=200:36[badge];"
    "[bg][fc]overlay=780:1600[v1];"
    "[v1][badge]overlay=820:1560[v_out]",
    '-map', '[v_out]',
    '-c:v', 'libx264', '-preset', 'medium', '-crf', '18', '-pix_fmt', 'yuv420p',
    '-t', '5.54',
    'ifc_p2.mp4'
]
subprocess.run(cmd_p2, check=True)
print("Part 2 rendered successfully!")

# Step 3: Concat video parts
print("\n--- STEP 3: CONCATENATING FULL VIDEO ---")
with open('ifc_concat.txt', 'w') as f:
    f.write("file 'ifc_p1.mp4'\nfile 'ifc_p2.mp4'\n")

subprocess.run(['ffmpeg', '-y', '-f', 'concat', '-safe', '0', '-i', 'ifc_concat.txt', '-c', 'copy', 'ifc_video_only.mp4'], check=True)
print("Video track concatenated!")

# Step 4: Mix Audio and Final Master
print("\n--- STEP 4: MASTERING FINAL VIDEO WITH MULTI-TRACK AUDIO ---")
cmd_master = [
    'ffmpeg', '-y',
    '-i', 'ifc_video_only.mp4',
    '-i', 'influencer_master_voice.mp3',
    '-i', 'assets/sounds/alarm.mp3',
    '-stream_loop', '-1', '-i', 'bg_music.wav',
    '-filter_complex',
    "[2:a]adelay=19200|19200,volume=0.85[alarm_delayed];"
    "[3:a]volume=0.12[bg];"
    "[1:a][alarm_delayed]amix=inputs=2:duration=first:dropout_transition=1[voice_siren];"
    "[voice_siren][bg]amix=inputs=2:duration=first:dropout_transition=2[aout]",
    '-map', '0:v', '-map', '[aout]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '256k',
    '-t', '31.00',
    '-movflags', '+faststart',
    'charge_alert_influencer_facecam.mp4'
]
subprocess.run(cmd_master, check=True)
print("\n=== SUCCESS: charge_alert_influencer_facecam.mp4 RENDERED SUCCESSFULLY! ===")
