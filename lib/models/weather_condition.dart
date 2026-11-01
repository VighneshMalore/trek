import 'package:flutter/material.dart';

/// Presentation representation of a WMO weather condition code.
class WeatherCondition {
  final String label;
  final IconData icon;

  const WeatherCondition({
    required this.label,
    required this.icon,
  });

  /// Maps standard WMO weather codes to user-friendly label and icon.
  factory WeatherCondition.fromCode(int code) {
    switch (code) {
      case 0:
        return const WeatherCondition(
          label: 'Clear sky',
          icon: Icons.wb_sunny_outlined,
        );
      case 1:
        return const WeatherCondition(
          label: 'Mainly clear',
          icon: Icons.wb_sunny_outlined,
        );
      case 2:
        return const WeatherCondition(
          label: 'Partly cloudy',
          icon: Icons.cloud_outlined,
        );
      case 3:
        return const WeatherCondition(
          label: 'Overcast',
          icon: Icons.cloud,
        );
      case 45:
      case 48:
        return const WeatherCondition(
          label: 'Fog',
          icon: Icons.foggy,
        );
      case 51:
      case 53:
      case 55:
        return const WeatherCondition(
          label: 'Drizzle',
          icon: Icons.water_drop_outlined,
        );
      case 56:
      case 57:
        return const WeatherCondition(
          label: 'Freezing drizzle',
          icon: Icons.ac_unit,
        );
      case 61:
      case 63:
      case 65:
        return const WeatherCondition(
          label: 'Rain',
          icon: Icons.water_drop_outlined,
        );
      case 66:
      case 67:
        return const WeatherCondition(
          label: 'Freezing rain',
          icon: Icons.ac_unit,
        );
      case 71:
      case 73:
      case 75:
        return const WeatherCondition(
          label: 'Snow',
          icon: Icons.ac_unit,
        );
      case 77:
        return const WeatherCondition(
          label: 'Snow grains',
          icon: Icons.ac_unit,
        );
      case 80:
      case 81:
      case 82:
        return const WeatherCondition(
          label: 'Rain showers',
          icon: Icons.water_drop_outlined,
        );
      case 85:
      case 86:
        return const WeatherCondition(
          label: 'Snow showers',
          icon: Icons.ac_unit,
        );
      case 95:
        return const WeatherCondition(
          label: 'Thunderstorm',
          icon: Icons.thunderstorm_outlined,
        );
      case 96:
      case 99:
        return const WeatherCondition(
          label: 'Thunderstorm with hail',
          icon: Icons.thunderstorm_outlined,
        );
      default:
        return const WeatherCondition(
          label: 'Unknown',
          icon: Icons.help_outline,
        );
    }
  }
}

