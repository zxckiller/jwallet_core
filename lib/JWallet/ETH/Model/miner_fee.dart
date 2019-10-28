import 'package:json_annotation/json_annotation.dart'; 
  
part 'miner_fee.g.dart';


@JsonSerializable()
  class MinerFee extends Object {

  @JsonKey(name: 'statusCode')
  int statusCode;

  @JsonKey(name: 'errmsg')
  String errmsg;

  @JsonKey(name: 'data')
  Data data;

  MinerFee(this.statusCode,this.errmsg,this.data,);

  factory MinerFee.fromJson(Map<String, dynamic> srcJson) => _$MinerFeeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MinerFeeToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'fastestFee')
  int fastestFee;

  @JsonKey(name: 'halfHourFee')
  int halfHourFee;

  @JsonKey(name: 'hourFee')
  int hourFee;

  Data(this.fastestFee,this.halfHourFee,this.hourFee,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
