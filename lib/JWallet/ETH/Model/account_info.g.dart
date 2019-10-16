// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
  return AccountInfo(
      json['statusCode'] as int,
      json['errmsg'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'errmsg': instance.errmsg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['balance'] as String,
      json['tokens'] as List,
      json['nonce'] as String,
      json['localNonce'] as String,
      json['pending'] as bool,
      json['pendingTxs'] as List);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'balance': instance.balance,
      'tokens': instance.tokens,
      'nonce': instance.nonce,
      'localNonce': instance.localNonce,
      'pending': instance.pending,
      'pendingTxs': instance.pendingTxs
    };
