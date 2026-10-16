import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')
font_hero = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 68)
font_bold_lg = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 50)
font_bold_md = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 36)
font_bold_sm = ImageFont.truetype(os.path.join(font_dir, 'segoeuib.ttf'), 26)
font_reg_sm = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 24)

W, H = 1080, 1920

stages = [
    {
        "id": 1,
        "name": "DECLARE",
        "color": (0, 230, 118),       # Neon green
        "title": "STAGE 1: DECLARE",
        "sub": "THE OVERNIGHT BATTERY TRAP",
        "banner": "ALERT: STOP OVERNIGHT CHARGING!",
        "banner_sub": "Lithium cells degrade under prolonged heat",
        "banner_col": (255, 75, 75)
    },
    {
        "id": 2,
        "name": "ASSESS",
        "color": (255, 145, 0),       # Orange
        "title": "STAGE 2: ASSESS",
        "sub": "DIAGNOSTIC HEALTH INSPECTION",
        "banner": "CRITICAL: 48.0°C HIGH HEAT DETECTED!",
        "banner_sub": "Volt running hot • Permanent wear risk",
        "banner_col": (255, 145, 0)
    },
    {
        "id": 3,
        "name": "ISOLATE",
        "color": (255, 23, 68),       # Red
        "title": "STAGE 3: ISOLATE",
        "sub": "ARM 80% LIMIT & GUARDIAN",
        "banner": "SAFEGUARD: SET SAFE 80% LIMIT",
        "banner_sub": "The Golden Rule for 3X battery lifespan",
        "banner_col": (0, 229, 255)
    },
    {
        "id": 4,
        "name": "PROCESS",
        "color": (170, 0, 255),      # Purple
        "title": "STAGE 4: PROCESS",
        "sub": "ACTIVE LIQUID CORE MONITORING",
        "banner": "ACTIVE: CHARGER CONNECTED & SECURED",
        "banner_sub": "Real-time voltage & temperature telemetry",
        "banner_col": (0, 230, 118)
    },
    {
        "id": 5,
        "name": "BUILD",
        "color": (0, 176, 255),       # Electric Blue
        "title": "STAGE 5: BUILD",
        "sub": "CHARGE CLIMBING TO TARGET",
        "banner": "PROGRESS: CHARGE CLIMBING RAPIDLY",
        "banner_sub": "78%... 79%... nearing optimal cutoff",
        "banner_col": (0, 176, 255)
    },
    {
        "id": 6,
        "name": "REVEAL",
        "color": (255, 215, 0),       # Gold
        "title": "STAGE 6: REVEAL",
        "sub": "BATTERY SAVED & PROTECTED!",
        "banner": "SUCCESS: 80% TARGET REACHED! UNPLUG!",
        "banner_sub": "Lifespan extended • Zero overcharge stress",
        "banner_col": (0, 230, 118)
    }
]

stage_names = ["DECLARE", "ASSESS", "ISOLATE", "PROCESS", "BUILD", "REVEAL"]

