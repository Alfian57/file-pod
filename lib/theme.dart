import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF567DF4);
  static const Color onPrimary = Colors.white;
  static const Color background = Color(0xFFF7F8FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF22215B);
  static const Color textSecondary = Color(0xFF6B6F76);

  static ThemeData light() {
    final base = ThemeData.light();

    final textTheme = TextTheme(
      displayLarge: GoogleFonts.questrial(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.questrial(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.questrial(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.questrial(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.questrial(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.questrial(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.questrial(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.questrial(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      bodyLarge: GoogleFonts.questrial(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.questrial(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.questrial(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: onPrimary,
      ),
      bodySmall: GoogleFonts.questrial(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.questrial(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        surface: surface,
        onPrimary: onPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          textStyle: GoogleFonts.questrial(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          backgroundColor: primary.withAlpha((0.06 * 255).round()),
          side: BorderSide(color: primary.withAlpha((0.14 * 255).round())),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          textStyle: GoogleFonts.questrial(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: textPrimary),
      primaryIconTheme: const IconThemeData(color: onPrimary),
    );
  }
}
