/// Exception thrown when weather fetching or parsing fails.
class WeatherException implements Exception {
  final String message;
  const WeatherException([this.message = 'Weather information unavailable']);

  @override
  String toString() => message;
}

/// Current weather snapshot.
class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final double precipitation;
  final double windSpeed;
  final int weatherCode;

  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.precipitation,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    try {
      return CurrentWeather(
        temperature: (json['temperature_2m'] as num).toDouble(),
        apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
        precipitation: (json['precipitation'] as num).toDouble(),
        windSpeed: (json['wind_speed_10m'] as num).toDouble(),
        weatherCode: (json['weather_code'] as num).toInt(),
      );
    } catch (_) {
      throw const WeatherException('Invalid current weather data');
    }
  }
}

/// Single-day forecast item.
class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double minTemp;
  final double maxTemp;
  final int? precipitationProbability;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.minTemp,
    required this.maxTemp,
    this.precipitationProbability,
  });
}

/// Root weather model containing current condition and daily forecasts.
class WeatherModel {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  const WeatherModel({
    required this.current,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentMap = json['current'];
    final dailyMap = json['daily'];

    if (currentMap is! Map<String, dynamic> || dailyMap is! Map<String, dynamic>) {
      throw const WeatherException('Missing weather payload');
    }

    final current = CurrentWeather.fromJson(currentMap);

    final times = dailyMap['time'] as List<dynamic>?;
    final weatherCodes = dailyMap['weather_code'] as List<dynamic>?;
    final maxTemps = dailyMap['temperature_2m_max'] as List<dynamic>?;
    final minTemps = dailyMap['temperature_2m_min'] as List<dynamic>?;
    final precipProbs = dailyMap['precipitation_probability_max'] as List<dynamic>?;

    if (times == null || weatherCodes == null || maxTemps == null || minTemps == null) {
      throw const WeatherException('Missing required daily weather arrays');
    }

    final count = times.length;
    if (weatherCodes.length != count ||
        maxTemps.length != count ||
        minTemps.length != count ||
        (precipProbs != null && precipProbs.length != count)) {
      throw const WeatherException('Daily forecast data length mismatch');
    }

    try {
      final dailyList = <DailyForecast>[];
      for (int i = 0; i < count; i++) {
        dailyList.add(
          DailyForecast(
            date: DateTime.parse(times[i] as String),
            weatherCode: (weatherCodes[i] as num).toInt(),
            maxTemp: (maxTemps[i] as num).toDouble(),
            minTemp: (minTemps[i] as num).toDouble(),
            precipitationProbability: precipProbs?[i] == null
                ? null
                : (precipProbs![i] as num).toInt(),
          ),
        );
      }
      return WeatherModel(current: current, daily: dailyList);
    } catch (_) {
      throw const WeatherException('Failed to parse daily forecast entries');
    }
  }
}

