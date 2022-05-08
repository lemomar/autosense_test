// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String?,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pumps: (json['pumps'] as List<dynamic>)
          .map((e) => Pump.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pumps': instance.pumps.map((e) => e.toJson()).toList(),
    };
