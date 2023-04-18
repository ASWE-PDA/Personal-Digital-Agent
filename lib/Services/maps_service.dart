import "dart:convert";
import "package:http/http.dart" as http;
import "package:geolocator/geolocator.dart";
import "package:luna/environment.dart";

/// The purpose of this class is to instantiate a Google Maps API service.
/// The service is used to get the duration of a route and to calculate the
/// optimal departure times.
class MapsService {
  MapsService() : _apiKey = Environment.googleMapsApiKey;

  final String _apiKey;
  static const baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  Future<Map<String, dynamic>> getRouteDetails({
    required Position origin,
    required String destination,
    String travelMode =
        "driving", // TODO import from settings. either bicycling, driving, transit or walking
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) async {
    const baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";
    final url = _buildUrl(
      baseUrl: baseUrl,
      origin: origin,
      destination: destination,
      travelMode: travelMode,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data["status"] != "OK") {
      // throw Exception(data['error_message']);
      print("Error: ${data["status"]}");
      return {};
    }

    // routes[0] -> legs[0] -> duration -> text: e.g. "1 hour 48 mins"
    // routes[0] -> overview_polyline -> summary: e.g. "B10 and B27"
    // return data['routes'][0]['legs'][0]['duration']['text'];
    final durationAsText = data["routes"][0]["legs"][0]["duration"]["text"];
    final durationInSeconds = data["routes"][0]["legs"][0]["duration"]["value"];
    final distanceInMeters = data["routes"][0]["legs"][0]["distance"]["value"];

    return {
      "durationAsText": durationAsText,
      "durationInSeconds": durationInSeconds,
      "distanceInMeters": distanceInMeters,
    };
  }

  String _buildUrl({
    required String baseUrl,
    required Position origin,
    required String destination,
    required String travelMode,
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) {
    final originString = "${origin.latitude},${origin.longitude}";
    final destinationString = destination.replaceAll(" ", "+");
    final travelModeString = travelMode.toLowerCase();
    final timeMode = departureTime != null ? "departure_time" : "arrival_time";
    final time = departureTime != null
        ? departureTime.toUtc().millisecondsSinceEpoch ~/ 1000
        : arrivalTime!.toUtc().millisecondsSinceEpoch ~/ 1000;

    final url = StringBuffer(baseUrl)
      ..write("origin=$originString")
      ..write("&destination=$destinationString")
      ..write("&mode=$travelModeString")
      ..write("&$timeMode=$time")
      ..write("&key=$_apiKey");

    return url.toString();
  }
}
