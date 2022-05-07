import 'package:json_annotation/json_annotation.dart';

part 'pump.g.dart';

@JsonSerializable(explicitToJson: true)
class Pump {
  const Pump({
    required this.id,
    required this.fuelType,
    required this.price,
    required this.available,
  });

  final String id;
  @JsonKey(name: "fuel_type")
  final String fuelType;
  final double price;
  final bool available;

  factory Pump.fromJson(Map<String, dynamic> json) => _$PumpFromJson(json);

  Map<String, dynamic> toJson() => _$PumpToJson(this);
}