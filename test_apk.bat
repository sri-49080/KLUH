@echo off
echo 🧪 SkillSocket APK Test & Verification
echo =====================================

echo 📱 Checking if APK exists...
if exist "skillsocket-v1.0.0.apk" (
    echo ✅ APK found: skillsocket-v1.0.0.apk
    
    echo 📊 APK Information:
    for %%A in ("skillsocket-v1.0.0.apk") do (
        echo    Size: %%~zA bytes
        echo    Date: %%~tA
    )
    
    echo.
    echo 🔍 Next Steps:
    echo 1. Copy APK to Android device
    echo 2. Enable 'Unknown Sources' in Settings
    echo 3. Install and test all features
    echo 4. If working, upload to GitHub Releases
    echo.
    echo 🌐 Distribution Options:
    echo • GitHub Releases: github.com/AAC-Open-Source-Pool/25AACR02/releases
    echo • Google Drive: Upload and share link
    echo • APKPure: apkpure.com/developer
    echo.
    
) else (
    echo ❌ APK not found! Run build_production.bat first
    echo.
    echo 🔨 To generate APK:
    echo    build_production.bat
)

pause