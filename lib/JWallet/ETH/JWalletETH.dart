import '../JWalletBase.dart';
import './interface/JInterfaceETH.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

import 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbjson.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

class JWalletETH extends JWalletBase with JInterfaceETH{
   static CURVES curve = CURVES.secp256k1;
   static String defaultPath = "m/44'/60'/0'";

  JWalletETH(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    wType = WalletType.ETH;
    mainPath = defaultPath;
  }

   //Json构造函数
  JWalletETH.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
  }
  
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["eth"] = "1234";
    return json;
  }


  String getAddress(Bip32Path path){return "0x4087A8Dbd2A8376b57Eecdfc4F3E92339e8E9aE0";}
}