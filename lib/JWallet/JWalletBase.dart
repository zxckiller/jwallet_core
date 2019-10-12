//所有钱包的基类实现
import 'package:uuid/uuid.dart';

import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';
import '../JsonableObject.dart';
import '../jwallet_core.dart';
import 'dart:convert';

enum WalletType {BTC, ETH}

abstract class JWalletBase extends JsonableObject{
  String name;
  String _endPoint;
  WalletType wType;
  JInterfaceKeyStore keyStore;
  String uuid;
  JWalletBase(String endPoint,JInterfaceKeyStore keyStoreimpl){
    _endPoint = endPoint;
    keyStore = keyStoreimpl;
    uuid = new Uuid().v4();
  }

  //Json构造函数
  JWalletBase.fromJson(Map<String, dynamic> json):
    wType = WalletType.values[json["wType"]],
    _endPoint = json["endPoint"],
    uuid = json["uuid"]
  {
    keyStore = JKeyStoreFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() =>
  {
    'wType': wType.index,
    'keyStore' : keyStore,
    'endPoint' : _endPoint,
    'uuid' : uuid
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'wType': wType.index,
    'keyStore' : keyStore.toJsonKey(),
    'uuid' : uuid
  };

  void updateSelf(){
    getJWalletManager().addOne(json.encode(this.toJsonKey()), this.toJson());
  }
  
}