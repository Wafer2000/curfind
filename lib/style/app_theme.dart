import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

Color customColor = WallpaperColor.purple().color;

List<Color> colorThemes = [
  customColor,
  WallpaperColor.green().color,
  WallpaperColor.black().color,
  WallpaperColor.white().color
];

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      colorSchemeSeed: colorThemes[1]
    );
  }
}