def render_top_hud(draw, active_idx):
    # Sleek dark glass container for HUD bar
    hud_x0, hud_y0, hud_x1, hud_y1 = 40, 50, 1040, 215
    draw.rounded_rectangle([hud_x0, hud_y0, hud_x1, hud_y1], radius=24, fill=(10, 16, 28, 240), outline=(0, 229, 255, 120), width=2)
    
    # 6-step progress indicator
    bar_x_start = 125
    bar_x_end = 955
    bar_y = 92
    step_width = (bar_x_end - bar_x_start) / 5
    
    # Inactive track line
    draw.line([(bar_x_start, bar_y), (bar_x_end, bar_y)], fill=(35, 50, 75, 255), width=5)
    # Active progress line
    active_x = bar_x_start + active_idx * step_width
    draw.line([(bar_x_start, bar_y), (active_x, bar_y)], fill=(0, 229, 255, 255), width=5)
    
    for i, sname in enumerate(stage_names):
        cx = bar_x_start + i * step_width
        cy = bar_y
        is_active = (i == active_idx)
        is_past = (i < active_idx)
        
        node_color = stages[i]["color"] if (is_active or is_past) else (50, 70, 95)
        radius = 13 if is_active else 8
        draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], fill=node_color, outline=(255, 255, 255) if is_active else None, width=2 if is_active else 0)
        
        # Stage label
        lbl_col = (255, 255, 255) if is_active else ((150, 175, 200) if is_past else (80, 100, 125))
        font_lbl = font_bold_sm if is_active else font_reg_sm
        bbox = draw.textbbox((0, 0), sname, font=font_lbl)
        lw = bbox[2] - bbox[0]
        draw.text((cx - lw / 2, cy + 18), sname, fill=lbl_col, font=font_lbl)

    # Active Stage Badge Title & Subtitle
    st = stages[active_idx]
    title_text = st["title"] + "  |  " + st["sub"]
    bbox = draw.textbbox((0, 0), title_text, font=font_bold_sm)
    tw = bbox[2] - bbox[0]
    draw.text((540 - tw / 2, 162), title_text, fill=st["color"], font=font_bold_sm)

def render_bottom_banner(draw, st):
    # Floating pill banner at bottom
    bx0, by0, bx1, by1 = 50, 1680, 1030, 1830
    draw.rounded_rectangle([bx0, by0, bx1, by1], radius=28, fill=(8, 14, 26, 245), outline=st["banner_col"], width=3)
    
    # Glowing dot
    draw.ellipse([bx0 + 26, by0 + 38, bx0 + 50, by0 + 62], fill=st["banner_col"])
    
    # Main banner text
    draw.text((bx0 + 65, by0 + 22), st["banner"], fill=(255, 255, 255), font=font_bold_md)
    draw.text((bx0 + 65, by0 + 80), st["banner_sub"], fill=(180, 210, 230), font=font_reg_sm)

print("Rendering 6 Stage Overlays without top HUD...")
for idx, st in enumerate(stages):
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Top HUD removed as requested
    render_bottom_banner(draw, st)
    
    if st["name"] == "ASSESS":
        # Animated HUD scanning reticle on temperature tile
        cx, cy = 270, 1260
        r = 115
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=(255, 145, 0, 220), width=4)
        draw.ellipse([cx - r + 15, cy - r + 15, cx + r - 15, cy + r - 15], outline=(255, 220, 0, 140), width=2)
        draw.line([(cx - r - 25, cy), (cx + r + 25, cy)], fill=(255, 145, 0, 180), width=2)
        draw.line([(cx, cy - r - 25), (cx, cy + r + 25)], fill=(255, 145, 0, 180), width=2)
        draw.text((cx - 100, cy - r - 45), "[SCAN] 48°C HIGH HEAT", fill=(255, 220, 0), font=font_bold_sm)

    elif st["name"] == "ISOLATE":
        # Callout arrow pointing to 80% slider
        sx, sy = 540, 1580
        callout = ">>> SET TO 80% SAFE LIMIT <<<"
        bbox = draw.textbbox((0, 0), callout, font=font_bold_md)
        cw = bbox[2] - bbox[0]
        draw.rounded_rectangle([540 - cw / 2 - 20, sy - 8, 540 + cw / 2 + 20, sy + 50], radius=15, fill=(0, 229, 255, 40), outline=(0, 229, 255), width=2)
        draw.text((540 - cw / 2, sy), callout, fill=(0, 229, 255), font=font_bold_md)

    elif st["name"] == "REVEAL":
        # Draw victory sparkle stars
        star_positions = [(200, 420), (880, 430), (160, 850), (920, 880), (540, 320)]
        for (sx, sy) in star_positions:
            draw.text((sx, sy), "+", fill=(255, 230, 0), font=font_bold_lg)

    out_name = f"overlay_stage_{idx + 1}.png"
    img.save(out_name)
    print(f"Saved {out_name}")

