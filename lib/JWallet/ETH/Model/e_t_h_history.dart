import 'package:json_annotation/json_annotation.dart'; 
  
part 'e_t_h_history.g.dart';


@JsonSerializable()
  class ETHHistory extends Object {

  @JsonKey(name: 'statusCode')
  int statusCode;

  @JsonKey(name: 'errmsg')
  String errmsg;

  @JsonKey(name: 'data')
  Data data;

  ETHHistory(this.statusCode,this.errmsg,this.data,);

  factory ETHHistory.fromJson(Map<String, dynamic> srcJson) => _$ETHHistoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ETHHistoryToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'blockTxs')
  BlockTxs blockTxs;

  @JsonKey(name: 'mempoolTxs')
  MempoolTxs mempoolTxs;

  Data(this.address,this.blockTxs,this.mempoolTxs,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
@JsonSerializable()
  class BlockTxs extends Object {

  @JsonKey(name: 'txList')
  List<TxList> txList;

  BlockTxs(this.txList,);

  factory BlockTxs.fromJson(Map<String, dynamic> srcJson) => _$BlockTxsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BlockTxsToJson(this);

}

  
@JsonSerializable()
  class TxList extends Object {

  @JsonKey(name: 'blkIndex')
  int blkIndex;

  @JsonKey(name: 'txid')
  String txid;

  @JsonKey(name: 'from')
  String from;

  @JsonKey(name: 'value')
  String value;

  @JsonKey(name: 'contractAddress')
  String contractAddress;

  @JsonKey(name: 'fee')
  String fee;

  @JsonKey(name: 'nonce')
  String nonce;

  @JsonKey(name: 'txIndex')
  int txIndex;

  @JsonKey(name: 'txType')
  String txType;

  @JsonKey(name: 'tokenValue')
  String tokenValue;

  @JsonKey(name: 'to')
  String to;

  @JsonKey(name: 'blkTime')
  int blkTime;

  @JsonKey(name: 'status')
  int status;

  TxList(this.blkIndex,this.txid,this.from,this.value,this.contractAddress,this.fee,this.nonce,this.txIndex,this.txType,this.tokenValue,this.to,this.blkTime,this.status,);

  factory TxList.fromJson(Map<String, dynamic> srcJson) => _$TxListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TxListToJson(this);

}

  
@JsonSerializable()
  class MempoolTxs extends Object {

  @JsonKey(name: 'txList')
  List<TxList> txList;

  MempoolTxs(this.txList,);

  factory MempoolTxs.fromJson(Map<String, dynamic> srcJson) => _$MempoolTxsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MempoolTxsToJson(this);

}