import 'package:flutter/material.dart';

import '../jwallet_core.dart';
import '../JWallet/JWalletBase.dart';
import '../JWalletContainer.dart';

enum ProductType {HD, JubiterBlade,Import}
abstract class JProductBase extends JWalletContainer{

  ProductType pType;
  JProductBase(String _name):super(_name);

  //Json构造函数
  JProductBase.fromJson(Map<String, dynamic> _json):super.fromJson(_json){
    pType = ProductType.values[_json["pType"]];
  }

  @override
  @mustCallSuper
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["pType"] =  pType.index;
    return json;
  }

  @override
  @mustCallSuper
  Map<String, dynamic> toJsonKey() 
  {
    Map<String, dynamic> json = super.toJsonKey();
    //增加子类的json化数据，地址、历史等等
    json["pType"] =  pType.index;
    return json;
  }
  
  @override
  Future<bool> updateSelf() async{
    await getJProductManager().updateOne(name, this.toJson());
    return Future<bool>.value(true);
  }

  @override
  Future<bool> removeWallet(String wallet) async{
    bool bSuccess = await super.removeWallet(wallet);
    if(!bSuccess){return false;}
    // 若钱包为空，删除容器
    if (enumWallets().isEmpty) {
      // 删除容器
      bool result = await getJProductManager().deleteProduct(name);
      print('remove wallet: $result');
      return result;
    }
    return true;
  }

  //创建钱包，base不实现，交给子类
  Future<String> newWallet(String mainPath,String endPoint, WalletType wType);

  Future<List<WalletType>> supportedWalletTypes() async{
    List<WalletType> list = [WalletType.BTC,WalletType.ETH];
    return Future<List<WalletType>>.value(list);
  }
}