import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final ThemeData appLightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff181d1c),
    primaryContainer: Color(0xffd0e4ff),
    secondary: Color(0xfff7c5a0),
    secondaryContainer: Color(0xffffdbcf),
    tertiary: Color(0xfffaf4e6),
    tertiaryContainer: Color(0xffefe3a8),
    appBarColor: Color(0xffffdbcf),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog,
  blendLevel: 30,
  appBarOpacity: 0.95,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 19,
    textButtonRadius: 10.0,
    elevatedButtonRadius: 10.0,
    outlinedButtonRadius: 10.0,
    toggleButtonsRadius: 10.0,
    elevatedButtonSchemeColor: SchemeColor.secondary,
    inputDecoratorSchemeColor: SchemeColor.onTertiary,
    inputDecoratorRadius: 13.0,
    chipSchemeColor: SchemeColor.secondary,
    popupMenuRadius: 8.0,
    dialogBackgroundSchemeColor: SchemeColor.secondary,
    navigationRailIndicatorSchemeColor: SchemeColor.secondary,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailLabelType: NavigationRailLabelType.none,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
    keepPrimaryContainer: true,
    keepSecondaryContainer: true,
    keepTertiaryContainer: true,
  ),
  tones: FlexTones.highContrast(Brightness.light),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

final ThemeData appDarkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xff181d1c),
    primaryContainer: Color(0xffd0e4ff),
    secondary: Color(0xfff7c5a0),
    secondaryContainer: Color(0xffffdbcf),
    tertiary: Color(0xfffaf4e6),
    tertiaryContainer: Color(0xffefe3a8),
    appBarColor: Color(0xffffdbcf),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 15,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.90,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 30,
    textButtonRadius: 10.0,
    elevatedButtonRadius: 10.0,
    outlinedButtonRadius: 10.0,
    toggleButtonsRadius: 10.0,
    elevatedButtonSchemeColor: SchemeColor.secondary,
    inputDecoratorRadius: 13.0,
    chipSchemeColor: SchemeColor.secondary,
    popupMenuRadius: 8.0,
    dialogBackgroundSchemeColor: SchemeColor.secondary,
    navigationRailIndicatorSchemeColor: SchemeColor.secondary,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailLabelType: NavigationRailLabelType.none,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
  ),
  tones: FlexTones.highContrast(Brightness.dark),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
