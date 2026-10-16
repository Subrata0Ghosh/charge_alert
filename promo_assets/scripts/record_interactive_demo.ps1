$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

Write-Host "Starting screen recording for 26 seconds on emulator..."
# Remove any old file
& $adb shell rm -f /sdcard/full_interactive_demo.mp4

# Launch screenrecord asynchronously
$recProcess = Start-Process -FilePath $adb -ArgumentList "shell screenrecord --time-limit 26 /sdcard/full_interactive_demo.mp4" -PassThru -WindowStyle Hidden

Start-Sleep -Seconds 1

# 1. Tap Volt (x=540, y=580)
Write-Host "Tapping Volt for reaction..."
& $adb shell input tap 540 580
Start-Sleep -Seconds 2

# Tap Volt again
& $adb shell input tap 540 580
Start-Sleep -Seconds 2

# 2. Toggle Theme: Light to Dark (x=710, y=140)
Write-Host "Toggling Theme to Dark..."
& $adb shell input tap 710 140
Start-Sleep -Seconds 2

# Toggle Theme back to Light
Write-Host "Toggling Theme to Light..."
& $adb shell input tap 710 140
Start-Sleep -Seconds 2

# Toggle Theme back to Dark
Write-Host "Toggling Theme back to Dark..."
& $adb shell input tap 710 140
Start-Sleep -Seconds 2

# 3. Slide 80% battery alert slider
Write-Host "Moving 80% slider..."
& $adb shell input swipe 750 1850 400 1850 400
Start-Sleep -Milliseconds 700
& $adb shell input swipe 400 1850 820 1850 400
Start-Sleep -Milliseconds 700
& $adb shell input swipe 820 1850 680 1850 400
Start-Sleep -Milliseconds 800

# 4. Scroll down to show controls
Write-Host "Scrolling down to buttons..."
& $adb shell input swipe 540 1800 540 600 400
Start-Sleep -Seconds 1

# Toggle Enable Alarm Sound switch (x=780, y=915)
Write-Host "Toggling Enable Alarm Sound..."
& $adb shell input tap 780 915
Start-Sleep -Milliseconds 600
& $adb shell input tap 780 915
Start-Sleep -Milliseconds 600

# Toggle Continuous Alarm switch (x=780, y=1095)
Write-Host "Toggling Continuous Alarm..."
& $adb shell input tap 780 1095
Start-Sleep -Milliseconds 600

# Toggle Low Battery Alert switch (x=780, y=1310)
Write-Host "Toggling Low Battery Alert..."
& $adb shell input tap 780 1310
Start-Sleep -Milliseconds 600

# Tap "Test alarm now" button (x=500, y=2350)
Write-Host "Tapping Test Alarm Now..."
& $adb shell input tap 500 2350
Start-Sleep -Seconds 2

# Scroll back up to show Guardian Anti-Theft & Volt
Write-Host "Scrolling back up..."
& $adb shell input swipe 540 600 540 1800 400
Start-Sleep -Seconds 1

# Tap Volt for final wave
& $adb shell input tap 540 580
Start-Sleep -Seconds 2

Write-Host "Waiting for recording process to finalize..."
$recProcess.WaitForExit(5000)

Start-Sleep -Seconds 1
Write-Host "Pulling full_interactive_demo.mp4..."
& $adb pull /sdcard/full_interactive_demo.mp4 ./full_interactive_demo.mp4
Write-Host "Video pulled successfully: $(Test-Path ./full_interactive_demo.mp4)"
