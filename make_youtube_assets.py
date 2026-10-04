import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

out_dir = r"c:\Users\sulat\Desktop\projects\flutter_workspace\charge_alert\youtube_channel_assets"
os.makedirs(out_dir, exist_ok=True)

font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')

# Fonts
font_hero_large = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 84)
font_sub = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 32)
font_sub_bold = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 30)
font_pill = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 26)

bg_img_path = r"C:\Users\sulat\.gemini\antigravity-ide\brain\3f65bb21-ce02-4dab-86ff-a1ec67026336\youtube_tech_banner_bg_1791097268496.jpg"
avatar_path = r"C:\Users\sulat\.gemini\antigravity-ide\brain\3f65bb21-ce02-4dab-86ff-a1ec67026336\sg_tech_avatar_1791097291042.jpg"
app_icon_path = r"c:\Users\sulat\Desktop\projects\flutter_workspace\charge_alert\assets\icon\app_icon.png"

# YouTube Banner dimensions
W, H = 2560, 1440
# Safe area: Y from 508 to 931 (height 423), X from 507 to 2053 (width 1546)
SAFE_TOP = 508
SAFE_BOT = 931
SAFE_LEFT = 507
SAFE_RIGHT = 2053

def draw_diamond(d, cx, cy, r, color):
    d.polygon([(cx, cy - r), (cx + r, cy), (cx, cy + r), (cx - r, cy)], fill=color)

def draw_star(d, cx, cy, r_out, r_in, color):
    points = []
    for i in range(10):
        r = r_out if i % 2 == 0 else r_in
        angle = i * math.pi / 5 - math.pi / 2
        points.append((cx + r * math.cos(angle), cy + r * math.sin(angle)))
    d.polygon(points, fill=color)

# -------------------------------------------------------------
# 1. GENERATE BANNER 1: SUBRATA GHOSH - TECH & APP CREATOR
# -------------------------------------------------------------
if os.path.exists(bg_img_path):
    banner1 = Image.open(bg_img_path).convert("RGBA").resize((W, H), Image.Resampling.LANCZOS)
else:
    banner1 = Image.new("RGBA", (W, H), (10, 14, 26, 255))

vignette = Image.new("RGBA", (W, H), (0, 0, 0, 0))
v_draw = ImageDraw.Draw(vignette)
v_draw.rounded_rectangle(
    [SAFE_LEFT - 40, SAFE_TOP + 12, SAFE_RIGHT + 40, SAFE_BOT - 12],
    radius=30,
    fill=(8, 12, 22, 205),
    outline=(0, 229, 255, 75),
    width=2
)
vignette = vignette.filter(ImageFilter.GaussianBlur(8))
banner1 = Image.alpha_composite(banner1, vignette)

draw1 = ImageDraw.Draw(banner1)

# Title: SUBRATA GHOSH
name_text = "SUBRATA GHOSH"
name_bbox = draw1.textbbox((0, 0), name_text, font=font_hero_large)
name_w = name_bbox[2] - name_bbox[0]

