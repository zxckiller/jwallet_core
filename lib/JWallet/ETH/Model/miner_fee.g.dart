// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miner_fee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinerFee _$MinerFeeFromJson(Map<String, dynamic> json) {
  return MinerFee(
      json['statusCode'] as int,
      json['errmsg'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MinerFeeToJson(MinerFee instance) => <String, dynamic>{
      'statusCode': instance.statusCode,
      'errmsg': instance.errmsg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      (json['fastestFee'] as num)?.toDouble(),
      (json['halfHourFee'] as num)?.toDouble(),
      (json['hourFee'] as num)?.toDouble());
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'fastestFee': instance.fastestFee,
      'halfHourFee': instance.halfHourFee,
      'hourFee': instance.hourFee
    };
