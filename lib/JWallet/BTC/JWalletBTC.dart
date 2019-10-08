import '../JWalletBase.dart';
import './interface/JInterfaceBTC.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{

  JWalletBTC(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    wType = WalletType.BTC;
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

  String getAddress(){return "392V6RoNm9Mu3TvQfuAb458iRTCMokht9U";}
}