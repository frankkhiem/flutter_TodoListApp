import 'dart:convert';

class Location {
  num longitude;
  num latitude;
  Location({ this.longitude = 105.7836350, this.latitude = 21.0847770});

  factory Location.fromJson(Map<String, dynamic> json) {
    List<dynamic> coordinates = json["coordinates"];
    Location newLocation = new Location(longitude: coordinates[0], latitude: coordinates[1]);
    return newLocation;
  }
}