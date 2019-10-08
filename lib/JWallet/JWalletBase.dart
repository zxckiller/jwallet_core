//所有钱包的基类实现
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';

enum WalletType { BTC, ETH}

abstract class JWalletBase{
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
  wType = WalletType.values[json["type"]]{
    keyStore = JKeyStoreFactory.fromJson(json);
    wType = json["wType"];
    _endPoint = json["endPoint"];
  }

  Map<String, dynamic> toJson() =>
  {
    'wType': wType.index,
    'keyStore' : keyStore,
    'endPoint' : _endPoint
  };


  
}