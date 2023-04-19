import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:luna/environment.dart';

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
    TimeOfDay? departureTime,
    TimeOfDay? arrivalTime,
  }) async {
    const baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";
    final url = _buildUrl(
      baseUrl: baseUrl,
      origin: origin,
      destination: destination,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data["status"] != "OK") {
      // throw Exception(data["error_message"]);
      print("Error: ${data["status"]}");
      return {};
    }

    // routes[0] -> legs[0] -> duration -> text: e.g. "1 hour 48 mins"
    // routes[0] -> overview_polyline -> summary: e.g. "B10 and B27"
    // return data["routes"][0]["legs"][0]["duration"]["text"];
    final durationAsText = data["routes"][0]["legs"][0]["duration"]["text"];
    final durationInSeconds = data["routes"][0]["legs"][0]["duration"]["value"];
    final distanceInMeters = data["routes"][0]["legs"][0]["distance"]["value"];

    return {
      "durationAsText": durationAsText,
      "durationInSeconds": durationInSeconds,
      "distanceInMeters": distanceInMeters,
    };
  }

  Future<List<Prediction>> getPlacePredictions(String input) async {
    var response = await http.get(
        Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json"
            "?input=$input"
            "&key=$_apiKey"));

    if (response.statusCode == 200) {
      var predictions = json.decode(response.body)["predictions"] as List;
      return predictions
          .map((prediction) => Prediction.fromJson(prediction))
          .toList();
    } else {
      throw Exception("Failed to load predictions");
    }
  }

  String _buildUrl({
    required String baseUrl,
    required Position origin,
    required String destination,
    TimeOfDay? departureTime,
    TimeOfDay? arrivalTime,
  }) {
    final originString = "${origin.latitude},${origin.longitude}";
    final destinationString = destination.replaceAll(" ", "+");
    final timeMode = departureTime != null ? "departure_time" : "arrival_time";

    // Convert to DateTime objects
    DateTime now = DateTime.now();
    final time = departureTime != null
        ? DateTime(now.year, now.month, now.day, departureTime.hour,
                    departureTime.minute)
                .toUtc()
                .millisecondsSinceEpoch ~/
            1000
        : DateTime(now.year, now.month, now.day, arrivalTime!.hour,
                    arrivalTime.minute)
                .toUtc()
                .millisecondsSinceEpoch ~/
            1000;

    final url = StringBuffer(baseUrl)
      ..write("origin=$originString")
      ..write("&destination=$destinationString")
      ..write("&mode=driving")
      ..write("&$timeMode=$time")
      ..write("&key=$_apiKey");

    return url.toString();
  }
}

class Prediction {
  final String description;
  final String placeId;

  Prediction({required this.description, required this.placeId});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json["description"],
      placeId: json["place_id"],
    );
  }
}
