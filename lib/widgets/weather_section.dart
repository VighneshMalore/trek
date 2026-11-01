import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/weather_condition.dart';
import '../models/weather_model.dart';
import 'section_header.dart';

/// Self-contained weather section displaying live conditions and a 5-day forecast.
class WeatherSection extends StatefulWidget {
  const WeatherSection({
    super.key,
    required this.latitude,
    required this.longitude,
    this.weatherService,
  });

  final double latitude;
  final double longitude;
  final WeatherService? weatherService;

  @override
  State<WeatherSection> createState() => _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  late final WeatherService _weatherService;
  WeatherModel? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _weatherService = widget.weatherService ?? WeatherService();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(
        widget.latitude,
        widget.longitude,
      );
      if (mounted) {
        setState(() {
          _weather = weather;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Weather information unavailable';
          _isLoading = false;
        });
      }
    }
  }

  String _dayLabel(DateTime date, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Weather'),
        const SizedBox(height: AppSpacing.sm),
        if (_isLoading)
          _buildLoadingCard()
        else if (_errorMessage != null || _weather == null)
          _buildErrorCard()
        else
          _buildWeatherContent(_weather!),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 32,
            color: AppColors.secondaryText,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _errorMessage ?? 'Weather information unavailable',
            style: const TextStyle(
              fontSize: AppTextSize.sm,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: _loadWeather,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(WeatherModel weather) {
    final current = weather.current;
    final condition = WeatherCondition.fromCode(current.weatherCode);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current Weather Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    condition.icon,
                    size: 40,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${current.temperature.round()}°C',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          condition.label,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.xl, color: AppColors.border),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.xs,
                children: [
                  _CurrentMetaItem(
                    label: 'Feels like ${current.apparentTemperature.round()}°C',
                  ),
                  _CurrentMetaItem(
                    label: 'Wind ${current.windSpeed.round()} km/h',
                  ),
                  _CurrentMetaItem(
                    label: 'Precipitation ${current.precipitation.toStringAsFixed(1)} mm',
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 5-Day Forecast Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < weather.daily.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                _ForecastTile(
                  dayLabel: _dayLabel(weather.daily[i].date, i),
                  forecast: weather.daily[i],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrentMetaItem extends StatelessWidget {
  const _CurrentMetaItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: AppTextSize.xs,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryText,
      ),
    );
  }
}

class _ForecastTile extends StatelessWidget {
  const _ForecastTile({
    required this.dayLabel,
    required this.forecast,
  });

  final String dayLabel;
  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    final condition = WeatherCondition.fromCode(forecast.weatherCode);
    final rainChance = forecast.precipitationProbability != null
        ? '${forecast.precipitationProbability}%'
        : '—';

    return Container(
      width: 82,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayLabel,
            style: const TextStyle(
              fontSize: AppTextSize.xs,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Icon(
            condition.icon,
            size: 24,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${forecast.maxTemp.round()}° / ${forecast.minTemp.round()}°',
            style: const TextStyle(
              fontSize: AppTextSize.xs,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rainChance,
            style: const TextStyle(
              fontSize: AppTextSize.xs,
              fontWeight: FontWeight.w600,
              color: AppColors.accentOrange,
            ),
          ),
        ],
      ),
    );
  }
}

