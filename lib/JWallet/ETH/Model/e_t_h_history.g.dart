// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_t_h_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ETHHistory _$ETHHistoryFromJson(Map<String, dynamic> json) {
  return ETHHistory(
      json['statusCode'] as int,
      json['errmsg'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ETHHistoryToJson(ETHHistory instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'errmsg': instance.errmsg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['address'] as String,
      json['blockTxs'] == null
          ? null
          : BlockTxs.fromJson(json['blockTxs'] as Map<String, dynamic>),
      json['mempoolTxs'] == null
          ? null
          : MempoolTxs.fromJson(json['mempoolTxs'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'address': instance.address,
      'blockTxs': instance.blockTxs,
      'mempoolTxs': instance.mempoolTxs
    };

BlockTxs _$BlockTxsFromJson(Map<String, dynamic> json) {
  return BlockTxs((json['txList'] as List)
      ?.map(
          (e) => e == null ? null : TxList.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$BlockTxsToJson(BlockTxs instance) =>
    <String, dynamic>{'txList': instance.txList};

TxList _$TxListFromJson(Map<String, dynamic> json) {
  return TxList(
      json['blkIndex'] as int,
      json['txid'] as String,
      json['from'] as String,
      json['value'] as String,
      json['contractAddress'] as String,
      json['fee'] as String,
      json['nonce'] as String,
      json['txIndex'] as int,
      json['txType'] as String,
      json['tokenValue'] as String,
      json['to'] as String,
      json['blkTime'] as int,
      json['status'] as int);
}

Map<String, dynamic> _$TxListToJson(TxList instance) => <String, dynamic>{
      'blkIndex': instance.blkIndex,
      'txid': instance.txid,
      'from': instance.from,
      'value': instance.value,
      'contractAddress': instance.contractAddress,
      'fee': instance.fee,
      'nonce': instance.nonce,
      'txIndex': instance.txIndex,
      'txType': instance.txType,
      'tokenValue': instance.tokenValue,
      'to': instance.to,
      'blkTime': instance.blkTime,
      'status': instance.status
    };

MempoolTxs _$MempoolTxsFromJson(Map<String, dynamic> json) {
  return MempoolTxs((json['txList'] as List)
      ?.map(
          (e) => e == null ? null : TxList.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$MempoolTxsToJson(MempoolTxs instance) =>
    <String, dynamic>{'txList': instance.txList};
