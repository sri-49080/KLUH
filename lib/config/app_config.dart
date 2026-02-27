class AppConfig {
  // Production URLs (deployed backend)
  static const String _prodBaseUrl = 'https://skillsocket-backend.onrender.com/api';
  static const String _prodSocketUrl = 'https://skillsocket-backend.onrender.com/';
  
  // Development URLs (local backend)
  static const String _devBaseUrl = 'http://localhost:3000/api';
  static const String _devSocketUrl = 'http://localhost:3000/';
  
  // Environment-based URL selection
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _prodBaseUrl, // Use production by default
  );

  static const String _socketUrl = String.fromEnvironment(
    'SOCKET_BASE_URL',
    defaultValue: _prodSocketUrl, // Use production by default
  );

  // API endpoints
  static String get baseUrl => _baseUrl;
  static String get socketUrl => _socketUrl;

  // Full endpoint URLs
  static String get apiUrl => '$_baseUrl';
  static String get authUrl => '$_baseUrl/auth';
  static String get userUrl => '$_baseUrl/user';
  static String get chatUrl => '$_baseUrl/chat';
  static String get reviewsUrl => '$_baseUrl/reviews';
  static String get connectionsUrl => '$_baseUrl/connections';
  static String get notificationsUrl => '$_baseUrl/notifications';
  static String get todosUrl => '$_baseUrl/todos';
  static String get eventsUrl => '$_baseUrl/events';
  static String get postsUrl => '$_baseUrl/posts';

  // Environment detection
  static bool get isProduction =>
      _baseUrl.contains('skillsocket-backend.onrender.com');
  static bool get isDevelopment =>
      _baseUrl.contains('localhost') || _baseUrl.contains('127.0.0.1');

  // Helper methods for environment URLs
  static String get productionBaseUrl => _prodBaseUrl;
  static String get productionSocketUrl => _prodSocketUrl;
  static String get developmentBaseUrl => _devBaseUrl;
  static String get developmentSocketUrl => _devSocketUrl;

  // Debug info
  static Map<String, dynamic> get debugInfo => {
        'baseUrl': _baseUrl,
        'socketUrl': _socketUrl,
        'productionBaseUrl': _prodBaseUrl,
        'productionSocketUrl': _prodSocketUrl,
        'developmentBaseUrl': _devBaseUrl,
        'developmentSocketUrl': _devSocketUrl,
        'isProduction': isProduction,
        'isDevelopment': isDevelopment,
      };
}
