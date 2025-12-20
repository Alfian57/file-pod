import 'package:flutter/material.dart';

class FolderColors {
  final Color background;
  final Color icon;
  final Color text;

  const FolderColors({
    required this.background,
    required this.icon,
    required this.text,
  });
}

class FolderColorProvider {
  static const availableColors = [
    FolderColors(
      background: Color(0xFFEAF5FF),
      icon: Color(0xFF4B6BE6),
      text: Color(0xFF4B6BE6),
    ),
    FolderColors(
      background: Color(0xFFFFF6E6),
      icon: Color(0xFFF5B400),
      text: Color(0xFFF5B400),
    ),
    FolderColors(
      background: Color(0xFFFFEFEF),
      icon: Color(0xFFD94B48),
      text: Color(0xFFD94B48),
    ),
    FolderColors(
      background: Color(0xFFE8FFFB),
      icon: Color(0xFF13C8B7),
      text: Color(0xFF13C8B7),
    ),
  ];

  static FolderColors getColorForIndex(int index) {
    return availableColors[index % availableColors.length];
  }

  static FolderColors getColor(String? colorString) {
    if (colorString == null) return availableColors[0];
    // Find color where background value matches (assuming we store hex of background)
    // Or we store index? Storing hex is safer.
    // Let's assume we store the hex string of the background color.
    try {
      final color = int.parse(colorString);
      return availableColors.firstWhere(
        (c) => c.background.value == color,
        orElse: () => availableColors[0],
      );
    } catch (_) {
      return availableColors[0];
    }
  }
}
