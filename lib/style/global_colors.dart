import 'package:flutter/material.dart';

class WallpaperColor {
  final Color color;

  const WallpaperColor._(this.color);

  factory WallpaperColor.black() {
    return const WallpaperColor._(Color(0xFF000000));
  }

  factory WallpaperColor.white() {
    return const WallpaperColor._(Color(0xFFFFFFFF));
  }

  factory WallpaperColor.greenDark() {
    return const WallpaperColor._(Color(0xFF6DFF6E));
  }

  factory WallpaperColor.green() {
    return const WallpaperColor._(Color(0xFFADEBC9));
  }

  factory WallpaperColor.greenLight() {
    return const WallpaperColor._(Color(0xFFF2FFF7));
  }

  factory WallpaperColor.purpleDark() {
    return const WallpaperColor._(Color(0xFFBD93BF));
  }

  factory WallpaperColor.purple() {
    return const WallpaperColor._(Color(0xFFE3CCF6));
  }

  factory WallpaperColor.purpleLight() {
    return const WallpaperColor._(Color(0xFFF8F4FF));
  }
}

class IconColor {
  final Color color;

  const IconColor._(this.color);

  factory IconColor.black() {
    return const IconColor._(Color(0xFF040606));
  }

  factory IconColor.white() {
    return const IconColor._(Color(0xFFFFFFFF));
  }

  factory IconColor.greenSuperLight() {
    return const IconColor._(Color(0xFFC7F8DD));
  }

  factory IconColor.greenLight() {
    return const IconColor._(Color(0xFF90CDA1));
  }

  factory IconColor.green() {
    return const IconColor._(Color(0xFF53D39A));
  }

  factory IconColor.purpleSuperLight() {
    return const IconColor._(Color(0xFFE3CCF6));
  }

  factory IconColor.purpleLight() {
    return const IconColor._(Color(0xFF9880C6));
  }

  factory IconColor.purple() {
    return const IconColor._(Color(0xFF9855E3));
  }
}

class TextColor {
  final Color color;

  const TextColor._(this.color);

  factory TextColor.black() {
    return const TextColor._(Color(0xFF000000));
  }

  factory TextColor.white() {
    return const TextColor._(Color(0xFFFFFFFF));
  }

  factory TextColor.greenlight() {
    return const TextColor._(Color(0xFFF2FFF7));
  }

  factory TextColor.green() {
    return const TextColor._(Color(0xFF53D39A));
  }

  factory TextColor.greenDark() {
    return const TextColor._(Color(0xFF43A047));
  }

  factory TextColor.greenDarker() {
    return const TextColor._(Color(0xFF2E7D32));
  }

  factory TextColor.purple() {
    return const TextColor._(Color(0xFF9880C6));
  }

  factory TextColor.purpleLight() {
    return const TextColor._(Color(0xFFF8F4FF));
  }

  factory TextColor.purpleDark() {
    return const TextColor._(Color(0xFF9855E3));
  }
}
