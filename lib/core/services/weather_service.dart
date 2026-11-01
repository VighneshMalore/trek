import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/weather_model.dart';

/// Service responsible for fetching live forecast data from the Open-Meteo API.
class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches weather data for specific coordinates.
  /// Enforces a 10-second timeout and wraps any failure in a [WeatherException].
  Future<WeatherModel> fetchWeather(double latitude, double longitude) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,weather_code,precipitation,wind_speed_10m',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '5',
    });

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode != 200) {
        throw const WeatherException('Weather service returned an error');
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const WeatherException('Malformed weather response');
      }

      return WeatherModel.fromJson(decoded);
    } on WeatherException {
      rethrow;
    } catch (_) {
      throw const WeatherException('Weather information unavailable');
    }
  }
}

