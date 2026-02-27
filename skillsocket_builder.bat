@echo off
title SkillSocket APK Builder & Publisher
color 0A

echo.
echo  ███████╗██╗  ██╗██╗██╗     ██╗     ███████╗ ██████╗  ██████╗██╗  ██╗███████╗████████╗
echo  ██╔════╝██║ ██╔╝██║██║     ██║     ██╔════╝██╔═══██╗██╔════╝██║ ██╔╝██╔════╝╚══██╔══╝
echo  ███████╗█████╔╝ ██║██║     ██║     ███████╗██║   ██║██║     █████╔╝ █████╗     ██║   
echo  ╚════██║██╔═██╗ ██║██║     ██║     ╚════██║██║   ██║██║     ██╔═██╗ ██╔══╝     ██║   
echo  ███████║██║  ██╗██║███████╗███████╗███████║╚██████╔╝╚██████╗██║  ██╗███████╗   ██║   
echo  ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝   ╚═╝   
echo.
echo                        🚀 APK Builder & Publisher v1.0
echo                        ===================================
echo.

:menu
echo 📱 What would you like to do?
echo.
echo [1] 🔨 Build Production APK (Secure)
echo [2] 🧪 Build Development APK (Local Backend)
echo [3] 📊 Check APK Status
echo [4] 📋 View Distribution Guide
echo [5] 🌐 Open GitHub Releases
echo [6] ❌ Exit
echo.
set /p choice="Select option (1-6): "

if "%choice%"=="1" goto build_production
if "%choice%"=="2" goto build_development  
if "%choice%"=="3" goto check_apk
if "%choice%"=="4" goto show_guide
if "%choice%"=="5" goto open_github
if "%choice%"=="6" goto exit

echo Invalid choice. Please try again.
goto menu

:build_production
echo.
echo 🚀 Building Production APK...
echo =============================
echo.
echo 📦 Installing dependencies...
flutter pub get

echo 🧹 Cleaning previous builds...
flutter clean

echo 🔨 Building secure production APK...
flutter build apk --release ^
  --obfuscate ^
  --split-debug-info=debug-info/ ^
  --dart-define=API_BASE_URL=https://skillsocket-backend.onrender.com/api ^
  --dart-define=SOCKET_BASE_URL=https://skillsocket-backend.onrender.com/

if errorlevel 1 (
    echo ❌ Build failed! Check the errors above.
    pause
    goto menu
)

echo 📋 Creating distribution APK...
copy "build\app\outputs\flutter-apk\app-release.apk" "skillsocket-v1.0.0.apk" >nul

echo.
echo ✅ SUCCESS! Production APK created
echo 📁 File: skillsocket-v1.0.0.apk
echo 🔐 Security: Obfuscated + Environment Variables
echo 📊 Ready for distribution!
echo.
pause
goto menu

:build_development
echo.
echo 🧪 Building Development APK...
echo ==============================
echo.
flutter pub get
flutter build apk --debug ^
  --dart-define=API_BASE_URL=http://localhost:3000/api ^
  --dart-define=SOCKET_BASE_URL=http://localhost:3000/

if errorlevel 1 (
    echo ❌ Build failed! Check the errors above.
    pause
    goto menu
)

copy "build\app\outputs\flutter-apk\app-debug.apk" "skillsocket-dev.apk" >nul
echo ✅ Development APK: skillsocket-dev.apk
pause
goto menu

:check_apk
echo.
echo 📊 APK Status Check
echo ===================
echo.
if exist "skillsocket-v1.0.0.apk" (
    echo ✅ Production APK: Found
    for %%A in ("skillsocket-v1.0.0.apk") do (
        echo    📁 Size: %%~zA bytes
        echo    📅 Date: %%~tA
    )
) else (
    echo ❌ Production APK: Not found
)

if exist "skillsocket-dev.apk" (
    echo ✅ Development APK: Found
    for %%A in ("skillsocket-dev.apk") do (
        echo    📁 Size: %%~zA bytes  
        echo    📅 Date: %%~tA
    )
) else (
    echo ❌ Development APK: Not found
)
echo.
pause
goto menu

:show_guide
echo.
echo 📋 Distribution Guide
echo ====================
echo.
echo 🌐 Free Distribution Options:
echo.
echo 1. 🥇 GitHub Releases (Recommended)
echo    • Go to: github.com/AAC-Open-Source-Pool/25AACR02/releases
echo    • Click "Create a new release"
echo    • Upload skillsocket-v1.0.0.apk
echo    • Add release notes and publish
echo.
echo 2. 🥈 Google Drive
echo    • Upload APK to Google Drive  
echo    • Set sharing to "Anyone with link"
echo    • Share download link
echo.
echo 3. 🥉 APKPure
echo    • Create account at apkpure.com/developer
echo    • Upload APK with description
echo    • Wait for approval
echo.
echo 📱 Installation Instructions for Users:
echo 1. Download APK
echo 2. Enable "Unknown Sources" in Android Settings
echo 3. Install APK
echo 4. Launch SkillSocket!
echo.
pause
goto menu

:open_github
echo.
echo 🌐 Opening GitHub Releases...
start https://github.com/AAC-Open-Source-Pool/25AACR02/releases
goto menu

:exit
echo.
echo 👋 Thanks for using SkillSocket APK Builder!
echo 🚀 Happy distributing!
exit /b 0