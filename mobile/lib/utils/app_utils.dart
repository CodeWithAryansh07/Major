import 'package:intl/intl.dart';

/// Utility functions for formatting and data manipulation
class AppUtils {
  /// Format date/time for display
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  /// Format long date for detailed views
  static String formatLongDate(DateTime date) {
    return DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
  }

  /// Format file size in bytes to human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format number with abbreviations (1K, 1M, etc.)
  static String formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return '${(number / 1000).toStringAsFixed(1)}K';
    if (number < 1000000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Extract code preview (first few lines)
  static String getCodePreview(String code, {int maxLines = 3}) {
    final lines = code.split('\n');
    if (lines.length <= maxLines) return code;
    return lines.take(maxLines).join('\n');
  }

  /// Count lines in code
  static int countLines(String code) {
    return code.split('\n').length;
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Generate initials from name
  static String getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0].substring(0, 1).toUpperCase();
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  /// Get language file extension
  static String getLanguageExtension(String language) {
    const extensions = {
      'javascript': 'js',
      'typescript': 'ts',
      'python': 'py',
      'java': 'java',
      'go': 'go',
      'rust': 'rs',
      'cpp': 'cpp',
      'csharp': 'cs',
      'ruby': 'rb',
      'swift': 'swift',
    };
    return extensions[language] ?? 'txt';
  }

  /// Check if string is empty or whitespace only
  static bool isEmptyOrWhitespace(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Sanitize filename
  static String sanitizeFilename(String filename) {
    return filename.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
  }

  /// Generate a simple hash for strings (for cache keys, etc.)
  static int simpleHash(String str) {
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash + str.codeUnitAt(i)) & 0xffffffff;
    }
    return hash;
  }

  /// Debounce function calls
  static Function debounce(Function func, Duration delay) {
    Timer? timer;
    return ([List<dynamic>? positionalArgs, Map<Symbol, dynamic>? namedArgs]) {
      timer?.cancel();
      timer = Timer(delay, () => Function.apply(func, positionalArgs, namedArgs));
    };
  }

  /// Check if device is tablet (rough heuristic)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  /// Get platform-appropriate share text
  static String getShareText(String title, String content) {
    return '''Check out this code snippet: $title

$content

Shared via CodeCraft''';
  }

  /// Color utilities
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

// Import statements needed for the utilities above
import 'dart:async';
import 'package:flutter/material.dart';