import 'package:jwallet_core/JWallet/ETH/JWalletERC20.dart';

import './BTC/JWalletBTC.dart';
import './ETH/JWalletETH.dart';
import './JWalletBase.dart';
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';

class JWalletFactory{

  //Factory参数列表把软硬的混起来了，这样处理并不合理，需要优化，但还没更好的方法。 此函数不对外，暂时先这样处理。
  //dart 没有overload，只能拿命名参数凑合@#￥%……%￥#
  static Future<JWalletBase> fromParam(String name,String mainPath,String endPoint,WalletType wType,KeyStoreType kType,{String mnemonic,String passphase,String password,String deviceMAC}) async{
    JWalletBase wallet;
    JInterfaceKeyStore keyStore;
    switch (wType) {
      case WalletType.BTC:
        keyStore = await JKeyStoreFactory.fromType(kType,mnemonic:mnemonic,passphase:passphase,password:password,cruve:JWalletBTC.curve,deviceMAC:deviceMAC);
        wallet = new JWalletBTC(name,mainPath,endPoint,keyStore);
        break;
      case WalletType.ETH:
        keyStore = await JKeyStoreFactory.fromType(kType,mnemonic:mnemonic,passphase:passphase,password:password,cruve:JWalletETH.curve,deviceMAC:deviceMAC);
        wallet = new JWalletETH(name,mainPath,endPoint,keyStore);
        break;
      default:
    }

    return wallet;
  }

  //fromKeyStore与fromParam应该可以适当优化，整理成一个函数
  static JWalletBase fromKeyStore(String name,String mainPath,String endPoint,WalletType wType,JInterfaceKeyStore keyStore){
    JWalletBase wallet;
    switch (wType) {
      case WalletType.BTC:
        wallet = new JWalletBTC(name,mainPath,endPoint,keyStore);
        break;
      case WalletType.ETH:
        wallet = new JWalletETH(name,mainPath,endPoint,keyStore);
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
        if(json["erc20Info"] == null){
          wallet = new JWalletETH.fromJson(json);
        }else{
          wallet = new JWalletERC20.fromJson(json);
        }
        break;
      default:
    }
    return wallet;
  }

}