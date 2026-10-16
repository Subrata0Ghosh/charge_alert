Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SelectVoice("Microsoft Zira Desktop")
$synth.Rate = 0
$synth.SetOutputToWaveFile("test_voice.wav")
$synth.Speak("Hey everyone! Are you still overcharging your phone overnight? You need this app right now!")
$synth.Dispose()
Write-Host "Audio generated: $(Test-Path test_voice.wav)"
