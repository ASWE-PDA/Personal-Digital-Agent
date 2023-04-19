import 'package:luna/environment.dart';
import 'package:luna/Services/location_service.dart';
import 'package:weather/weather.dart';

class WeatherService {
  late final WeatherFactory _weatherFactory;
  late final LocationService _locationService;
  final String _apiKey = Environment.openWeatherApiKey;

  WeatherService() {
    _weatherFactory = WeatherFactory(_apiKey);
    _locationService = LocationService.instance;
  }

  Future<WeatherData?> getCurrentWeather() async {
    try {
      print("=========================");
      print("=========================");
      print("=========================");
      print("=========================");
      print(_apiKey);
      print("=========================");
      print("=========================");
      print("=========================");
      print("=========================");
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        print("Error getting current weather: position is null");
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
      print("Error getting current weather: $e");
      return null;
    }
  }
}

class WeatherData {
  final int? currentTemp;
  final int? feelsLikeTemp;

  WeatherData({required this.currentTemp, required this.feelsLikeTemp});
}
