import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium vibrant palette
  static const Color primaryColor = Color(0xFFFF6B00); // A more modern, punchy orange
  static const Color primaryDark = Color(0xFFCC5500);
  static const Color secondaryColor = Color(0xFF0F172A); // Very deep slate blue
  static const Color accentColor = Color(0xFF6366F1); // Modern indigo accent

  // Surface & background
  static const Color backgroundColor = Color(0xFFF8FAFC); // Clean slate-50
  static const Color surfaceColor = Colors.white;

  // Status colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color mutedTextColor = Color(0xFF94A3B8);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Box shadow styling
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: secondaryColor, letterSpacing: -1.0),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: secondaryColor, letterSpacing: -0.5),
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: secondaryColor),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: secondaryColor),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: secondaryColor),
          bodyLarge: TextStyle(fontSize: 16, color: textSecondary, height: 1.6),
          bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
          bodySmall: TextStyle(fontSize: 12, color: mutedTextColor, height: 1.4),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // App bars will be transparent or glass
        foregroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: secondaryColor),
        iconTheme: const IconThemeData(color: secondaryColor),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0, // Shadows handled manually for better blur spread
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFFCBD5E1),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0, // Flat look is more modern
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.2)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: mutedTextColor, fontSize: 15, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
        prefixIconColor: mutedTextColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor.withValues(alpha: 0.15),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFF1F5F9), thickness: 1.5),
    );
  }
}
