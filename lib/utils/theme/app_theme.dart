import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    // Syne — used for all display, headline, and title styles
    // Sharp, geometric, great for prices and headings on dark backgrounds
    final syne = GoogleFonts.syneTextTheme();

    // DM Sans — used for body, label styles
    // Clean and highly readable at small sizes for coin data
    final dmSans = GoogleFonts.dmSansTextTheme();

    return TextTheme(
      // ── Display — large prices, hero numbers ──────────────────────────
      displayLarge: GoogleFonts.syne(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: primary,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: primary,
      ),
      displaySmall: GoogleFonts.syne(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: primary,
      ),

      // ── Headlines — section titles, screen headings ───────────────────
      headlineLarge: GoogleFonts.syne(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineSmall: GoogleFonts.syne(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),

      // ── Titles — coin names, card titles ──────────────────────────────
      titleLarge: GoogleFonts.syne(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: GoogleFonts.syne(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: GoogleFonts.syne(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: secondary,
      ),

      // ── Body — descriptions, summaries ────────────────────────────────
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),

      // ── Labels — chips, badges, metadata, timestamps ──────────────────
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: secondary,
      ),
    );
  }

  // ─── Color Schemes ────────────────────────────────────────────────────────

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFDDD4),
    onPrimaryContainer: Color(0xFF5C1500),
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFE0B2),
    onSecondaryContainer: Color(0xFF3E2000),
    tertiary: AppColors.accent,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEEEEEE),
    onTertiaryContainer: Color(0xFF111318),
    error: AppColors.negative,
    onError: Colors.white,
    errorContainer: AppColors.negativeSurface,
    onErrorContainer: AppColors.negative,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightDivider,
    outlineVariant: AppColors.lightDivider,
    shadow: Color(0x14000000),
    scrim: Color(0x80111318),
    inverseSurface: AppColors.darkSurface,
    onInverseSurface: AppColors.darkTextPrimary,
    inversePrimary: AppColors.primary,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF5C1500),
    onPrimaryContainer: Color(0xFFFFDDD4),
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF3E2000),
    onSecondaryContainer: Color(0xFFFFE0B2),
    tertiary: AppColors.accent,
    onTertiary: AppColors.darkBackground,
    tertiaryContainer: AppColors.darkSurfaceVariant,
    onTertiaryContainer: AppColors.darkTextPrimary,
    error: AppColors.negative,
    onError: Colors.white,
    errorContainer: Color(0xFF4D1515),
    onErrorContainer: Color(0xFFFFB3B3),
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkDivider,
    outlineVariant: AppColors.darkDivider,
    shadow: Color(0x80000000),
    scrim: Color(0x99000000),
    inverseSurface: AppColors.lightSurface,
    onInverseSurface: AppColors.lightTextPrimary,
    inversePrimary: AppColors.primary,
  );

  // ─── Shared widget themes builder ─────────────────────────────────────────

  static ThemeData _build(ColorScheme cs, TextTheme tt, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      textTheme: tt,
      scaffoldBackgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,

      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        foregroundColor: isDark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: tt.headlineMedium,
        iconTheme: IconThemeData(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
        actionsIconTheme: IconThemeData(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        systemOverlayStyle: isDark
            ? const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
                statusBarColor: Colors.transparent,
              )
            : const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.transparent,
              ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: tt.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          side: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: tt.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: tt.labelLarge?.copyWith(color: AppColors.primary),
        ),
      ),

      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        hintStyle: tt.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        prefixIconColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        labelStyle: tt.labelMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return IconThemeData(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return tt.labelSmall?.copyWith(color: AppColors.primary);
          }
          return tt.labelSmall?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          );
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),

      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        titleTextStyle: tt.titleMedium,
        subtitleTextStyle: tt.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
        dragHandleColor: isDark
            ? AppColors.darkDivider
            : AppColors.lightDivider,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        labelStyle: tt.labelLarge,
        unselectedLabelStyle: tt.labelLarge,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: tt.headlineSmall,
        contentTextStyle: tt.bodyMedium,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightTextPrimary,
        contentTextStyle: tt.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkTextPrimary : Colors.white,
        ),
        actionTextColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData get lightThemeData => _build(
    _lightColorScheme,
    _buildTextTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
    Brightness.light,
  );

  static ThemeData get darkThemeData => _build(
    _darkColorScheme,
    _buildTextTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
    Brightness.dark,
  );
}