# Subtle text glow
for offset in [(2, 2), (-2, -2), (2, -2), (-2, 2)]:
    draw1.text(((W - name_w) // 2 + offset[0], SAFE_TOP + 55 + offset[1]), name_text, font=font_hero_large, fill=(0, 150, 255, 120))
draw1.text(((W - name_w) // 2, SAFE_TOP + 55), name_text, font=font_hero_large, fill=(255, 255, 255, 255))

# Subtitle
sub_text = "MOBILE APP INNOVATOR  •  FLUTTER & ANDROID DEVELOPER"
sub_bbox = draw1.textbbox((0, 0), sub_text, font=font_sub_bold)
sub_w = sub_bbox[2] - sub_bbox[0]
draw1.text(((W - sub_w) // 2, SAFE_TOP + 165), sub_text, font=font_sub_bold, fill=(0, 229, 255, 255))

# Pills / Badges in safe area (with clean drawn geometric icons)
pills1 = [
    ("Charge Alert App", (250, 204, 21, 255), "diamond"),
    ("BLINK: Cosmic Observer", (192, 132, 252, 255), "diamond"),
    ("Tech Demos & Dev", (241, 245, 249, 255), "diamond"),
    ("@subrata6799", (56, 189, 248, 255), "circle")
]

pill_widths = []
for p_text, _, _ in pills1:
    pb = draw1.textbbox((0, 0), p_text, font=font_pill)
    pw = (pb[2] - pb[0]) + 65  # room for icon
    pill_widths.append(pw)
pill_total_w = sum(pill_widths) + (len(pills1) - 1) * 18

start_px = (W - pill_total_w) // 2
curr_px = start_px
pill_y = SAFE_TOP + 240
for i, (p_text, p_col, icon_type) in enumerate(pills1):
    pw = pill_widths[i]
    draw1.rounded_rectangle([curr_px, pill_y, curr_px + pw, pill_y + 48], radius=24, fill=(19, 27, 46, 235), outline=(56, 189, 248, 140), width=2)
    
    # Draw icon
    ic_cx = curr_px + 24
    ic_cy = pill_y + 24
    if icon_type == "diamond":
        draw_diamond(draw1, ic_cx, ic_cy, 7, p_col)
    else:
        draw1.ellipse([ic_cx - 6, ic_cy - 6, ic_cx + 6, ic_cy + 6], fill=p_col)
        
    ty = pill_y + 9
    draw1.text((curr_px + 42, ty), p_text, font=font_pill, fill=p_col)
    curr_px += pw + 18

callout = "NEW APP RELEASES  •  CODE WALKTHROUGHS  •  TECH INNOVATION"
cb = draw1.textbbox((0, 0), callout, font=font_sub)
cw = cb[2] - cb[0]
draw1.text(((W - cw) // 2, SAFE_TOP + 325), callout, font=font_sub, fill=(148, 163, 184, 240))

banner1_path = os.path.join(out_dir, "youtube_banner_subrata_ghosh.png")
banner1.convert("RGB").save(banner1_path, "PNG", quality=95)
print("Saved banner 1")


# -------------------------------------------------------------
# 2. GENERATE BANNER 2: CHARGE ALERT APP FOCUS
# -------------------------------------------------------------
if os.path.exists(bg_img_path):
    banner2 = Image.open(bg_img_path).convert("RGBA").resize((W, H), Image.Resampling.LANCZOS)
else:
    banner2 = Image.new("RGBA", (W, H), (10, 14, 26, 255))

vignette2 = Image.new("RGBA", (W, H), (0, 0, 0, 0))
v2_draw = ImageDraw.Draw(vignette2)
v2_draw.rounded_rectangle(
    [SAFE_LEFT - 40, SAFE_TOP + 12, SAFE_RIGHT + 40, SAFE_BOT - 12],
    radius=30,
    fill=(8, 12, 22, 215),
    outline=(16, 185, 129, 80),
    width=2
)
vignette2 = vignette2.filter(ImageFilter.GaussianBlur(8))
banner2 = Image.alpha_composite(banner2, vignette2)

if os.path.exists(app_icon_path):
    a_icon = Image.open(app_icon_path).convert("RGBA")
    icon_sz = 260
    a_icon = a_icon.resize((icon_sz, icon_sz), Image.Resampling.LANCZOS)
    mask = Image.new('L', (icon_sz, icon_sz), 0)
    m_draw = ImageDraw.Draw(mask)
    m_draw.rounded_rectangle([(0, 0), (icon_sz, icon_sz)], radius=55, fill=255)
    
    s_img = Image.new("RGBA", (icon_sz + 40, icon_sz + 40), (0, 0, 0, 0))
    s_drw = ImageDraw.Draw(s_img)
    s_drw.rounded_rectangle([(10, 10), (icon_sz + 30, icon_sz + 30)], radius=60, fill=(0, 0, 0, 180))
    s_img = s_img.filter(ImageFilter.GaussianBlur(15))
    
    icon_x = SAFE_LEFT + 80
    icon_y = SAFE_TOP + (SAFE_BOT - SAFE_TOP - icon_sz) // 2
    banner2.paste(s_img, (icon_x - 20, icon_y - 20), s_img)
    banner2.paste(a_icon, (icon_x, icon_y), mask)
    
    text_start_x = icon_x + icon_sz + 60
else:
    text_start_x = SAFE_LEFT + 100

draw2 = ImageDraw.Draw(banner2)

draw2.text((text_start_x, SAFE_TOP + 55), "CHARGE ALERT", font=font_hero_large, fill=(255, 255, 255, 255))
draw2.text((text_start_x, SAFE_TOP + 160), "SMART BATTERY GUARDIAN & ANTI-THEFT ALARM", font=font_sub_bold, fill=(52, 211, 153, 255))

pills2 = [
    ("Battery Protector", (255, 255, 255, 255)),
    ("Anti-Theft Siren", (254, 240, 138, 255)),
    ("Free on Google Play", (52, 211, 153, 255))
]
p2_curr_x = text_start_x
p2_y = SAFE_TOP + 235
for p_text, p_col in pills2:
    pb = draw2.textbbox((0, 0), p_text, font=font_pill)
    pw = (pb[2] - pb[0]) + 60
    draw2.rounded_rectangle([p2_curr_x, p2_y, p2_curr_x + pw, p2_y + 46], radius=23, fill=(15, 23, 42, 230), outline=(52, 211, 153, 140), width=2)
    # mini diamond
    draw_diamond(draw2, p2_curr_x + 22, p2_y + 23, 6, p_col)
    draw2.text((p2_curr_x + 38, p2_y + 8), p_text, font=font_pill, fill=p_col)
    p2_curr_x += pw + 18

draw2.text((text_start_x, SAFE_TOP + 320), "Created by Subrata Ghosh  •  Subscribe for Updates & App Releases", font=font_sub, fill=(148, 163, 184, 240))

banner2_path = os.path.join(out_dir, "youtube_banner_charge_alert.png")
banner2.convert("RGB").save(banner2_path, "PNG", quality=95)
print("Saved banner 2")

# Update safe area previews
b1 = Image.open(banner1_path)
b1.crop((507, 508, 2053, 931)).resize((773, 211)).save(os.path.join(out_dir, "preview_banner_safe_area.jpg"), "JPEG")

b2 = Image.open(banner2_path)
b2.crop((507, 508, 2053, 931)).resize((773, 211)).save(os.path.join(out_dir, "preview_banner_charge_alert.jpg"), "JPEG")

print("Updated previews successfully!")
