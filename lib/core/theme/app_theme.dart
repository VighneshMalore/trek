import 'package:flutter/material.dart';
import 'app_colors.dart';

/// TrailMate global spacing tokens (8px base grid).
abstract final class AppSpacing {
  static const double xs = 8;
  static const double sm = 10;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
}

/// TrailMate border-radius tokens.
abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 100;
}

/// TrailMate typography scale (px = logical pixels / sp).
abstract final class AppTextSize {
  static const double xs = 12;
  static const double sm = 14;
  static const double md = 16;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 40;
  static const double xxxl = 48;
}

/// TrailMate global theme.
///
/// Usage:
/// ```dart
/// MaterialApp(theme: AppTheme.light, ...)
/// ```
abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,

      // Primary = deep natural green
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.surface,
      primaryContainer: Color(0xFFD4E5A0), // tint of primary for containers
      onPrimaryContainer: AppColors.primaryGreen,

      // Secondary = warm brown-ish text region
      secondary: AppColors.secondaryText,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.raisedSurface,
      onSecondaryContainer: AppColors.primaryText,

      // Tertiary = accent orange
      tertiary: AppColors.accentOrange,
      onTertiary: AppColors.surface,
      tertiaryContainer: Color(0xFFFDE8D4),
      onTertiaryContainer: Color(0xFF7B3200),

      // Error defaults
      error: Color(0xFFBA1A1A),
      onError: AppColors.surface,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      // Surfaces
      surface: AppColors.surface,
      onSurface: AppColors.primaryText,
      surfaceContainerHighest: AppColors.background,
      onSurfaceVariant: AppColors.secondaryText,

      // Outline
      outline: AppColors.border,
      outlineVariant: AppColors.border,

      // Inverse
      inverseSurface: AppColors.primaryText,
      onInverseSurface: AppColors.surface,
      inversePrimary: Color(0xFF9EC44A),

      // Scrim / shadow source
      scrim: AppColors.primaryText,
      shadow: AppColors.primaryText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // --- Scaffold ---
      scaffoldBackgroundColor: AppColors.background,

      // --- Typography ---
      // Satoshi not bundled; use system font. Family name centralised here —
      // swap to 'Satoshi' once the font asset is added, no other file changes needed.
      // ponytail: system font only, add Satoshi when font asset is available.
      fontFamily: null, // null = Flutter system default (Roboto on Android)
      textTheme: _buildTextTheme(),

      // --- AppBar ---
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.primaryText,
          fontSize: AppTextSize.lg,
          fontWeight: FontWeight.w700,
        ),
      ),

      // --- Card ---
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.border),
        ),
        // Subtle shadow per spec: rgba(0,0,0,0.20) 0 1 2
        shadowColor: Colors.black.withValues(alpha: 0.20),
      ),

      // --- NavigationBar (bottom) ---
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.20),
        elevation: 1,
        indicatorColor: AppColors.primaryGreen.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryGreen, size: 24);
          }
          return const IconThemeData(color: AppColors.secondaryText, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: AppTextSize.xs,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: AppColors.secondaryText,
            fontSize: AppTextSize.xs,
            fontWeight: FontWeight.w500,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // --- ElevatedButton ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          textStyle: const TextStyle(
            fontSize: AppTextSize.sm,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // --- FilledButton ---
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),

      // --- OutlinedButton ---
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),

      // --- TextButton ---
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
        ),
      ),

      // --- InputDecoration ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: AppColors.secondaryText,
          fontSize: AppTextSize.sm,
        ),
      ),

      // --- Chip ---
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        labelStyle: const TextStyle(
          color: AppColors.primaryText,
          fontSize: AppTextSize.xs,
          fontWeight: FontWeight.w500,
        ),
        selectedColor: AppColors.primaryGreen.withValues(alpha: 0.12),
      ),

      // --- Divider ---
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // --- ListTile ---
      listTileTheme: const ListTileThemeData(
        tileColor: AppColors.surface,
        iconColor: AppColors.secondaryText,
        titleTextStyle: TextStyle(
          color: AppColors.primaryText,
          fontSize: AppTextSize.sm,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: AppColors.secondaryText,
          fontSize: AppTextSize.xs,
        ),
      ),

      // --- BottomSheet ---
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),

      // --- Dialog ---
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      // --- SnackBar ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryText,
        contentTextStyle: const TextStyle(color: AppColors.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    // Base: 14px / 500 weight / ~18.9px line height (factor ≈1.35).
    // Headings use stronger weight. All sizes from the spec scale.
    return const TextTheme(
      // Display / hero
      displayLarge: TextStyle(
        fontSize: AppTextSize.xxxl,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.15,
      ),
      displayMedium: TextStyle(
        fontSize: AppTextSize.xxl,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: AppTextSize.xl,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.25,
      ),

      // Headline
      headlineLarge: TextStyle(
        fontSize: AppTextSize.xl,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTextSize.lg,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTextSize.md,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.35,
      ),

      // Title
      titleLarge: TextStyle(
        fontSize: AppTextSize.lg,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontSize: AppTextSize.md,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.35,
      ),
      titleSmall: TextStyle(
        fontSize: AppTextSize.sm,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.35,
      ),

      // Body — base is 14px / 500 / ≈1.35
      bodyLarge: TextStyle(
        fontSize: AppTextSize.md,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTextSize.sm,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.35,
      ),
      bodySmall: TextStyle(
        fontSize: AppTextSize.xs,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryText,
        height: 1.4,
      ),

      // Label
      labelLarge: TextStyle(
        fontSize: AppTextSize.sm,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.35,
      ),
      labelMedium: TextStyle(
        fontSize: AppTextSize.xs,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryText,
        height: 1.4,
      ),
    );
  }
}

