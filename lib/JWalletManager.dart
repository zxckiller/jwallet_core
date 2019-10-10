import './JKeyStroe/interface/JInterfaceKeyStore.dart';
import './JxManager.dart';
import './JWallet/JWalletBase.dart';
import './JWallet/JWalletFactory.dart';
import 'dart:convert';


class JWalletManager with JPresistManager{

  Future<String> newWalletFromParm(String endPoint,WalletType wType,KeyStoreType kType) async{  
    JWalletBase wallet = JWalletFactory.fromParam(endPoint, wType, kType);
    return addOne(json.encode(wallet.toJsonKey()),wallet.toJson());  
  }

  Future<JWalletBase> getWallet(String key) async{
    var jsonObj = await getOne(key);
    JWalletBase wallet = JWalletFactory.fromJson(jsonObj);
    return Future<JWalletBase>.value(wallet); 
  }

  Future<Set<String>> enumWalletsByWalletType([WalletType wType]) async{
    Set<String> allWallts = await enumAll();
    Set<String> tagetWallets = new Set<String>();
    allWallts.forEach((key){
      try {
          Map<String,dynamic> _j = json.decode(key);
          if(_j["wType"] == wType.index)
          tagetWallets.add(key);
      } catch (e) {}
    });

    return Future<Set<String>>.value(tagetWallets);
  }

  Future<Set<String>> enumWalletsByKeyStoreType([KeyStoreType kType]) async{
    Set<String> allWallts = await enumAll();
    Set<String> tagetWallets = new Set<String>();
    allWallts.forEach((key){
      try {
          Map<String,dynamic> _j = json.decode(key);
          if(_j["keyStore"]["kType"] == kType.index)
          tagetWallets.add(key);
      } catch (e) {}
    });

    return Future<Set<String>>.value(tagetWallets);
  }

  // Future<String> newWalletFromJson(Map<String, dynamic> jsonObj) async{
  //   JWalletBase wallet = JWalletFactory.fromJson(jsonObj);
  //   return addOne(wallet.toJson(),json.encode(wallet.toJsonKey())); 
  // }

}