import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherWidget({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getWeatherColor(weatherData['condition'] as String)
                .withValues(alpha: 0.1),
            _getWeatherColor(weatherData['condition'] as String)
                .withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getWeatherColor(weatherData['condition'] as String)
              .withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getWeatherColor(weatherData['condition'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getWeatherIcon(weatherData['condition'] as String),
              color: _getWeatherColor(weatherData['condition'] as String),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${weatherData['temperature']}°C',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      weatherData['condition'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      weatherData['location'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Feels like',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                '${weatherData['feelsLike']}°C',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'cloudy':
      case 'overcast':
        return 'cloud';
      case 'rainy':
      case 'rain':
        return 'grain';
      case 'thunderstorm':
        return 'flash_on';
      case 'partly cloudy':
        return 'wb_cloudy';
      default:
        return 'wb_sunny';
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Colors.orange;
      case 'cloudy':
      case 'overcast':
        return Colors.grey;
      case 'rainy':
      case 'rain':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.purple;
      case 'partly cloudy':
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }
}
