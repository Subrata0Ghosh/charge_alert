import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

width, height = 1080, 1920
img = Image.new("RGBA", (width, height), (13, 17, 23, 255)) # Dark obsidian background

# Background radial cyan/emerald energy gradient
glow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
glow_draw = ImageDraw.Draw(glow)
for r in range(500, 0, -15):
    alpha = int(140 * math.cos((r / 500) * (math.pi / 2)))
    glow_draw.ellipse(
        [width//2 - r, 700 - r, width//2 + r, 700 + r],
        fill=(14, 165, 233, alpha)
    )
glow = glow.filter(ImageFilter.GaussianBlur(35))
img = Image.alpha_composite(img, glow)

draw = ImageDraw.Draw(img)
font_dir = os.path.join(os.environ.get('WINDIR', 'C:\\Windows'), 'Fonts')
font_hero = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 76)
font_sub = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 40)
font_badge = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 32)
font_btn_top = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 26)
font_btn_bot = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 50)
font_cta_1 = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 52)
font_cta_2 = ImageFont.truetype(os.path.join(font_dir, 'arialbd.ttf'), 38)

# Load and round app icon
icon_path = 'assets/icon/app_icon.png'
if os.path.exists(icon_path):
    icon = Image.open(icon_path).convert("RGBA")
    icon = icon.resize((380, 380), Image.Resampling.LANCZOS)
    
    mask = Image.new('L', (380, 380), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([(0, 0), (380, 380)], radius=80, fill=255)
    
    shadow = Image.new("RGBA", (480, 480), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow)
    s_draw.rounded_rectangle([(30, 30), (450, 450)], radius=90, fill=(0, 0, 0, 200))
    shadow = shadow.filter(ImageFilter.GaussianBlur(25))
    
    ix = (width - 380) // 2
    iy = 420
    img.paste(shadow, (ix - 50, iy - 50), shadow)
    img.paste(icon, (ix, iy), mask)

# App Title
t1 = "Charge Alert"
bbox1 = draw.textbbox((0, 0), t1, font=font_hero)
draw.text(((width - (bbox1[2] - bbox1[0])) // 2, 860), t1, fill=(255, 255, 255, 255), font=font_hero)

# Subtitle
t2 = "Smart Battery Guardian & Alarm"
bbox2 = draw.textbbox((0, 0), t2, font=font_sub)
draw.text(((width - (bbox2[2] - bbox2[0])) // 2, 955), t2, fill=(148, 163, 184, 255), font=font_sub)

# Draw 5 golden stars function
def draw_star(center_x, center_y, r_out, r_in, fill_color):
    points = []
    for i in range(10):
        r = r_out if i % 2 == 0 else r_in
        angle = i * math.pi / 5 - math.pi / 2
        points.append((center_x + r * math.cos(angle), center_y + r * math.sin(angle)))
    draw.polygon(points, fill=fill_color)

# Rating Badge Pill
badge_rect = [200, 1045, width - 200, 1125]
draw.rounded_rectangle(badge_rect, radius=40, fill=(30, 41, 59, 240), outline=(56, 189, 248, 150), width=2)
# Draw stars
star_start_x = 240
for s in range(5):
    draw_star(star_start_x + s * 34, 1085, 14, 6, (250, 204, 21, 255))
b_text = "5.0 Rating • 100% Free"
draw.text((435, 1067), b_text, fill=(255, 255, 255, 255), font=font_badge)

# Google Play Button Pill
btn_w, btn_h = 580, 130
btn_x = (width - btn_w) // 2
btn_y = 1190
draw.rounded_rectangle([btn_x, btn_y, btn_x + btn_w, btn_y + btn_h], radius=30, fill=(0, 0, 0, 255), outline=(255, 255, 255, 180), width=2)

# Multi-colored Play Triangle
p_x = btn_x + 50
p_y = btn_y + 35
# Blue section
draw.polygon([(p_x, p_y), (p_x + 40, p_y + 30), (p_x, p_y + 60)], fill=(0, 210, 255, 255))
# Green/Yellow section
draw.polygon([(p_x, p_y), (p_x + 40, p_y + 30), (p_x + 60, p_y + 15)], fill=(0, 230, 138, 255))
draw.polygon([(p_x, p_y + 60), (p_x + 40, p_y + 30), (p_x + 60, p_y + 45)], fill=(255, 60, 80, 255))
draw.polygon([(p_x + 40, p_y + 30), (p_x + 60, p_y + 15), (p_x + 75, p_y + 30), (p_x + 60, p_y + 45)], fill=(255, 186, 0, 255))

draw.text((btn_x + 150, btn_y + 20), "GET IT ON", fill=(203, 213, 225, 255), font=font_btn_top)
draw.text((btn_x + 150, btn_y + 52), "Google Play", fill=(255, 255, 255, 255), font=font_btn_bot)

# High Impact Call-to-action Card
cta_y = 1390
cta_h = 240
draw.rounded_rectangle([70, cta_y, width - 70, cta_y + cta_h], radius=36, fill=(16, 85, 209, 255), outline=(96, 165, 250, 255), width=3)

# Arrow pointers drawn
arrow_y = cta_y + 55
# Down arrows left and right
def draw_down_arrow(ax, ay):
    draw.polygon([(ax - 18, ay - 10), (ax + 18, ay - 10), (ax, ay + 14)], fill=(255, 255, 255, 255))

draw_down_arrow(140, arrow_y + 8)
draw_down_arrow(width - 140, arrow_y + 8)

c1 = "LINK IN THE COMMENTS!"
bbox_c1 = draw.textbbox((0, 0), c1, font=font_cta_1)
draw.text(((width - (bbox_c1[2] - bbox_c1[0])) // 2, cta_y + 30), c1, fill=(255, 255, 255, 255), font=font_cta_1)

c2 = "CHECK IT OUT & DOWNLOAD NOW"
bbox_c2 = draw.textbbox((0, 0), c2, font=font_cta_2)
draw.text(((width - (bbox_c2[2] - bbox_c2[0])) // 2, cta_y + 115), c2, fill=(254, 240, 138, 255), font=font_cta_2)

# Protection Guarantee
c3 = "Protect Your Battery • Prevent Overheating • 100% Free"
font_c3 = ImageFont.truetype(os.path.join(font_dir, 'segoeui.ttf'), 28)
bbox_c3 = draw.textbbox((0, 0), c3, font=font_c3)
draw.text(((width - (bbox_c3[2] - bbox_c3[0])) // 2, cta_y + 175), c3, fill=(224, 242, 254, 255), font=font_c3)

img.convert("RGB").save("ugc_end_card.png", "PNG")
print("Updated ugc_end_card.png cleanly!")
