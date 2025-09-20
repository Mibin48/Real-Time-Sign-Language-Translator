import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Modern gradient scheme
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFF06B6D4); // Cyan
  static const Color accentColor = Color(0xFFEC4899); // Pink
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFAFAFA);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textColor = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF94A3B8);
  
  // Border & Divider Colors
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color dividerColor = Color(0xFFE5E7EB);
  
  // Status Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
  
  // Overlay Colors
  static const Color overlayColor = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color glassMorphism = Color(0x20FFFFFF);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, Color(0xFF0891B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, surfaceElevated],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Enhanced Spacing System
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingBase = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2Xl = 48.0;
  static const double spacing3Xl = 64.0;
  static const double spacing4Xl = 80.0;

  // Modern Border Radius
  static const double borderRadiusXs = 4.0;
  static const double borderRadiusSm = 6.0;
  static const double borderRadiusBase = 8.0;
  static const double borderRadiusLg = 12.0;
  static const double borderRadiusXl = 16.0;
  static const double borderRadius2Xl = 20.0;
  static const double borderRadius3Xl = 24.0;
  static const double borderRadiusFull = 9999.0;

  // Typography Scale
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2Xl = 24.0;
  static const double fontSize3Xl = 30.0;
  static const double fontSize4Xl = 36.0;
  static const double fontSize5Xl = 48.0;
  static const double fontSize6Xl = 60.0;
  
  // Elevation/Shadow
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationXHigh = 16.0;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textColor,
        onError: textLight,
        outline: borderColor,
        shadow: overlayLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: overlayLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(borderRadiusXl),
            bottomRight: Radius.circular(borderRadiusXl),
          ),
        ),
        titleTextStyle: const TextStyle(
          fontSize: fontSizeLg,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          elevation: elevationMedium,
          shadowColor: primaryColor.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing2Xl,
            vertical: spacingBase,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusFull),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBase,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingBase,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusBase),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingBase,
            vertical: spacingSm,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: elevationLow,
        shadowColor: overlayLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
          side: BorderSide(
            color: borderLight,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(spacingSm),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingBase,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
          borderSide: const BorderSide(color: errorColor),
        ),
        hintStyle: TextStyle(
          color: textMuted,
          fontSize: fontSizeBase,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        elevation: elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusFull),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: Color(0xFF1E293B),
        error: errorColor,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textLight,
        onError: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: textLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingBase,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusBase),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLg),
        ),
      ),
    );
  }

  // Enhanced Text Styles with modern hierarchy
  static const TextStyle headingXLarge = TextStyle(
    fontSize: fontSize6Xl,
    fontWeight: FontWeight.w900,
    color: textColor,
    height: 1.1,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headingLarge = TextStyle(
    fontSize: fontSize4Xl,
    fontWeight: FontWeight.w800,
    color: textColor,
    height: 1.2,
    letterSpacing: -0.25,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: fontSize2Xl,
    fontWeight: FontWeight.w700,
    color: textColor,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: FontWeight.w600,
    color: textColor,
    height: 1.4,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w700,
    color: textColor,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeBase,
    fontWeight: FontWeight.w400,
    color: textColor,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: FontWeight.w500,
    color: textMuted,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w600,
    color: textColor,
    letterSpacing: 0.25,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    letterSpacing: 0.5,
  );
}
