//所有钱包的基类实现
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';

enum CoinType { BTC, ETH}

abstract class JWalletBase{
  String name;
  String _endPoint;
  CoinType type;
  JInterfaceKeyStore keyStore;
  JWalletBase(String endPoint,JInterfaceKeyStore keyStoreimpl){
    _endPoint = endPoint;
    keyStore = keyStoreimpl;
  }

  //Json构造函数
  JWalletBase.fromJson(Map<String, dynamic> json):
  type = CoinType.values[json["type"]];

  Map<String, dynamic> toJson() =>
  {
    'coin_type': type.index,
    'key_store' : keyStore,
  };


  
}