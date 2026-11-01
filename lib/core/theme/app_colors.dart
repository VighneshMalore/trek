import 'package:flutter/material.dart';

/// TrailMate centralized color tokens.
/// All hex values live here — never scatter them elsewhere.
abstract final class AppColors {
  // Brand
  static const Color primaryGreen = Color(0xFF4F6814);
  static const Color accentOrange = Color(0xFFF47B20);

  // Backgrounds & surfaces
  static const Color background = Color(0xFFF7F5ED);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color raisedSurface = Color(0xFFFCE1D1);

  // Typography
  static const Color primaryText = Color(0xFF1C1A18);
  static const Color secondaryText = Color(0xFF736554);

  // Border
  static const Color border = Color(0xFFEDEBE5);

  // Utility
  static const Color transparent = Colors.transparent;
}

