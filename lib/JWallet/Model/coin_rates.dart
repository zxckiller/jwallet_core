import 'package:json_annotation/json_annotation.dart'; 
  
part 'coin_rates.g.dart';


@JsonSerializable()
  class CoinRates extends Object {

  @JsonKey(name: 'statusCode')
  int statusCode;

  @JsonKey(name: 'errmsg')
  String errmsg;

  @JsonKey(name: 'data')
  List<Data> data;

  CoinRates(this.statusCode,this.errmsg,this.data,);

  factory CoinRates.fromJson(Map<String, dynamic> srcJson) => _$CoinRatesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CoinRatesToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'base')
  String base;

  @JsonKey(name: 'rates')
  List<Rates> rates;

  Data(this.base,this.rates,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
@JsonSerializable()
  class Rates extends Object {

  @JsonKey(name: 'foriegn')
  String foriegn;

  @JsonKey(name: 'rate')
  double rate;

  Rates(this.foriegn,this.rate,);

  factory Rates.fromJson(Map<String, dynamic> srcJson) => _$RatesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RatesToJson(this);

}

  
