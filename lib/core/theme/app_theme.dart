import 'package:flutter/material.dart';
import 'package:getmarried/core/models/app_ui_config.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = fromConfig(AppUiConfig.defaults);

  static ThemeData fromConfig(AppUiConfig config) {
    final c = config.colors;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        primary: c.primary,
        secondary: c.primaryDark,
        surface: c.surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: c.background,
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border, width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          side: BorderSide(color: c.primary),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: c.navbarActive,
        unselectedItemColor: c.navbarInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: c.textPrimary,
        displayColor: c.textPrimary,
      ),
      extensions: [AppUiThemeExtension(config)],
    );
  }
}

class AppUiThemeExtension extends ThemeExtension<AppUiThemeExtension> {
  const AppUiThemeExtension(this.config);
  final AppUiConfig config;

  @override
  AppUiThemeExtension copyWith({AppUiConfig? config}) => AppUiThemeExtension(config ?? this.config);

  @override
  AppUiThemeExtension lerp(ThemeExtension<AppUiThemeExtension>? other, double t) {
    if (other is! AppUiThemeExtension) return this;
    return t < 0.5 ? this : other;
  }

  static AppUiConfig of(BuildContext context) {
    return Theme.of(context).extension<AppUiThemeExtension>()?.config ?? AppUiConfig.defaults;
  }
}
