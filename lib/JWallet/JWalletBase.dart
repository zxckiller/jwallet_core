//所有钱包的基类实现
import 'package:flutter/cupertino.dart';
import 'package:jwallet_core/JWalletContainer.dart';
import 'package:uuid/uuid.dart';

import '../JHttpJubiter.dart';
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';
import '../jwallet_core.dart';
import 'dart:convert';

import 'package:jubiter_plugin/jubiter_plugin.dart';
import './Model/coin_rates.dart' as $cRates;

enum WalletType {BTC, ETH}
enum FiatType{CNY,USD,JYP}

abstract class JWalletBase extends JWalletContainer with JHttpJubiter{
  //傻逼dart没有protected属性，不定义成public，你让我子类怎么用？？？

  //网络入口                 
  String endPoint;
  //钱包类型，子类设置
  WalletType wType;
  //keyStore类型
  JInterfaceKeyStore keyStore;
  //uuid
  String uuid;
  //main_path
  String _mainPath;
  //临时的contexID，不需要持久化
  int contextID;

  //参数构造函数
  JWalletBase(String name,String mainPath,String _endPoint,JInterfaceKeyStore keyStoreimpl):super(name){
    endPoint = _endPoint;
    keyStore = keyStoreimpl;
    uuid = new Uuid().v4();
    _mainPath = mainPath;
  }

  //Json构造函数
  JWalletBase.fromJson(Map<String, dynamic> json):super.fromJson(json){
    wType = WalletType.values[json["wType"]];
    endPoint = json["endPoint"];
    uuid = json["uuid"];
    _mainPath = json["mainPath"];
    keyStore = JKeyStoreFactory.fromJson(json["keyStore"]);
  }

  @override
  @mustCallSuper
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    json["wType"] = wType.index;
    json["keyStore"] = keyStore;
    json["endPoint"] = endPoint;
    json["uuid"] = uuid;
    json["mainPath"] = _mainPath;
    return  json;
  }

  @override
  @mustCallSuper
  Map<String, dynamic> toJsonKey(){
    Map<String, dynamic> json = super.toJsonKey();
    json["wType"] = wType.index;
    json["keyStore"] = keyStore.toJsonKey();
    json["uuid"] = uuid;

    return json;
  }

  @override
  Future<bool> updateSelf() async{
    await getJWalletManager().updateWallet(this);
    return Future<bool>.value(true);
  }

  String get mainPath {return _mainPath;}

  //第一次创建的时候调用
  Future<bool> init() async{
    return keyStore.init();
  }
  
  //每次使用keyStore的时候调用，base不实现，交给子类，不同的子类实现不一样
  Future<bool> active({String deviceMAC,int deviceID});

  Future<int> showVirtualPWD() async {
    if(keyStore.type() != KeyStoreType.Blade) throw JUBR_IMPL_NOT_SUPPORT;
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