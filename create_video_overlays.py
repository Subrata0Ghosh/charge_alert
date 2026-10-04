import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

width, height = 1080, 1920
font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')
font_bold = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 48)
font_sub = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 38)
font_top = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 32)

def make_caption_overlay(filename, top_tag, main_text, sub_text=None, tag_color=(239, 68, 68, 255), main_bg=(0, 0, 0, 200), main_text_color=(255, 255, 255, 255)):
    overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # 1. Top Category Tag Pill (y ~ 140)
    if top_tag:
        bbox_t = draw.textbbox((0, 0), top_tag, font=font_top)
        tw = bbox_t[2] - bbox_t[0]
        th = bbox_t[3] - bbox_t[1]
        pad_x, pad_y = 30, 14
        pill_rect = [(width - tw) // 2 - pad_x, 140, (width + tw) // 2 + pad_x, 140 + th + pad_y * 2]
        draw.rounded_rectangle(pill_rect, radius=24, fill=tag_color)
        draw.text(((width - tw) // 2, 140 + pad_y - 2), top_tag, fill=(255, 255, 255, 255), font=font_top)

    # 2. Lower Caption Banner (y ~ 1450 - 1650)
    bbox_m = draw.textbbox((0, 0), main_text, font=font_bold)
    mw = bbox_m[2] - bbox_m[0]
    mh = bbox_m[3] - bbox_m[1]

    if sub_text:
        bbox_s = draw.textbbox((0, 0), sub_text, font=font_sub)
        sw = bbox_s[2] - bbox_s[0]
        sh = bbox_s[3] - bbox_s[1]
        card_w = max(mw, sw) + 90
        card_h = mh + sh + 70
        card_y = 1520
        box = [(width - card_w) // 2, card_y, (width + card_w) // 2, card_y + card_h]
        
        # Shadow
        shadow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        s_draw = ImageDraw.Draw(shadow)
        s_draw.rounded_rectangle([box[0] - 10, box[1] - 5, box[2] + 10, box[3] + 15], radius=32, fill=(0, 0, 0, 180))
        shadow = shadow.filter(ImageFilter.GaussianBlur(16))
        overlay = Image.alpha_composite(shadow, overlay)
        draw = ImageDraw.Draw(overlay)

        draw.rounded_rectangle(box, radius=28, fill=main_bg, outline=(255, 255, 255, 90), width=2)
        draw.text(((width - mw) // 2, card_y + 22), main_text, fill=main_text_color, font=font_bold)
        draw.text(((width - sw) // 2, card_y + 30 + mh + 12), sub_text, fill=(253, 224, 71, 255), font=font_sub)
    else:
        card_w = mw + 90
        card_h = mh + 46
        card_y = 1550
        box = [(width - card_w) // 2, card_y, (width + card_w) // 2, card_y + card_h]
        
        shadow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        s_draw = ImageDraw.Draw(shadow)
        s_draw.rounded_rectangle([box[0] - 8, box[1] - 4, box[2] + 8, box[3] + 12], radius=28, fill=(0, 0, 0, 180))
        shadow = shadow.filter(ImageFilter.GaussianBlur(14))
        overlay = Image.alpha_composite(shadow, overlay)
        draw = ImageDraw.Draw(overlay)

        draw.rounded_rectangle(box, radius=24, fill=main_bg, outline=(255, 255, 255, 90), width=2)
        draw.text(((width - mw) // 2, card_y + 18), main_text, fill=main_text_color, font=font_bold)

    overlay.save(filename, "PNG")
    print(f"Created {filename}")

# Create overlays
# Scene 1
make_caption_overlay("ov_s1_1.png", "BATTERY WARNING", "STOP OVERCHARGING YOUR PHONE!", "You're Ruining Your Battery Health", tag_color=(220, 38, 38, 255), main_text_color=(254, 240, 138, 255))
make_caption_overlay("ov_s1_2.png", "BATTERY WARNING", "Overcharging Overnight Destroys Cells!", "Avoid Extreme Heat & Wear", tag_color=(220, 38, 38, 255), main_text_color=(255, 255, 255, 255))

# Scene 2
make_caption_overlay("ov_s2_1.png", "THE SOLUTION", "Meet Charge Alert App!", "Smart Battery Protection", tag_color=(16, 185, 129, 255), main_text_color=(255, 255, 255, 255))
make_caption_overlay("ov_s2_2.png", "CORE FEATURE", "Set Alert At 80% Battery!", "Prevents Overcharging & Heat", tag_color=(14, 165, 233, 255), main_text_color=(56, 189, 248, 255))

# Scene 3
make_caption_overlay("ov_s3_1.png", "ANTI-THEFT GUARDIAN", "Guardian Siren Alarm!", "If Anyone Unplugs Your Charger", tag_color=(239, 68, 68, 255), main_text_color=(255, 255, 255, 255))
make_caption_overlay("ov_s3_2.png", "ANTI-THEFT GUARDIAN", "Loud Siren Until PIN Is Entered!", "Safe In Libraries, Cafes & Travel", tag_color=(239, 68, 68, 255), main_text_color=(254, 240, 138, 255))

# Scene 4
make_caption_overlay("ov_s4_1.png", "LIVE TELEMETRY", "Real-Time Temperature & Voltage", "Live Battery Health Status", tag_color=(139, 92, 246, 255), main_text_color=(255, 255, 255, 255))
make_caption_overlay("ov_s4_2.png", "BATTERY COMPANION", "Meet Volt: Smart Companion!", "Watches Over Your Battery 24/7", tag_color=(14, 165, 233, 255), main_text_color=(254, 240, 138, 255))

# Scene 5
make_caption_overlay("ov_s5_1.png", "GET THE APP", "CHECK THE LINK IN THE COMMENTS!", "Download Charge Alert Right Now", tag_color=(37, 99, 235, 255), main_text_color=(255, 255, 255, 255))
print("All overlays ready!")
