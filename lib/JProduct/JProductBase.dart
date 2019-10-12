import '../JsonableObject.dart';
import '../jwallet_core.dart';
import 'dart:convert';

enum ProductType {HD, JubiterBlade,Import}
abstract class JProductBase implements JsonableObject{
  String name;
  ProductType pType;
  List<String> wallets = new List<String>();

  JProductBase(String _name){
    name = _name;
  }

  //Json构造函数
  JProductBase.fromJson(Map<String, dynamic> _json):
    pType = ProductType.values[_json["pType"]],
    name = _json["name"]
    {
      (_json["wallets"] as List<dynamic>).map((f) => wallets.add(f as String));
    }
    

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'pType': pType.index,
    'wallets': wallets
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'name': name,
    'pType':pType.index
  };

  //Wallet操作函数
  Future<String> newWallet(String endPoint, WalletType wType);

  Future<T> getWallet<T>(String key){
    return getJWalletManager().getWallet<T>(key);
  }
}