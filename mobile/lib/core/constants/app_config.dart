/// App configuration constants
class AppConfig {
  // API Endpoints
  static const String convexUrl = 'YOUR_CONVEX_URL_HERE'; // Replace with actual Convex URL
  static const String pistonApiUrl = 'https://emkc.org/api/v2/piston';
  
  // Authentication
  static const String clerkPublishableKey = 'YOUR_CLERK_KEY_HERE'; // Replace when implementing auth
  
  // App Settings
  static const String appName = 'CodeCraft';
  static const String appVersion = '1.0.0';
  static const int maxCodeLength = 50000; // Maximum characters in code editor
  static const int maxCommentLength = 1000; // Maximum characters in comments
  
  // Cache Settings
  static const Duration cacheExpiration = Duration(hours: 1);
  static const int maxCachedSnippets = 100;
  
  // UI Settings
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double borderRadius = 12.0;
  static const double cardElevation = 0.0;
  
  // Code Editor Settings
  static const String defaultLanguage = 'javascript';
  static const String defaultTheme = 'vs-dark';
  static const int maxHistoryItems = 50;
  
  // Feature Flags
  static const bool enableOfflineMode = false;
  static const bool enableSyntaxHighlighting = true;
  static const bool enableAutoSave = true;
  static const bool enablePushNotifications = false;
  
  // Network Settings
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}

/// Environment-specific configuration
enum Environment { development, staging, production }

class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.development;
  
  static String get convexUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'https://your-dev-convex-url.convex.dev';
      case Environment.staging:
        return 'https://your-staging-convex-url.convex.dev';
      case Environment.production:
        return 'https://your-prod-convex-url.convex.dev';
    }
  }
  
  static bool get isDebugMode {
    return currentEnvironment == Environment.development;
  }
  
  static String get appTitle {
    switch (currentEnvironment) {
      case Environment.development:
        return 'CodeCraft (Dev)';
      case Environment.staging:
        return 'CodeCraft (Staging)';
      case Environment.production:
        return 'CodeCraft';
    }
  }
}