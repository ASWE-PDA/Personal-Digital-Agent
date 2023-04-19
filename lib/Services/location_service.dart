import 'package:geolocator/geolocator.dart';

/// Class that is responsible for getting the current location.
class LocationService {
  /// Singleton instance of the [LocationService] class.
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();

  /// Private constructor of the [LocationService] class.
  LocationService._();

  /// Gets the current location.
  ///
  /// Returns the current location.
  Future<Position?> getCurrentLocation() async {
    try {
      // check permisisons
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // permission has not been granted, request permission
        final permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus != LocationPermission.whileInUse &&
            permissionStatus != LocationPermission.always) {
          return null;
        }
      }
      // get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      return null;
    }
  }
}
