import './JKeyStroe/interface/JInterfaceKeyStore.dart';
import './JxManager.dart';
import './JWallet/JWalletBase.dart';
import './JWallet/JWalletFactory.dart';




class JWalletManager extends JxManager<JWalletBase>{

  String newWalletFromParm(String endPoint,WalletType wType,KeyStoreType kType){  
    JWalletBase wallet = JWalletFactory.fromParam(endPoint, wType, kType);
    return addOne(wallet);  
  }

  String newWalletFromJson(Map<String, dynamic> json){
    JWalletBase wallet = JWalletFactory.fromJson(json);
    return addOne(wallet);  
  }

}