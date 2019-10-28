import './JKeyStroe/interface/JInterfaceKeyStore.dart';
import './JxManager.dart';
import './JWallet/JWalletBase.dart';
import './JWallet/JWalletFactory.dart';
import 'dart:convert';
import './Error.dart';


class JWalletManager with JPresistManager{

  //创建一个新钱包
  Future<String> newWalletFromParm(String endPoint,WalletType wType,KeyStoreType kType,{String mnmonic,String passphase,String password,String uuid}) async{  
    JWalletBase wallet = JWalletFactory.fromParam(endPoint, wType, kType,mnmonic:mnmonic,passphase:passphase,password:password,uuid:uuid);
    return addOne(json.encode(wallet.toJsonKey()),wallet.toJson());  
  }

  //获取某一个钱包
  Future<T> getWallet<T>(String key) async{
    var jsonObj = await getOne(key);
    JWalletBase p = JWalletFactory.fromJson(jsonObj);
    return Future<T>.value(p as T); 
  }

  //通过钱包类型枚举钱包
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

  //通过keystore类型枚举钱包
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