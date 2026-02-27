@echo off
echo 🧪 Building SkillSocket for DEVELOPMENT
echo =======================================

echo 📦 Getting dependencies...
flutter pub get

echo 🔨 Building development APK with local backend...
flutter build apk --debug ^
  --dart-define=API_BASE_URL=http://localhost:3000/api ^
  --dart-define=SOCKET_BASE_URL=http://localhost:3000/

echo ✅ Development APK built successfully!
echo 📁 Location: build\app\outputs\flutter-apk\app-debug.apk

echo.
echo 🔧 Development Features:
echo ✓ Local backend connection
echo ✓ Debug mode enabled
echo ✓ Fast iteration

pause