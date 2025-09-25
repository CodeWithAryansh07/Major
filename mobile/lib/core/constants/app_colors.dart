import 'package:flutter/material.dart';

/// Color constants extracted from the Next.js CodeCraft application
class AppColors {
  // Primary Brand Colors (extracted from CSS gradients)
  static const Color backgroundPrimary = Color(0xFF0a0a0f); // bg-[#0a0a0f]
  static const Color backgroundSecondary = Color(0xFF121218); // bg-[#121218]
  static const Color backgroundCard = Color(0xFF1a1a2e); // from-[#1a1a2e]
  
  // Gradient Colors
  static const Color blueStart = Color(0xFF3B82F6); // blue-500
  static const Color blueEnd = Color(0xFF60A5FA); // blue-400
  static const Color purpleStart = Color(0xFF8B5CF6); // purple-500
  static const Color purpleEnd = Color(0xFFA78BFA); // purple-400
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF9FAFB); // gray-50
  static const Color textSecondary = Color(0xFFD1D5DB); // gray-300
  static const Color textTertiary = Color(0xFF9CA3AF); // gray-400
  static const Color textMuted = Color(0xFF6B7280); // gray-500
  
  // Border Colors
  static const Color borderPrimary = Color(0xFF374151); // gray-700
  static const Color borderSecondary = Color(0xFF4B5563); // gray-600
  static const Color borderAccent = Color(0xFF1F2937); // gray-800
  
  // Interactive Colors
  static const Color blueAccent = Color(0xFF60A5FA); // blue-400
  static const Color purpleAccent = Color(0xFFA78BFA); // purple-400
  static const Color amberAccent = Color(0xFFFBBF24); // amber-400
  static const Color greenAccent = Color(0xFF10B981); // emerald-500
  static const Color redAccent = Color(0xFFEF4444); // red-500
  
  // Surface Colors with opacity (glass morphism effect)
  static const Color surfaceWithOpacity = Color(0x1A374151); // gray-700/10
  static const Color surfaceHover = Color(0x33374151); // gray-700/20
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueStart, purpleStart],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundCard, backgroundSecondary],
  );
  
  static const LinearGradient textGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [blueEnd, blueAccent, purpleEnd],
  );
  
  // Monaco Editor Theme Colors
  static const Color monacoBackground = Color(0xFF1e1e1e); // vs-dark
  static const Color monacoForeground = Color(0xFFd4d4d4);
  static const Color monacoLineNumber = Color(0xFF858585);
  static const Color monacoSelection = Color(0xFF264f78);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}