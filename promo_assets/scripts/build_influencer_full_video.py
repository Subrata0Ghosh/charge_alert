import os
import subprocess
from PIL import Image, ImageDraw, ImageFont, ImageFilter

print("=== BUILDING INFLUENCER FACECAM VIDEO ===")

font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')
font_badge = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 20)

# 1. GENERATE CROPPED CIRCULAR FACECAM IMAGES (280x280)
size = 280
for name, img_file, cx, cy, r, border_col in [
    ('fc_talk', 'img_explain.jpg', 420, 560, 240, (56, 189, 248)),
    ('fc_smile', 'img_hook.jpg', 420, 560, 240, (56, 189, 248)),
    ('fc_alert', 'img_alert.jpg', 420, 560, 240, (239, 68, 68)),
    ('fc_cta', 'img_cta.jpg', 420, 560, 240, (56, 189, 248))
]:
    im = Image.open(img_file).convert('RGBA')
    cropped = im.crop([cx - r, cy - r, cx + r, cy + r]).resize((size, size), Image.Resampling.LANCZOS)
    
    mask = Image.new('L', (size, size), 0)
    ImageDraw.Draw(mask).ellipse([0, 0, size, size], fill=255)
    
    out = Image.new('RGBA', (size + 30, size + 30), (0, 0, 0, 0))
    # Ambient Drop Shadow
    sd = ImageDraw.Draw(out)
    sd.ellipse([8, 8, size + 22, size + 22], fill=(0, 0, 0, 190))
    out = out.filter(ImageFilter.GaussianBlur(8))
    
    out.paste(cropped, (15, 15), mask)
    
    # Glowing Ring Border
    rd = ImageDraw.Draw(out)
    rd.ellipse([15, 15, size + 15, size + 15], outline=(*border_col, 255), width=6)
    rd.ellipse([17, 17, size + 13, size + 13], outline=(255, 255, 255, 220), width=2)
    
    out.save(f'{name}.png')
    print(f"Created facecam frame: {name}.png")

# 2. GENERATE CREATOR LIVE BADGE
badge_img = Image.new("RGBA", (310, 44), (0, 0, 0, 0))
bd = ImageDraw.Draw(badge_img)
bd.rounded_rectangle([0, 0, 310, 44], radius=22, fill=(15, 23, 42, 230), outline=(56, 189, 248, 180), width=2)
# Red pulsing live dot
bd.ellipse([16, 14, 30, 28], fill=(239, 68, 68, 255))
bd.text((38, 10), "CREATOR LIVE • REVIEW", fill=(255, 255, 255, 255), font=font_badge)
badge_img.save("fc_badge.png")
print("Created fc_badge.png")

# 3. BUILD PART 1: Full-Screen App Video + Animated Circular Facecam
# Facecam is placed at x=740, y=1560
# Badge is placed at x=740, y=1510
# Duration: 25.46s
print("\n--- RENDERING PART 1 (INTERACTIVE APP + ANIMATED FACECAM) ---")
cmd_p1 = [
    'ffmpeg', '-y',
    '-i', 'full_interactive_demo.mp4',
    '-loop', '1', '-i', 'fc_talk.png',
    '-loop', '1', '-i', 'fc_smile.png',
    '-loop', '1', '-i', 'fc_alert.png',
    '-loop', '1', '-i', 'fc_badge.png',
    '-filter_complex',
    # Scale full app recording to 1080x1920
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30[bg];"
    "[1:v]scale=310:310[talk];"
    "[2:v]scale=310:310[smile];"
    "[3:v]scale=310:310[alert];"
    "[4:v]scale=310:44[badge];"
    # Animate facecam: alternate talk & smile while speaking, switch to alert when alarm tests
    "[bg][talk]overlay=740:1560:enable='or(and(lt(t,18.5),eq(mod(floor(t*3),2),0)),and(gt(t,22.5),eq(mod(floor(t*3),2),0)))'[v1];"
    "[v1][smile]overlay=740:1560:enable='or(and(lt(t,18.5),eq(mod(floor(t*3),2),1)),and(gt(t,22.5),eq(mod(floor(t*3),2),1)))'[v2];"
    "[v2][alert]overlay=740:1560:enable='between(t,18.5,22.5)'[v3];"
    "[v3][badge]overlay=740:1506[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '25.46',
    'ifc_part1.mp4'
]
subprocess.run(cmd_p1, check=True)
print("Part 1 rendered successfully!")

# 4. BUILD PART 2: Outro End Card + Facecam Pointing Down (8.64s)
print("\n--- RENDERING PART 2 (OUTRO END CARD + CTA FACECAM) ---")
cmd_p2 = [
    'ffmpeg', '-y',
    '-loop', '1', '-i', 'ugc_end_card.png',
    '-loop', '1', '-i', 'fc_cta.png',
    '-loop', '1', '-i', 'fc_badge.png',
    '-filter_complex',
    "[0:v]scale=1080:1920,fps=30[bg];"
    "[1:v]scale=310:310[cta];"
    "[2:v]scale=310:44[badge];"
    "[bg][cta]overlay=740:1560[v1];"
    "[v1][badge]overlay=740:1506[v]",
    '-map', '[v]',
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-t', '8.64',
    'ifc_part2.mp4'
]
subprocess.run(cmd_p2, check=True)
print("Part 2 rendered successfully!")

# 5. CONCATENATE PART 1 AND PART 2
with open('concat_ifc.txt', 'w') as f:
    f.write("file 'ifc_part1.mp4'\nfile 'ifc_part2.mp4'\n")

cmd_concat = [
    'ffmpeg', '-y',
    '-f', 'concat', '-safe', '0', '-i', 'concat_ifc.txt',
    '-c', 'copy',
    'ifc_raw_video.mp4'
]
subprocess.run(cmd_concat, check=True)
print("Full video concatenated!")

# 6. AUDIO MASTERING:
# Mix influencer voice (0-34.1s) + alarm sound effect at 19.5s + subtle background music
print("\n--- MIXING COMPLETE AUDIO ---")
cmd_audio = [
    'ffmpeg', '-y',
    '-i', 'ifc_raw_video.mp4',
    '-i', 'influencer_voice.mp3',
    '-i', 'assets/sounds/alarm.mp3',
    '-i', 'bg_music.wav',
    '-filter_complex',
    "[2:a]adelay=19500|19500,volume=0.8[alarm_delayed];"
    "[3:a]volume=0.14[bg];"
    "[1:a][alarm_delayed]amix=inputs=2:duration=first:dropout_transition=1[voice_siren];"
    "[voice_siren][bg]amix=inputs=2:duration=first:dropout_transition=2[aout]",
    '-map', '0:v', '-map', '[aout]',
    '-c:v', 'copy',
    '-c:a', 'aac', '-b:a', '192k',
    '-t', '34.10',
    'charge_alert_influencer_facecam.mp4'
]
subprocess.run(cmd_audio, check=True)
print("=== SUCCESS: charge_alert_influencer_facecam.mp4 GENERATED! ===")
