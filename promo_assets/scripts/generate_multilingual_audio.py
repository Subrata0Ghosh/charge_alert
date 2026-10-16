import os
import urllib.request
import urllib.parse
import subprocess

def fetch_tts(lang, text, out_file):
    url = 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=' + lang + '&q=' + urllib.parse.quote(text)
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
    with urllib.request.urlopen(req) as resp, open(out_file, 'wb') as f:
        f.write(resp.read())
    print(f"[{lang.upper()}] Generated {out_file} ({os.path.getsize(out_file)} bytes)")

# 1. HINDI AUDIO (Video 1)
hindi_scenes = {
    'hi_s1': 'क्या आप भी ट्रेन, कॉलेज या कैफ़े में फ़ोन चार्जिंग पर लगाने से डरते हैं कि कोई चोरी न कर ले?',
    'hi_s2': 'तो अभी इंस्टॉल करें Charge Alert ऐप! इसमें है गार्जियन एंटी-थेफ़्ट मोड। जैसे ही कोई चार्जर निकालेगा, तुरंत ज़ोरदार सायरन बज उठेगा!',
    'hi_s3': 'और रात में ओवरचार्जिंग से बचाने के लिए अस्सी प्रतिशत बैटरी पर अलर्ट सेट करें, जिससे बैटरी कई साल चलेगी!',
    'hi_s4': 'यह ऐप प्ले स्टोर पर बिल्कुल मुफ़्त है! नीचे कमेंट्स में दिए लिंक पर अभी क्लिक करके डाउनलोड करें!'
}

for name, text in hindi_scenes.items():
    fetch_tts('hi', text, f'{name}.mp3')

# 2. BENGALI AUDIO (Video 2)
bengali_scenes = {
    'bn_s1': 'আপনি কি সারারাত ফোন চার্জে বসিয়ে রাখেন? সাবধান! এর ফলে ফোনের ব্যাটারি দ্রুত নষ্ট হয়ে যায়।',
    'bn_s2': 'এর সেরা সমাধান হলো Charge Alert অ্যাপ! এখানে আপনি আশি শতাংশের কাস্টম অ্যালার্ট সেট করতে পারবেন।',
    'bn_s3': 'এছাড়াও এতে পাবেন অ্যান্টি-থেফট সাইরেন অ্যালার্ম, লাইভ টেম্পারেচার ট্র্যাকিং এবং কিউট রোবট ভোল্ট।',
    'bn_s4': 'গুগল প্লে স্টোর থেকে একদম বিনামূল্যে ডাউনলোড করুন! পিন করা কমেন্টে লিংক আছে, এখনই চেক করুন!'
}

for name, text in bengali_scenes.items():
    fetch_tts('bn', text, f'{name}.mp3')

# 3. ENGLISH AUDIO (Video 3)
english_scenes = {
    'en_s1': 'Phone manufacturers never tell you this, but charging past eighty percent slowly kills your battery health.',
    'en_s2': 'Charge Alert fixes this instantly. Set a custom eighty percent alert to protect your battery from excessive heat.',
    'en_s3': 'Charging in public? Turn on Guardian Mode. If anyone unplugs your phone, a loud siren blasts until you enter your secret PIN!',
    'en_s4': 'You also get real-time temperature, voltage tracking, and meet Volt, your intelligent battery mascot.',
    'en_s5': 'Completely free on Google Play. Check the link in the comments and download Charge Alert right now!'
}

for name, text in english_scenes.items():
    fetch_tts('en', text, f'{name}.mp3')

print("=== ALL MULTILINGUAL AUDIO GENERATED SUCCESSFULLY ===")