# Generate Refined Outro End Card
print("\nGenerating Refined End Card...")
card = Image.new("RGBA", (W, H), (6, 12, 22, 255))
c_draw = ImageDraw.Draw(card)

# Subtle soft cyan halo centered behind app icon
halo = Image.new("RGBA", (W, H), (0, 0, 0, 0))
h_draw = ImageDraw.Draw(halo)
h_draw.ellipse([540 - 240, 520 - 240, 540 + 240, 520 + 240], fill=(0, 229, 255, 70))
halo = halo.filter(ImageFilter.GaussianBlur(60))
card = Image.alpha_composite(card, halo)
c_draw = ImageDraw.Draw(card)

# Load real app icon
icon_path = r"c:\Users\sulat\Desktop\projects\flutter_workspace\charge_alert\assets\icon\app_icon.png"
if os.path.exists(icon_path):
    app_icon = Image.open(icon_path).convert("RGBA").resize((320, 320), Image.Resampling.LANCZOS)
    mask = Image.new("L", (320, 320), 0)
    m_draw = ImageDraw.Draw(mask)
    m_draw.rounded_rectangle([0, 0, 320, 320], radius=70, fill=255)
    app_icon.putalpha(mask)
    card.alpha_composite(app_icon, (540 - 160, 360))
    
    # Crisp cyan border
    c_draw.rounded_rectangle([540 - 162, 358, 540 + 162, 360 + 322], radius=72, outline=(0, 229, 255, 220), width=4)

# App Name
bbox = c_draw.textbbox((0, 0), "ChargeAlert", font=font_hero)
tw = bbox[2] - bbox[0]
c_draw.text((540 - tw / 2, 720), "ChargeAlert", fill=(255, 255, 255), font=font_hero)

tagline = "SMART BATTERY GUARDIAN & ALARM"
bbox = c_draw.textbbox((0, 0), tagline, font=font_bold_sm)
tw = bbox[2] - bbox[0]
c_draw.text((540 - tw / 2, 810), tagline, fill=(0, 229, 255), font=font_bold_sm)

# Feature bullets with crisp modern design
bullets = [
    "[+] Stop Battery Overheating & Degradation",
    "[+] Intelligent 80% Safe Charge Cutoff Alert",
    "[+] Guardian Anti-Theft Unplug Siren",
    "[+] Adorable Smart Companion 'Volt'"
]

by = 920
for b in bullets:
    bbox = c_draw.textbbox((0, 0), b, font=font_bold_md)
    bw = bbox[2] - bbox[0]
    c_draw.rounded_rectangle([540 - bw / 2 - 25, by - 8, 540 + bw / 2 + 25, by + 50], radius=18, fill=(15, 25, 42, 230), outline=(0, 180, 216, 120), width=2)
    c_draw.text((540 - bw / 2, by), b, fill=(240, 248, 255), font=font_bold_md)
    by += 85

# Google Play Button
btn_x0, btn_y0, btn_x1, btn_y1 = 120, 1420, 960, 1550
c_draw.rounded_rectangle([btn_x0, btn_y0, btn_x1, btn_y1], radius=35, fill=(0, 230, 118, 255))
btn_txt = "GET IT ON GOOGLE PLAY"
bbox = c_draw.textbbox((0, 0), btn_txt, font=font_bold_lg)
tw = bbox[2] - bbox[0]
c_draw.text((540 - tw / 2, btn_y0 + 38), btn_txt, fill=(4, 25, 12), font=font_bold_lg)

# Rating / Call to Action
sub_cta = "100% Free • Protect Your Phone's Battery Today"
bbox = c_draw.textbbox((0, 0), sub_cta, font=font_bold_md)
tw = bbox[2] - bbox[0]
c_draw.text((540 - tw / 2, 1600), sub_cta, fill=(255, 215, 0), font=font_bold_md)

card.save("promo_outro_card.png")
print("Saved refined promo_outro_card.png successfully!")
