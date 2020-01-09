import '../JWalletBase.dart';
import './interface/JInterfaceBTC.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{
  static CURVES curve = CURVES.secp256k1;
  static String defaultPath = "m/44'/0'/0'";

  JWalletBTC(String name,String mainPath,String endPoint,JInterfaceKeyStore keyStoreimpl):super(name,mainPath??defaultPath,endPoint,keyStoreimpl){
    wType = WalletType.BTC;
    version = "1.0";
  }

  //Json构造函数
  JWalletBTC.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["btc"] = "1234";
    return json;
  }

  @override
  Future<bool> active({String deviceMAC,int deviceID}){return Future<bool>.value(true);}

  String getAddress(){return "392V6RoNm9Mu3TvQfuAb458iRTCMokht9U";}
}