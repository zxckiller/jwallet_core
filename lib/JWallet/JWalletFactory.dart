import './BTC/JWalletBTC.dart';
import './ETH/JWalletETH.dart';
import './JWalletBase.dart';
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';

class JWalletFactory{

  //参数列表把软硬的混起来了，这样处理并不合理，需要优化，但还没更好的方法。 此函数不对外，暂时先这样处理。
  static JWalletBase fromParam(String endPoint,WalletType wType,KeyStoreType kType,{String mnmonic,String password,String deviceSN}){
    JWalletBase wallet;
    JInterfaceKeyStore keyStore = JKeyStoreFactory.fromType(kType,mnmonic:mnmonic,password:password,deviceSN:deviceSN);
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
    WalletType wType = WalletType.values[json["wType"]];
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