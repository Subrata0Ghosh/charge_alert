import subprocess
import os

lines = {
    'scene1': 'If you charge your phone overnight, STOP! You are literally destroying your battery health without knowing it.',
    'scene2': 'Instead, use this genius app called Charge Alert! It lets you set a custom alert at eighty percent so your battery never overheats.',
    'scene3': 'My favorite feature is Guardian Anti-Theft. If anyone unplugs your charger in public, a loud siren blasts until you enter your PIN!',
    'scene4': 'You also get live battery health monitoring, temperature tracking, and this adorable smart companion named Volt.',
    'scene5': 'It is completely free on the Google Play Store! Check the link in the comments and download Charge Alert right now!'
}

for name, text in lines.items():
    escaped = text.replace("'", "''")
    ps_file = f'{name}.ps1'
    wav_file = f'{name}.wav'
    ps_code = f"""Add-Type -AssemblyName System.Speech
$s = New-Object System.Speech.Synthesis.SpeechSynthesizer
$s.SelectVoice('Microsoft Zira Desktop')
$s.Rate = 0
$s.SetOutputToWaveFile('{wav_file}')
$s.Speak('{escaped}')
$s.Dispose()
"""
    with open(ps_file, 'w', encoding='utf-8') as f:
        f.write(ps_code)
    subprocess.run(['powershell', '-ExecutionPolicy', 'Bypass', '-File', ps_file], check=True)
    if os.path.exists(ps_file):
        os.remove(ps_file)
    print(f"Generated: {wav_file} (exists: {os.path.exists(wav_file)})")
