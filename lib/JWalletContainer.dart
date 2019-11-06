import 'package:flutter/material.dart';
import './jwallet_core.dart';
import './JsonableObject.dart';
//JWalletContainer类并不会真正添加删除Manager存储的钱包，只是一个映射,具体是否修改由子类决定。
//需要修改的场景，被Product继承
//不需要修改的场景，被币种分类容器继承
abstract class JWalletContainer extends JsonableObject{

  String name;
  List<String> _wallets = new List<String>();

  JWalletContainer(String containerName){
    name = containerName;
  }

  JWalletContainer.fromJson(Map<String, dynamic> json):
  name =json["name"]
  {
    (json["wallets"] as List<dynamic>).forEach(
      (f) => _wallets.add(f as String)
    );
  }

  @override
  @mustCallSuper
  Map<String, dynamic> toJson() => {
    "wallets" : _wallets,
    "name":name
  };
  @override
  @mustCallSuper
  Map<String, dynamic> toJsonKey() =>{
    'name': name
  };

  @override
  Future<bool> updateSelf() {
    return null;
  }

  @protected
  List<String> enumWallets(){return _wallets;}

  @protected
  Future<bool> addWallet(String wallet) async{
    if(_wallets.indexOf(wallet) != -1) throw JUBR_ALREADY_EXITS; //查重
    if(await getJWalletManager().containsKey(wallet)){
      _wallets.add(wallet);
      return updateSelf();
    }
    else throw JUBR_NO_ITEM; //数据库里面没有这个钱包，没办法映射
  }

  @protected
  Future<bool> removeWallet(String wallet) async{
    _wallets.remove(wallet);
    return updateSelf();
  }

  @protected
  Future<T> getWallet<T>(String key) async{
    if (!_wallets.contains(key)) throw JUBR_NO_ITEM;
    return getJWalletManager().getWallet<T>(key);
  }
    
}