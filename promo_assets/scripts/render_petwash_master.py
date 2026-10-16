import subprocess
import os
import sys

print("=== STARTING MASTER PROMOTION VIDEO ASSEMBLY (PET WASH NARRATIVE ARC) ===")

scenes = [
    {
        "name": "scene1_declare",
        "video": "clip_declare.mp4",
        "ss": "0.0",
        "dur": "4.8",
        "overlay": "overlay_stage_1.png",
        "vo": "vo_1.mp3",
        "sfx": "sfx_shock.wav",
        "sfx_delay": 0.0,
        "zoom": False
    },
    {
        "name": "scene2_assess",
        "video": "clip_declare.mp4",
        "ss": "1.2",
        "dur": "5.2",
        "overlay": "overlay_stage_2.png",
        "vo": "vo_2.mp3",
        "sfx": "sfx_scan.wav",
        "sfx_delay": 0.3,
        "zoom": True
    },
    {
        "name": "scene3_isolate",
        "video": "clip_isolate.mp4",
        "ss": "0.0",
        "dur": "4.5",
        "overlay": "overlay_stage_3.png",
        "vo": "vo_3.mp3",
        "sfx": "sfx_click.wav",
        "sfx_delay": 0.8,
        "zoom": False
    },
    {
        "name": "scene4_process",
        "video": "clip_process.mp4",
        "ss": "0.5",
        "dur": "5.5",
        "overlay": "overlay_stage_4.png",
        "vo": "vo_4.mp3",
        "sfx": "sfx_zap.wav",
        "sfx_delay": 0.2,
        "zoom": False
    },
    {
        "name": "scene5_build",
        "video": "clip_reveal.mp4",
        "ss": "0.0",
        "dur": "5.0",
        "overlay": "overlay_stage_5.png",
        "vo": "vo_5.mp3",
        "sfx": "sfx_riser.wav",
        "sfx_delay": 0.0,
        "zoom": False
    },
    {
        "name": "scene6_reveal",
        "video": "clip_reveal.mp4",
        "ss": "3.5",
        "dur": "5.5",
        "overlay": "overlay_stage_6.png",
        "vo": "vo_6.mp3",
        "sfx": "sfx_chime.wav",
        "sfx_delay": 0.2,
        "alarm_sfx": True,
        "zoom": False
    }
]

scene_files = []

for idx, sc in enumerate(scenes):
    out_mp4 = f"{sc['name']}.mp4"
    print(f"\n--- Rendering {sc['name']} ({sc['dur']}s) ---")
    
    if sc.get("zoom"):
        fg_filter = "[0:v]scale=1280:2844,crop=900:1920:190:400,fps=30[fg];"
    else:
        fg_filter = "[0:v]scale=864:1920,fps=30[fg];"
    
    filter_complex = (
        "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:10,fps=30[bg];"
        + fg_filter +
        "[bg][fg]overlay=108:0[v_app];"
        "[1:v]scale=1080:1920,fps=30[v_ov];"
        "[v_app][v_ov]overlay=0:0[v_out];"
    )

    inputs = [
        '-ss', sc['ss'], '-t', sc['dur'], '-i', sc['video'],
        '-loop', '1', '-t', sc['dur'], '-i', sc['overlay'],
        '-i', sc['vo'],
        '-i', sc['sfx']
    ]

    if sc.get("alarm_sfx"):
        inputs.extend(['-i', 'assets/sounds/alarm.mp3'])
        filter_complex += (
            "[2:a]atempo=1.12,aformat=sample_rates=44100:channel_layouts=stereo,volume=1.3[a_vo];"
            f"[3:a]adelay=300|300,aformat=sample_rates=44100:channel_layouts=stereo,volume=0.9[a_sfx];"
            "[4:a]adelay=1500|1500,aformat=sample_rates=44100:channel_layouts=stereo,volume=0.6[a_alarm];"
            "[a_vo][a_sfx][a_alarm]amix=inputs=3:duration=first:dropout_transition=2[a_out]"
        )
    else:
        delay_ms = int(sc['sfx_delay'] * 1000)
        filter_complex += (
            "[2:a]atempo=1.12,aformat=sample_rates=44100:channel_layouts=stereo,volume=1.3[a_vo];"
            f"[3:a]adelay={delay_ms}|{delay_ms},aformat=sample_rates=44100:channel_layouts=stereo,volume=0.8[a_sfx];"
            "[a_vo][a_sfx]amix=inputs=2:duration=first:dropout_transition=2[a_out]"
        )

    cmd = [
        'ffmpeg', '-y'
    ] + inputs + [
        '-filter_complex', filter_complex,
        '-map', '[v_out]', '-map', '[a_out]',
        '-c:v', 'libx264', '-preset', 'fast', '-crf', '19', '-pix_fmt', 'yuv420p', '-r', '30',
        '-c:a', 'aac', '-ar', '44100', '-ac', '2', '-b:a', '192k',
        '-t', sc['dur'],
        out_mp4
    ]

    subprocess.run(cmd, check=True)
    scene_files.append(out_mp4)
    print(f"Rendered {out_mp4} successfully!")

