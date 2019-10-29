// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_r_c20_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ERC20TokenInfo _$ERC20TokenInfoFromJson(Map<String, dynamic> json) {
  return ERC20TokenInfo(
      json['statusCode'] as int,
      json['errmsg'] as String,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Data.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ERC20TokenInfoToJson(ERC20TokenInfo instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'errmsg': instance.errmsg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['token_type'] as String,
      json['token_ename'] as String,
      json['token_addr'] as String,
      json['token_symbol'] as String,
      json['token_icon_url'] as String,
      json['coin_type'] as String,
      json['token_weight'] as int,
      json['token_decimal'] as int);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'token_type': instance.tokenType,
      'token_ename': instance.tokenEname,
      'token_addr': instance.tokenAddr,
      'token_symbol': instance.tokenSymbol,
      'token_icon_url': instance.tokenIconUrl,
      'coin_type': instance.coinType,
      'token_weight': instance.tokenWeight,
      'token_decimal': instance.tokenDecimal
    };
