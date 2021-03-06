import 'package:fuel_maps/models/pump/pump.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station.g.dart';

@JsonSerializable(explicitToJson: true)
class Station {
  const Station({
    required this.id,
    this.creatorId,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.pumps,
  });
  final String id;
  final String? creatorId;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final List<Pump> pumps;

  static Station get empty =>
      const Station(id: "", name: "", address: "", city: "", latitude: 0, longitude: 0, pumps: []);

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);

  Marker toMarker() => Marker(
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
      );
}

final List<Station> sampleStationList = [
  {
    "id": "MIGROL_100041",
    "name": "Migrol Tankstelle",
    "address": "Scheffelstrasse 16",
    "city": "Zürich",
    "latitude": 47.3943939,
    "longitude": 8.52981,
    "pumps": [
      {"id": 10001, "fuel_type": "BENZIN_95", "price": 1.68, "available": true},
      {"id": 10002, "fuel_type": "BENZIN_98", "price": 1.77, "available": false},
      {"id": 10003, "fuel_type": "DIESEL", "price": 1.75, "available": true}
    ]
  },
  {
    "id": "MIGROL_100085",
    "name": "Migrol Service",
    "address": "Birmensdorferstrasse 517",
    "city": "Zürich",
    "latitude": 47.367348257,
    "longitude": 8.4942242729,
    "pumps": [
      {"id": 10001, "fuel_type": "BENZIN_95", "price": 1.72, "available": true},
      {"id": 10002, "fuel_type": "BENZIN_98", "price": 1.79, "available": true},
      {"id": 10003, "fuel_type": "DIESEL", "price": 1.71, "available": false}
    ]
  }
].map(Station.fromJson).toList();
