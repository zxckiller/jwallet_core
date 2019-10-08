import './BTC/JWalletBTC.dart';
import './ETH/JWalletETH.dart';
import './JWalletBase.dart';
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';

class JWalletFactory{

  static JWalletBase fromParam(String endPoint,WalletType wType,KeyStoreType kType){
    JWalletBase wallet;
    JInterfaceKeyStore keyStore = JKeyStoreFactory.fromType(kType);
    switch (wType) {
      case WalletType.BTC:
        wallet = new JWalletBTC(endPoint,keyStore);
        break;
      case WalletType.ETH:
        wallet = new JWalletETH(endPoint,keyStore);
        break;
      default:
    }

    return wallet;
  }

  static JWalletBase fromJson(Map<String, dynamic> json){
    WalletType wType = WalletType.values[json["type"]];
    JWalletBase wallet;
    switch (wType) {
      case WalletType.BTC:
        wallet = new JWalletBTC.fromJson(json);
        break;
      case WalletType.ETH:
        wallet = new JWalletETH.fromJson(json);
        break;
      default:
    }
    return wallet;
  }

}