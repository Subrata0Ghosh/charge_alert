import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

width, height = 1080, 1920
font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')
font_bold = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 46)
font_sub = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 36)
font_top = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 30)

def make_overlay(filename, top_tag, main_text, sub_text, tag_color, main_color=(255, 255, 255), sub_color=(254, 240, 138), bg_color=(15, 23, 42, 225)):
    overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # Top Tag Pill
    bbox_t = draw.textbbox((0, 0), top_tag, font=font_top)
    tw = bbox_t[2] - bbox_t[0]
    th = bbox_t[3] - bbox_t[1]
    pill = [(width - tw) // 2 - 28, 130, (width + tw) // 2 + 28, 130 + th + 26]
    draw.rounded_rectangle(pill, radius=22, fill=tag_color)
    draw.text(((width - tw) // 2, 140), top_tag, fill=(255, 255, 255, 255), font=font_top)

    # Main Card
    bbox_m = draw.textbbox((0, 0), main_text, font=font_bold)
    mw = bbox_m[2] - bbox_m[0]
    mh = bbox_m[3] - bbox_m[1]

    bbox_s = draw.textbbox((0, 0), sub_text, font=font_sub)
    sw = bbox_s[2] - bbox_s[0]
    sh = bbox_s[3] - bbox_s[1]

    card_w = max(mw, sw) + 80
    card_h = mh + sh + 60
    card_y = 1530
    box = [(width - card_w) // 2, card_y, (width + card_w) // 2, card_y + card_h]

    # Blur Shadow
    shadow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([box[0] - 12, box[1] - 6, box[2] + 12, box[3] + 14], radius=32, fill=(0, 0, 0, 200))
    shadow = shadow.filter(ImageFilter.GaussianBlur(16))
    overlay = Image.alpha_composite(shadow, overlay)
    draw = ImageDraw.Draw(overlay)

    draw.rounded_rectangle(box, radius=26, fill=bg_color, outline=(255, 255, 255, 80), width=2)
    draw.text(((width - mw) // 2, card_y + 18), main_text, fill=main_color, font=font_bold)
    draw.text(((width - sw) // 2, card_y + 26 + mh + 10), sub_text, fill=sub_color, font=font_sub)

    overlay.save(filename, "PNG")
    print(f"Overlay created: {filename}")

# Hindi Overlays
make_overlay("ov_hi_1.png", "🚨 PHONE CHORI ALERT", "TRAIN YA PUBLIC MEIN CHARGING?", "Kahin Koi Phone Chori Na Kar Le!", tag_color=(239, 68, 68, 255), main_color=(254, 240, 138, 255))
make_overlay("ov_hi_2.png", "🛡️ GUARDIAN SIREN ACTIVE", "LOUD SIREN ON UNPLUG!", "Charger Hataate Hi Siren Bajega!", tag_color=(239, 68, 68, 255))
make_overlay("ov_hi_3.png", "⚡ 80% BATTERY LIMIT", "OVERCHARGING SE BACHAO!", "80% Battery Alert • No Overheating", tag_color=(14, 165, 233, 255), main_color=(56, 189, 248, 255))
make_overlay("ov_hi_4.png", "📲 100% FREE DOWNLOAD", "COMMENT MEIN LINK HAI!", "Download Charge Alert Right Now", tag_color=(37, 99, 235, 255))

# Bengali Overlays
make_overlay("ov_bn_1.png", "⚠️ BATTERY DAMAGE ALERT", "OVERNIGHT CHARGE KORCHEN?", "Battery Fast Kharap Hoye Jay!", tag_color=(239, 68, 68, 255), main_color=(254, 240, 138, 255))
make_overlay("ov_bn_2.png", "⚡ CHARGE ALERT APP", "SET 80% CHARGE ALARM!", "Battery Longevity Double Korun!", tag_color=(16, 185, 129, 255), main_color=(52, 211, 153, 255))
make_overlay("ov_bn_3.png", "🛡️ ANTI-THEFT GUARDIAN", "LOUD SIREN & VOLT MASCOT!", "Charger Khullei Bajbe Siren!", tag_color=(239, 68, 68, 255))
make_overlay("ov_bn_4.png", "📲 100% FREE ON PLAYSTORE", "PINNED COMMENT E LINK ACHE!", "Ekhoni Download Korun!", tag_color=(37, 99, 235, 255))

# English Cyberpunk Overlays
make_overlay("ov_en_1.png", "⚠️ BATTERY WARNING", "CHARGING PAST 80% KILLS CELLS!", "What Tech Brands Don't Tell You", tag_color=(239, 68, 68, 255), main_color=(254, 240, 138, 255))
make_overlay("ov_en_2.png", "⚡ 80% CUTOFF ALERT", "STOP OVERCHARGING HEAT!", "Preserve Lithium Health Forever", tag_color=(14, 165, 233, 255), main_color=(56, 189, 248, 255))
make_overlay("ov_en_3.png", "🚨 GUARDIAN ANTI-THEFT", "LOUD SIREN ON UNPLUG!", "PIN-Protected Siren in Public", tag_color=(239, 68, 68, 255))
make_overlay("ov_en_4.png", "🤖 VOLT AI COMPANION", "LIVE TEMP & VOLT MASCOT!", "Real-Time Battery Telemetry", tag_color=(139, 92, 246, 255), main_color=(192, 132, 252, 255))
make_overlay("ov_en_5.png", "📲 100% FREE ON PLAY STORE", "LINK IN THE COMMENTS!", "Download Charge Alert Right Now", tag_color=(37, 99, 235, 255))

print("All multilingual overlays created!")
