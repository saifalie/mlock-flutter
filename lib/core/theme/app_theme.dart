import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Custom colors based on your logo
  static const Color darkGreen = Color(
    0xFF0A3B23,
  ); // Dark green background from logo
  static const Color lightGreen = Color(
    0xFF4CAF50,
  ); // Green color for "LOCK" text
  static const Color white = Colors.white; // White color for "M"
  static const Color accentGold = Color.fromRGBO(
    254,
    206,
    1,
    1,
  ); // Keeping your gold accent

  // Create container colors properly
  static final Color darkGreenContainer = Color.alphaBlend(
    darkGreen.withAlpha(80),
    Colors.white,
  );
  static final Color lightGreenContainer = Color.alphaBlend(
    lightGreen.withAlpha(50),
    Colors.white,
  );
  static final Color accentGoldContainer = Color.alphaBlend(
    accentGold.withAlpha(50),
    Colors.white,
  );

  // Dark theme container colors
  static final Color darkGreenContainerDark = Color.alphaBlend(
    darkGreen.withAlpha(80),
    const Color(0xFF121212),
  );
  static final Color lightGreenContainerDark = Color.alphaBlend(
    lightGreen.withAlpha(50),
    const Color(0xFF121212),
  );
  static final Color accentGoldContainerDark = Color.alphaBlend(
    accentGold.withAlpha(50),
    const Color(0xFF121212),
  );

  // Custom color scheme - avoiding deprecated properties
  static final ColorScheme _customLightScheme = ColorScheme(
    primary: darkGreen,
    primaryContainer: darkGreenContainer,
    secondary: lightGreen,
    secondaryContainer: lightGreenContainer,
    tertiary: accentGold,
    tertiaryContainer: accentGoldContainer,
    // Using surfaceContainerHighest instead of background
    surface: Colors.white,
    surfaceContainer: const Color(0xFFF5F5F5),
    surfaceContainerLow: const Color(0xFFFAFAFA),
    surfaceContainerLowest: Colors.white,
    surfaceContainerHigh: const Color(0xFFEEEEEE),
    surfaceContainerHighest: const Color(0xFFE0E0E0),
    error: Colors.red,
    onPrimary: white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static final ColorScheme _customDarkScheme = ColorScheme(
    primary: darkGreen,
    primaryContainer: darkGreenContainerDark,
    secondary: lightGreen,
    secondaryContainer: lightGreenContainerDark,
    tertiary: accentGold,
    tertiaryContainer: accentGoldContainerDark,
    // Using surfaceContainerHighest instead of background
    surface: const Color(0xFF121212),
    surfaceContainer: const Color(0xFF1E1E1E),
    surfaceContainerLow: const Color(0xFF191919),
    surfaceContainerLowest: const Color(0xFF121212),
    surfaceContainerHigh: const Color(0xFF252525),
    surfaceContainerHighest: const Color(0xFF2C2C2C),
    error: Colors.red.shade700,
    onPrimary: white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  // Light theme
  static ThemeData get lightTheme => FlexThemeData.light(
    // Instead of using a predefined scheme, we'll use our custom colors
    colors: FlexSchemeColor(
      primary: darkGreen,
      primaryContainer: darkGreenContainer,
      secondary: lightGreen,
      secondaryContainer: lightGreenContainer,
      tertiary: accentGold,
      tertiaryContainer: accentGoldContainer,
      appBarColor: darkGreen,
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      appBarBackgroundSchemeColor: SchemeColor.primary,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
      navigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
      navigationBarSelectedIconSchemeColor: SchemeColor.secondary,
      navigationBarIndicatorSchemeColor: SchemeColor.secondary,
    ),
    keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
    tones: FlexTones.material(Brightness.light),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // Set the scheme to use the updated one
    scheme: FlexScheme.custom,
    colorScheme: _customLightScheme,
  );

  // Dark theme
  static ThemeData get darkTheme => FlexThemeData.dark(
    colors: FlexSchemeColor(
      primary: darkGreen,
      primaryContainer: darkGreenContainerDark,
      secondary: lightGreen,
      secondaryContainer: lightGreenContainerDark,
      tertiary: accentGold,
      tertiaryContainer: accentGoldContainerDark,
      appBarColor: darkGreen,
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      appBarBackgroundSchemeColor: SchemeColor.primary,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
      navigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
      navigationBarSelectedIconSchemeColor: SchemeColor.secondary,
      navigationBarIndicatorSchemeColor: SchemeColor.secondary,
    ),
    keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
    tones: FlexTones.material(Brightness.dark),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // Set the scheme to use the updated one
    scheme: FlexScheme.custom,
    colorScheme: _customDarkScheme,
  );
}

