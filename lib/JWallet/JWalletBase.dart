//所有钱包的基类实现
import 'package:uuid/uuid.dart';

import '../JHttpJubiter.dart';
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';
import '../JsonableObject.dart';
import '../jwallet_core.dart';
import 'dart:convert';

import 'package:jubiter_plugin/jubiter_plugin.dart';
import './Model/coin_rates.dart' as $cRates;

enum WalletType {BTC, ETH}
enum FiatType{CNY,USD,JYP}

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

  Future<bool> updateSelf() async{
    await getJWalletManager().updateOne(json.encode(this.toJsonKey()), this.toJson());
    return Future<bool>.value(true);
  }

  Future<bool> init() async{
    return keyStore.init();
  }
  
  Future<bool> active({String uuid,int deviceID});

  Future<int> showVirtualPWD() async {
    return JuBiterPlugin.showVirtualPWD(contextID);
  }

  //此接口可以返回rate列表，但当前应该用不到，先返回单一的个
  Future<$cRates.Rates> queryExchangeRates(String symbol,FiatType fType) async{
    String url = "https://public.jubiterwallet.com.cn/api/queryRatesBySymbols";
    Map<String,String> params = new Map<String,String>();
    params["symbol"] = symbol;
    var response = await httpPost(url,params);
    var coinRates = $cRates.CoinRates.fromJson(response);
    $cRates.Rates needRate;
    coinRates.data.forEach((coin){
      if(coin.base == symbol){
        coin.rates.forEach((rate){
          if(rate.foriegn == fType.toString().split('.').last)
            needRate = rate;
        });
      }
    });
    if(needRate != null){
      return Future<$cRates.Rates>.value(needRate);
    }else throw JUBR_SERVER_ERROR;
  }

  
}