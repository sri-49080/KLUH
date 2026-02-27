#!/bin/bash

# 🔐 Secure Flutter Build Script for Production
# ============================================

echo "🚀 Building SkillSocket with Security Features"
echo "=============================================="

# Set production environment variables
export API_BASE_URL="https://skillsocket-backend.onrender.com/api"
export SOCKET_BASE_URL="https://skillsocket-backend.onrender.com/"

echo "📦 Installing dependencies..."
flutter pub get

echo "🧹 Cleaning previous builds..."
flutter clean

echo "🔨 Building secure APK..."
flutter build apk --release \
  --obfuscate \
  --split-debug-info=debug-info/ \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  --dart-define=SOCKET_BASE_URL="$SOCKET_BASE_URL" \
  --target-platform android-arm,android-arm64

echo "✅ Secure APK built successfully!"
echo "📁 Location: build/app/outputs/flutter-apk/"
echo ""
echo "🔐 Security features enabled:"
echo "✓ Code obfuscation"
echo "✓ Environment-based URLs"
echo "✓ Split debug info"
echo "✓ Multiple architectures"
echo ""
echo "📋 Next steps:"
echo "1. Test the APK thoroughly"
echo "2. Upload to your distribution platform"
echo "3. Keep debug-info/ folder for crash analysis"