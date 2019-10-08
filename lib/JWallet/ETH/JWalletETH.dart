import '../JWalletBase.dart';
import './interface/JInterfaceETH.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletETH extends JWalletBase with JInterfaceETH{

  JWalletETH(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    type = CoinType.ETH;
  }
  
  String getAddress(){return "0x4087A8Dbd2A8376b57Eecdfc4F3E92339e8E9aE0";}

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["eth"] = "1234";
    return json;
  }
}