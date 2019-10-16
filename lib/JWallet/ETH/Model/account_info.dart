import 'package:json_annotation/json_annotation.dart'; 
  
part 'account_info.g.dart';


@JsonSerializable()
  class AccountInfo extends Object {

  @JsonKey(name: 'statusCode')
  int statusCode;

  @JsonKey(name: 'errmsg')
  String errmsg;

  @JsonKey(name: 'data')
  Data data;

  AccountInfo(this.statusCode,this.errmsg,this.data,);

  factory AccountInfo.fromJson(Map<String, dynamic> srcJson) => _$AccountInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'balance')
  String balance;

  @JsonKey(name: 'tokens')
  List<dynamic> tokens;

  @JsonKey(name: 'nonce')
  String nonce;

  @JsonKey(name: 'localNonce')
  String localNonce;

  @JsonKey(name: 'pending')
  bool pending;

  @JsonKey(name: 'pendingTxs')
  List<dynamic> pendingTxs;

  Data(this.balance,this.tokens,this.nonce,this.localNonce,this.pending,this.pendingTxs,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
