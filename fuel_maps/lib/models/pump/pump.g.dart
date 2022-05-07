// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pump.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pump _$PumpFromJson(Map<String, dynamic> json) => Pump(
      id: json['id'] as String,
      fuelType: json['fuel_type'] as String,
      price: (json['price'] as num).toDouble(),
      available: json['available'] as bool,
    );

Map<String, dynamic> _$PumpToJson(Pump instance) => <String, dynamic>{
      'id': instance.id,
      'fuel_type': instance.fuelType,
      'price': instance.price,
      'available': instance.available,
    };
