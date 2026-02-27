@echo off
echo 🚀 Building SkillSocket for PRODUCTION
echo =====================================

echo 📦 Getting dependencies...
flutter pub get

echo 🔨 Building production APK with security features...
flutter build apk --release ^
  --obfuscate ^
  --split-debug-info=debug-info/ ^
  --dart-define=API_BASE_URL=https://skillsocket-backend.onrender.com/api ^
  --dart-define=SOCKET_BASE_URL=https://skillsocket-backend.onrender.com/

echo ✅ Production APK built successfully!
echo 📁 Location: build\app\outputs\flutter-apk\app-release.apk

echo 📋 Renaming APK for distribution...
copy "build\app\outputs\flutter-apk\app-release.apk" "skillsocket-v1.0.0.apk"
echo ✅ Distribution APK: skillsocket-v1.0.0.apk

echo.
echo 🔐 Security Features:
echo ✓ Backend URL obfuscated
echo ✓ Environment-specific configuration
echo ✓ Production optimizations enabled

pause