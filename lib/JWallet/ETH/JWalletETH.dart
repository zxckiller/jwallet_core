import '../JWalletBase.dart';
import './interface/JInterfaceETH.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletETH extends JWalletBase with JInterfaceETH{

  JWalletETH(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    wType = WalletType.ETH;
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


  String getAddress(){return "0x4087A8Dbd2A8376b57Eecdfc4F3E92339e8E9aE0";}
}