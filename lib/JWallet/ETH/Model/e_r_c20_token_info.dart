import 'package:json_annotation/json_annotation.dart'; 
  
part 'e_r_c20_token_info.g.dart';


@JsonSerializable()
  class ERC20TokenInfo extends Object {

  @JsonKey(name: 'statusCode')
  int statusCode;

  @JsonKey(name: 'errmsg')
  String errmsg;

  @JsonKey(name: 'data')
  List<Data> data;

  ERC20TokenInfo(this.statusCode,this.errmsg,this.data,);

  factory ERC20TokenInfo.fromJson(Map<String, dynamic> srcJson) => _$ERC20TokenInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ERC20TokenInfoToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'token_type')
  String tokenType;

  @JsonKey(name: 'token_ename')
  String tokenEname;

  @JsonKey(name: 'token_addr')
  String tokenAddr;

  @JsonKey(name: 'token_symbol')
  String tokenSymbol;

  @JsonKey(name: 'token_icon_url')
  String tokenIconUrl;

  @JsonKey(name: 'coin_type')
  String coinType;

  @JsonKey(name: 'token_weight')
  int tokenWeight;

  @JsonKey(name: 'token_decimal')
  int tokenDecimal;

  Data(this.tokenType,this.tokenEname,this.tokenAddr,this.tokenSymbol,this.tokenIconUrl,this.coinType,this.tokenWeight,this.tokenDecimal,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
