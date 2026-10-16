import urllib.request
import urllib.parse
import subprocess
import os

sentences = [
    ('p1', 'Hey guys! Check out this genius app called Charge Alert!'),
    ('p2', 'Look at Volt! When you tap him, he literally wakes up and waves!'),
    ('p3', 'It has a super sleek one-tap dark and light theme toggle that looks gorgeous!'),
    ('p4', 'You can customize your battery alert to 80% so you never overcharge.'),
    ('p5', 'Down here you get full alarm controls, anti-theft siren, and you can test the sound!'),
    ('p6', 'Download Charge Alert free on Google Play right now, link in the comments!')
]

files = []
for name, text in sentences:
    fname = f'{name}.mp3'
    url = 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=' + urllib.parse.quote(text)
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as resp, open(fname, 'wb') as f:
        f.write(resp.read())
    files.append(fname)
    print(f'Fetched {fname}')

with open('concat_voice.txt', 'w') as f:
    for fname in files:
        f.write(f"file '{fname}'\n")

subprocess.run(['ffmpeg', '-y', '-f', 'concat', '-safe', '0', '-i', 'concat_voice.txt', '-c', 'copy', 'influencer_voice.mp3'], check=True)
r = subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'default=noprint_wrappers=1:nokey=1', 'influencer_voice.mp3'], stdout=subprocess.PIPE, text=True)
print('Total combined voice duration:', r.stdout.strip())
