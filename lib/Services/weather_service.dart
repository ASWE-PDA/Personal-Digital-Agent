import 'package:luna/environment.dart';
import 'package:luna/Services/location_service.dart';
import 'package:weather/weather.dart';

/// Class that provides the current weather.
class WeatherService {
  late final WeatherFactory _weatherFactory;
  late final LocationService _locationService;
  final String _apiKey = Environment.openWeatherApiKey;

  /// Constructor of the [WeatherService] class.
  WeatherService() {
    _weatherFactory = WeatherFactory(_apiKey);
    _locationService = LocationService.instance;
  }

  /// Gets the current weather.
  ///
  /// Returns the current weather.
  Future<WeatherData?> getCurrentWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        return null;
      }

      final weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      return WeatherData(
        currentTemp: weather.temperature?.celsius?.round(),
        feelsLikeTemp: weather.tempFeelsLike?.celsius?.round(),
      );
    } catch (e) {
      return null;
    }
  }
}

/// Data class for the current weather with the [currentTemp] and the
/// [feelsLikeTemp].
class WeatherData {
  final int? currentTemp;
  final int? feelsLikeTemp;

  /// Constructor for the [WeatherData] class.
  WeatherData({required this.currentTemp, required this.feelsLikeTemp});
}
