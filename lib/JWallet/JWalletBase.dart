//所有钱包的基类实现
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';
import '../JsonableObject.dart';

enum WalletType {BTC, ETH}

abstract class JWalletBase implements JsonableObject{
  String name;
  String _endPoint;
  WalletType wType;
  JInterfaceKeyStore keyStore;
  JWalletBase(String endPoint,JInterfaceKeyStore keyStoreimpl){
    _endPoint = endPoint;
    keyStore = keyStoreimpl;
  }

  //Json构造函数
  JWalletBase.fromJson(Map<String, dynamic> json):
    wType = WalletType.values[json["wType"]],
    _endPoint = json["endPoint"]
  {
    keyStore = JKeyStoreFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() =>
  {
    'wType': wType.index,
    'keyStore' : keyStore,
    'endPoint' : _endPoint
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'wType': wType.index,
    'keyStore' : keyStore.toJsonKey()
  };
  
}