from PIL import Image, ImageDraw, ImageFilter

width, height = 1080, 1920
frame_img = Image.new("RGBA", (width, height), (0, 0, 0, 0))

# Phone dimensions
phone_w, phone_h = 760, 1500
px = (width - phone_w) // 2 # 160
py = 220

# Ambient Glow
glow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
gd = ImageDraw.Draw(glow)
gd.rounded_rectangle([px - 20, py - 20, px + phone_w + 20, py + phone_h + 20], radius=75, fill=(14, 165, 233, 160))
glow = glow.filter(ImageFilter.GaussianBlur(30))
frame_img = Image.alpha_composite(frame_img, glow)

# Phone Chassis
draw = ImageDraw.Draw(frame_img)
draw.rounded_rectangle([px, py, px + phone_w, py + phone_h], radius=60, fill=(24, 30, 42, 255), outline=(71, 85, 105, 255), width=5)

# Inner screen cutout
screen_x, screen_y = px + 18, py + 18
screen_w, screen_h = phone_w - 36, phone_h - 36 # 724, 1464

# Clear the screen area to transparent
cutout = Image.new("RGBA", (screen_w, screen_h), (0, 0, 0, 0))
frame_img.paste(cutout, (screen_x, screen_y))

# Add camera hole above screen
cam_r = 14
draw.ellipse([width//2 - cam_r, screen_y + 16 - cam_r, width//2 + cam_r, screen_y + 16 + cam_r], fill=(0, 0, 0, 255), outline=(51, 65, 85, 255), width=2)

# Save phone frame overlay
frame_img.save("phone_frame.png", "PNG")
print(f"phone_frame.png saved! Screen cutout at: ({screen_x}, {screen_y}) size ({screen_w}, {screen_h})")
