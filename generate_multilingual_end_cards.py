import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_end_card(filename, title, subtitle, cta_main, cta_sub, accent_color=(14, 165, 233)):
    width, height = 1080, 1920
    img = Image.new("RGBA", (width, height), (13, 17, 23, 255))

    # Ambient radial glow
    glow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    for r in range(500, 0, -15):
        alpha = int(140 * math.cos((r / 500) * (math.pi / 2)))
        gd.ellipse([width//2 - r, 700 - r, width//2 + r, 700 + r], fill=(*accent_color, alpha))
    glow = glow.filter(ImageFilter.GaussianBlur(35))
    img = Image.alpha_composite(img, glow)

    draw = ImageDraw.Draw(img)
    font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')
    
    font_hero = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 70)
    font_sub = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 38)
    font_badge = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 32)
    font_btn_top = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 26)
    font_btn_bot = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 50)
    font_cta_1 = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 48)
    font_cta_2 = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 36)

    # Rounded App Icon with Shadow
    icon_path = 'assets/icon/app_icon.png'
    if os.path.exists(icon_path):
        icon = Image.open(icon_path).convert("RGBA").resize((380, 380), Image.Resampling.LANCZOS)
        mask = Image.new('L', (380, 380), 0)
        ImageDraw.Draw(mask).rounded_rectangle([(0, 0), (380, 380)], radius=80, fill=255)
        
        shadow = Image.new("RGBA", (480, 480), (0, 0, 0, 0))
        ImageDraw.Draw(shadow).rounded_rectangle([(30, 30), (450, 450)], radius=90, fill=(0, 0, 0, 200))
        shadow = shadow.filter(ImageFilter.GaussianBlur(25))
        
        ix = (width - 380) // 2
        iy = 420
        img.paste(shadow, (ix - 50, iy - 50), shadow)
        img.paste(icon, (ix, iy), mask)

    # Title
    bbox1 = draw.textbbox((0, 0), title, font=font_hero)
    draw.text(((width - (bbox1[2] - bbox1[0])) // 2, 860), title, fill=(255, 255, 255, 255), font=font_hero)

    # Subtitle
    bbox2 = draw.textbbox((0, 0), subtitle, font=font_sub)
    draw.text(((width - (bbox2[2] - bbox2[0])) // 2, 955), subtitle, fill=(148, 163, 184, 255), font=font_sub)

    # Star drawing helper
    def draw_star(center_x, center_y, r_out, r_in, fill_color):
        points = []
        for i in range(10):
            r = r_out if i % 2 == 0 else r_in
            angle = i * math.pi / 5 - math.pi / 2
            points.append((center_x + r * math.cos(angle), center_y + r * math.sin(angle)))
        draw.polygon(points, fill=fill_color)

    # Rating Pill
    badge_rect = [200, 1045, width - 200, 1125]
    draw.rounded_rectangle(badge_rect, radius=40, fill=(30, 41, 59, 240), outline=(*accent_color, 150), width=2)
    for s in range(5):
        draw_star(240 + s * 34, 1085, 14, 6, (250, 204, 21, 255))
    draw.text((435, 1067), "5.0 Rating • 100% Free", fill=(255, 255, 255, 255), font=font_badge)

    # Google Play Button
    btn_w, btn_h = 580, 130
    btn_x = (width - btn_w) // 2
    btn_y = 1190
    draw.rounded_rectangle([btn_x, btn_y, btn_x + btn_w, btn_y + btn_h], radius=30, fill=(0, 0, 0, 255), outline=(255, 255, 255, 180), width=2)
    
    # Play icon
    p_x = btn_x + 50
    p_y = btn_y + 35
    draw.polygon([(p_x, p_y), (p_x + 40, p_y + 30), (p_x, p_y + 60)], fill=(0, 210, 255, 255))
    draw.polygon([(p_x, p_y), (p_x + 40, p_y + 30), (p_x + 60, p_y + 15)], fill=(0, 230, 138, 255))
    draw.polygon([(p_x, p_y + 60), (p_x + 40, p_y + 30), (p_x + 60, p_y + 45)], fill=(255, 60, 80, 255))
    draw.polygon([(p_x + 40, p_y + 30), (p_x + 60, p_y + 15), (p_x + 75, p_y + 30), (p_x + 60, p_y + 45)], fill=(255, 186, 0, 255))

    draw.text((btn_x + 150, btn_y + 20), "GET IT ON", fill=(203, 213, 225, 255), font=font_btn_top)
    draw.text((btn_x + 150, btn_y + 52), "Google Play", fill=(255, 255, 255, 255), font=font_btn_bot)

    # CTA Card
    cta_y = 1390
    cta_h = 240
    draw.rounded_rectangle([70, cta_y, width - 70, cta_y + cta_h], radius=36, fill=(16, 85, 209, 255), outline=(96, 165, 250, 255), width=3)

    # Down arrows
    def draw_down_arrow(ax, ay):
        draw.polygon([(ax - 18, ay - 10), (ax + 18, ay - 10), (ax, ay + 14)], fill=(255, 255, 255, 255))

    draw_down_arrow(140, cta_y + 60)
    draw_down_arrow(width - 140, cta_y + 60)

    bbox_c1 = draw.textbbox((0, 0), cta_main, font=font_cta_1)
    draw.text(((width - (bbox_c1[2] - bbox_c1[0])) // 2, cta_y + 35), cta_main, fill=(255, 255, 255, 255), font=font_cta_1)

    bbox_c2 = draw.textbbox((0, 0), cta_sub, font=font_cta_2)
    draw.text(((width - (bbox_c2[2] - bbox_c2[0])) // 2, cta_y + 120), cta_sub, fill=(254, 240, 138, 255), font=font_cta_2)

    c3 = "Protect Battery • Anti-Theft Siren • 100% Free"
    font_c3 = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 28)
    bbox_c3 = draw.textbbox((0, 0), c3, font=font_c3)
    draw.text(((width - (bbox_c3[2] - bbox_c3[0])) // 2, cta_y + 180), c3, fill=(224, 242, 254, 255), font=font_c3)

    img.convert("RGB").save(filename, "PNG")
    print(f"Generated {filename}")

# Generate Hindi and Bengali end cards
create_end_card("ugc_end_card_hi.png", "Charge Alert", "Smart Anti-Theft Siren & Battery Saver", "LINK IN THE COMMENTS!", "CHECK COMMENT & DOWNLOAD NOW", accent_color=(239, 68, 68))
create_end_card("ugc_end_card_bn.png", "Charge Alert", "Smart Battery Saver & Anti-Theft", "PINNED COMMENT E LINK ACHE!", "EKHONI DOWNLOAD KORUN", accent_color=(16, 185, 129))
print("All end cards generated!")
