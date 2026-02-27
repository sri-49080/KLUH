# 🔐 Secure Frontend Configuration Guide

## 🎯 Problem Solved

**Before**: Backend URLs were hardcoded and visible to anyone who reverse-engineers the APK
**After**: URLs are environment-based and can be obfuscated during build

## 🛠️ Implementation

### **1. Environment Configuration (`lib/config/app_config.dart`)**

```dart
class AppConfig {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.skillsocket.dev/api',
  );

  static String get baseUrl => _baseUrl;
  static String get socketUrl => _socketUrl;
  // ... other endpoints
}
```

### **2. Build Commands with Environment Variables**

#### **Production Build** 🚀

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://skillsocket-backend.onrender.com/api \
  --dart-define=SOCKET_BASE_URL=https://skillsocket-backend.onrender.com/
```

#### **Development Build** 🧪

```bash
flutter build apk --debug \
  --dart-define=API_BASE_URL=http://localhost:3000/api \
  --dart-define=SOCKET_BASE_URL=http://localhost:3000/
```

### **3. Service Integration**

All services now use `AppConfig`:

```dart
// Before (❌ Insecure)
static const String baseUrl = 'https://skillsocket-backend.onrender.com/api';

// After (✅ Secure)
static String get baseUrl => AppConfig.userUrl;
```

## 🔒 Security Benefits

### **1. URL Obfuscation**

- URLs are not hardcoded in source code
- Compile-time constants make reverse engineering harder
- Environment-specific builds possible

### **2. Build-Time Security**

- Different URLs for dev/staging/production
- No sensitive URLs in version control
- Build scripts handle environment injection

### **3. Additional Security Layers**

- **Code Obfuscation**: `--obfuscate` flag during build
- **ProGuard**: Minifies and obfuscates Android code
- **Certificate Pinning**: Can be added for extra security

## 📱 Usage Instructions

### **For Development**

```cmd
# Run development build script
build_development.bat

# Or use Flutter directly
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

### **For Production**

```cmd
# Run production build script
build_production.bat

# Or use Flutter directly with obfuscation
flutter build apk --release --obfuscate --split-debug-info=debug-info/ \
  --dart-define=API_BASE_URL=https://skillsocket-backend.onrender.com/api
```

## 🚀 Advanced Security (Optional)

### **1. Certificate Pinning**

```dart
class SecureHttpClient {
  static final HttpClient client = HttpClient()
    ..badCertificateCallback = (cert, host, port) {
      // Verify certificate against pinned certificates
      return verifyCertificate(cert, host);
    };
}
```

### **2. API Key Encryption**

```dart
class ApiKeyManager {
  static String getEncryptedApiKey() {
    // Decrypt API key at runtime
    return decryptApiKey(encryptedKey);
  }
}
```

### **3. Request Signing**

```dart
class RequestSigner {
  static Map<String, String> signRequest(Map<String, dynamic> data) {
    final signature = generateHMAC(data, secretKey);
    return {'signature': signature, ...headers};
  }
}
```

## 📊 Security Comparison

| Aspect                     | Before (❌)          | After (✅)            |
| -------------------------- | -------------------- | --------------------- |
| **URL Visibility**         | Hardcoded in source  | Environment-based     |
| **Reverse Engineering**    | Easy to extract URLs | Harder to find URLs   |
| **Environment Management** | Single hardcoded URL | Multiple environments |
| **Build Security**         | No obfuscation       | Optional obfuscation  |
| **Configuration**          | Manual URL changes   | Automated via builds  |

## 🔧 Troubleshooting

### **Issue**: App can't connect to backend

**Solution**: Check environment variables in build command

### **Issue**: URLs still visible in APK

**Solution**: Use `--obfuscate` flag and ensure environment variables are used

### **Issue**: Different environments mixing up

**Solution**: Use different app IDs for different environments

## 📋 Security Checklist

- [ ] All hardcoded URLs removed from source code
- [ ] AppConfig class implemented
- [ ] All services updated to use AppConfig
- [ ] Build scripts created for different environments
- [ ] Production build uses obfuscation
- [ ] Environment variables not committed to git
- [ ] Test both development and production builds
- [ ] Verify URLs are not easily visible in APK

## 🎯 Best Practices

1. **Never commit real URLs** to version control
2. **Use different domains** for different environments
3. **Implement certificate pinning** for production
4. **Use build-time constants** instead of runtime configuration
5. **Test security** by reverse engineering your own APK
6. **Monitor for leaked credentials** in logs/crashes

## 📱 Production Deployment

```bash
# Secure production build
flutter build apk --release \
  --obfuscate \
  --split-debug-info=debug-info/ \
  --dart-define=API_BASE_URL=https://your-production-api.com/api \
  --dart-define=SOCKET_BASE_URL=https://your-production-api.com/
```

This approach significantly improves security while maintaining flexibility for different environments! 🔐✨
