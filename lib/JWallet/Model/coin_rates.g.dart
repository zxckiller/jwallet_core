// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_rates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRates _$CoinRatesFromJson(Map<String, dynamic> json) {
  return CoinRates(
      json['statusCode'] as int,
      json['errmsg'] as String,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Data.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CoinRatesToJson(CoinRates instance) => <String, dynamic>{
      'statusCode': instance.statusCode,
      'errmsg': instance.errmsg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['base'] as String,
      (json['rates'] as List)
          ?.map((e) =>
              e == null ? null : Rates.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'base': instance.base, 'rates': instance.rates};

Rates _$RatesFromJson(Map<String, dynamic> json) {
  return Rates(json['foriegn'] as String, (json['rate'] as num)?.toDouble());
}

Map<String, dynamic> _$RatesToJson(Rates instance) =>
    <String, dynamic>{'foriegn': instance.foriegn, 'rate': instance.rate};