# Render Scene 7: Outro End Card (4.5s)
print("\n--- Rendering scene7_outro (4.5s) ---")
outro_mp4 = "scene7_outro.mp4"
outro_cmd = [
    'ffmpeg', '-y',
    '-loop', '1', '-t', '4.5', '-i', 'promo_outro_card.png',
    '-i', 'sfx_chime.wav',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[v_out];"
    "[1:a]aformat=sample_rates=44100:channel_layouts=stereo,volume=0.8,apad=pad_dur=4.0[a_out]",
    '-map', '[v_out]', '-map', '[a_out]',
    '-c:v', 'libx264', '-preset', 'fast', '-crf', '19', '-pix_fmt', 'yuv420p', '-r', '30',
    '-c:a', 'aac', '-ar', '44100', '-ac', '2', '-b:a', '192k',
    '-t', '4.5',
    outro_mp4
]
subprocess.run(outro_cmd, check=True)
scene_files.append(outro_mp4)
print("Rendered scene7_outro.mp4 successfully!")

# Combine all 7 scenes using filter_complex concat
print("\n--- Concat all 7 scenes seamlessly ---")
concat_inputs = []
concat_filter = ""
for i, sf in enumerate(scene_files):
    concat_inputs.extend(['-i', sf])
    concat_filter += f"[{i}:v][{i}:a]"
concat_filter += f"concat=n={len(scene_files)}:v=1:a=1[v_concat][a_concat]"

concat_cmd = [
    'ffmpeg', '-y'
] + concat_inputs + [
    '-filter_complex', concat_filter,
    '-map', '[v_concat]', '-map', '[a_concat]',
    '-c:v', 'libx264', '-preset', 'fast', '-crf', '19', '-pix_fmt', 'yuv420p',
    '-c:a', 'aac', '-ar', '44100', '-ac', '2', '-b:a', '192k',
    'raw_combined.mp4'
]
subprocess.run(concat_cmd, check=True)
print("Concatenated raw video: raw_combined.mp4")

# Final Audio Mastering: Mix background music ducked under narration
print("\n--- Final Mastering: Adding Ducked Background Music ---")
final_output = "ChargeAlert_Promo_YouTube_Short.mp4"

master_cmd = [
    'ffmpeg', '-y',
    '-i', 'raw_combined.mp4',
    '-i', 'bg_music.wav',
    '-filter_complex',
    "[1:a]aformat=sample_rates=44100:channel_layouts=stereo,volume=0.15,afade=t=in:st=0:d=1.0,afade=t=out:st=31.5:d=3.5[bg];"
    "[0:a][bg]amix=inputs=2:duration=first:dropout_transition=2[a_mix]",
    '-map', '0:v', '-map', '[a_mix]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-ar', '44100', '-ac', '2', '-b:a', '192k',
    '-t', '35.0',
    final_output
]
subprocess.run(master_cmd, check=True)

# Probe final duration and specs
r = subprocess.run([
    'ffprobe', '-v', 'error',
    '-show_entries', 'format=duration,size,bit_rate:stream=width,height,codec_name',
    '-of', 'default=noprint_wrappers=1',
    final_output
], capture_output=True, text=True)

print("\n========================================================")
print("PROMOTION MASTER VIDEO COMPLETED!")
print(f"Output File: {final_output}")
print(r.stdout.strip())
print("========================================================")
