import 'package:flutter/material.dart';

class VictusTheme {
  // Cores principais baseadas no Figma
  static const Color primaryPink = Color(0xFFD4A59A);
  static const Color primaryPinkLight = Color(0xFFF8E8E0);
  static const Color primaryPinkDark = Color(0xFFC08B7F);
  static const Color backgroundPink = Color(0xFFFFF5F0);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFBF9);
  
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF4A4A4A);
  static const Color textLight = Color(0xFF8A8A8A);
  static const Color textLink = Color(0xFFC08B7F);
  
  static const Color accentRed = Color(0xFFC41A1A);
  static const Color accentGreen = Color(0xFF6BBF6B);
  static const Color accentGold = Color(0xFFD4A574);
  
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF2D2D3F);
  
  static const Color divider = Color(0xFFE8E0DC);
  static const Color shadow = Color(0x1A000000);
  
  // Gradientes
  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF5F0), Color(0xFFFFFFFF)],
  );

  static const LinearGradient reminderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5D5CA), Color(0xFFF8E0D8)],
  );

  // Tipografia
  static const String fontFamily = 'SF Pro Display';

  static TextStyle get heading1 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textDark,
    height: 1.3,
  );

  static TextStyle get heading2 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textDark,
    height: 1.3,
  );

  static TextStyle get heading3 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textDark,
    height: 1.4,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textMedium,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textMedium,
    height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textLight,
    height: 1.4,
  );

  static TextStyle get buttonText => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: backgroundWhite,
    height: 1.2,
  );

  static TextStyle get label => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.3,
  );

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: shadow,
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: shadow.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  // ThemeData completo
  static ThemeData get themeData => ThemeData(
    primaryColor: primaryPink,
    scaffoldBackgroundColor: backgroundWhite,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.light(
      primary: primaryPink,
      secondary: primaryPinkLight,
      surface: backgroundWhite,
      error: accentRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: backgroundWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        minimumSize: const Size(double.infinity, 52),
        textStyle: buttonText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: primaryPink, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: textLight, fontSize: 14),
    ),
  );
}