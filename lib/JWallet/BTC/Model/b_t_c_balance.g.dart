// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b_t_c_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BTCBalance _$BTCBalanceFromJson(Map<String, dynamic> json) {
  return BTCBalance(
      json['statusCode'] as int, json['errmsg'] as String, json['data'] as int);
}

Map<String, dynamic> _$BTCBalanceToJson(BTCBalance instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'errmsg': instance.errmsg,
      'data': instance.data
    };
