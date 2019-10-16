//所有钱包的基类实现
import 'package:uuid/uuid.dart';

import '../JHttpJubiter.dart';
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';
import '../JsonableObject.dart';
import '../jwallet_core.dart';
import 'dart:convert';

enum WalletType {BTC, ETH}

abstract class JWalletBase extends JsonableObject with JHttpJubiter{
  //傻逼dart没有protected属性，不定义成public，你让我子类怎么用？？？
  //钱包名
  String name;
  //网络入口                 
  String endPoint;
  //钱包类型，子类设置
  WalletType wType;
  //keyStore类型
  JInterfaceKeyStore keyStore;
  //uuid
  String uuid;
  //main_path
  String mainPath;
  //临时的contexID，不需要持久化
  int contextID;
  JWalletBase(String _endPoint,JInterfaceKeyStore keyStoreimpl){
    endPoint = _endPoint;
    keyStore = keyStoreimpl;
    uuid = new Uuid().v4();
  }

  //Json构造函数
  JWalletBase.fromJson(Map<String, dynamic> json):
    wType = WalletType.values[json["wType"]],
    endPoint = json["endPoint"],
    uuid = json["uuid"],
    mainPath = json["mainPath"]
  {
    keyStore = JKeyStoreFactory.fromJson(json["keyStore"]);
  }

  Map<String, dynamic> toJson() =>
  {
    'wType': wType.index,
    'keyStore' : keyStore,
    'endPoint' : endPoint,
    'uuid' : uuid,
    'mainPath' : mainPath
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

  Future<bool> init() async{
    return keyStore.init();
  }
  
  Future<bool> active({String deviceSN,int deviceID});
  
}