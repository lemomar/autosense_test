import 'package:flutter/material.dart';
import 'package:fuel_maps/shared/theme/theme.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends HiveObject {
  @HiveField(0)
  String themeMode;

  final lightTheme = appLightTheme;
  final darkTheme = appDarkTheme;

  Settings({
    this.themeMode = "system",
  });

  void saveTheme() async {
    if (themeMode == "system") return;

    final box = Hive.box<Settings>("settings");
    await box.clear();
    await box.put("settings", this);
  }

  ThemeMode getThemeMode() {
    switch (themeMode) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      case "system":
      default:
        return ThemeMode.system;
    }
  }

  void changeThemeMode(bool isDarkModeActive) {
    switch (isDarkModeActive) {
      case true:
        themeMode = "dark";
        break;
      case false:
        themeMode = "light";
        break;
      default:
        break;
    }
    saveTheme();
  }
}
