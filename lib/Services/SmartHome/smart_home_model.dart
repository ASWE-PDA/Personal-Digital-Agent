/// This file contains the model classes for the philips hue api.

/// Class that stores the light api results of the philips hue api.
/// A light consists of an unique [id], a [name], a [on] state and a [reachable] state.
class Light {
  final int id;
  final String name;
  final bool on;
  final bool reachable;

  /// Constructor of the [Light] class.
  Light({
    required this.id,
    required this.name,
    required this.on,
    required this.reachable,
  });

  /// Creates a [Light] object from a json object.
  factory Light.fromJson(Map<String, dynamic> json, int id) {
    return Light(
      id: id,
      name: json['name'],
      on: json['state']['on'],
      reachable: json['state']['reachable'],
    );
  }
}

/// Class that stores the discovery api results of the philips hue api.
/// A bridge consists of an unique [id], an [internalipaddress] and a [port].
class Bridge {
  final String id;
  final String internalipaddress;
  int port;

  /// Constructor of the [Bridge] class.
  Bridge({
    required this.id,
    required this.internalipaddress,
    required this.port,
  });

  /// Creates a [Bridge] object from a json object.
  factory Bridge.fromJson(Map<String, dynamic> json) {
    return Bridge(
      id: json['id'],
      internalipaddress: json['internalipaddress'],
      port: json['port'],
    );
  }
}
