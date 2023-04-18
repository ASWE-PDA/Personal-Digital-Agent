// class that stores the lights api results of the philips hue api
class Light {
  final int id;
  final String name;
  final bool on;
  final bool reachable;

  Light({
    required this.id,
    required this.name,
    required this.on,
    required this.reachable,
  });

  factory Light.fromJson(Map<String, dynamic> json, int id) {
    return Light(
      id: id,
      name: json["name"],
      on: json["state"]["on"],
      reachable: json["state"]["reachable"],
    );
  }
}

// class that stores the discovery api results of the philips hue api
class Bridge {
  final String id;
  final String internalipaddress;
  int port;

  Bridge({
    required this.id,
    required this.internalipaddress,
    required this.port,
  });

  factory Bridge.fromJson(Map<String, dynamic> json) {
    return Bridge(
      id: json["id"],
      internalipaddress: json["internalipaddress"],
      port: json["port"],
    );
  }
}

// class that stores a list of bridges
class Bridges {
  final List<Bridge> bridges;

  Bridges({
    required this.bridges,
  });

  factory Bridges.fromJson(List<dynamic> parsedJson) {
    List<Bridge> bridges = <Bridge>[];
    bridges = parsedJson.map((i) => Bridge.fromJson(i)).toList();

    return Bridges(
      bridges: bridges,
    );
  }
}
