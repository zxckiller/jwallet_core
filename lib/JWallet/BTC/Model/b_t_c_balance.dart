import 'package:json_annotation/json_annotation.dart'; 
  
part 'b_t_c_balance.g.dart';


@JsonSerializable()
  class BTCBalance extends Object {

  @JsonKey(name: 'statusCode')
  int statusCode;

  @JsonKey(name: 'errmsg')
  String errmsg;

  @JsonKey(name: 'data')
  int data;

  BTCBalance(this.statusCode,this.errmsg,this.data,);

  factory BTCBalance.fromJson(Map<String, dynamic> srcJson) => _$BTCBalanceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BTCBalanceToJson(this);

}

  
