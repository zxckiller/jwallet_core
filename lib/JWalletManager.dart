import './JKeyStroe/JKeyStoreDBImpl.dart';
import './JKeyStroe/JKeyStoreBladeImpl.dart';
import './JKeyStroe/interface/JInterfaceKeyStore.dart';
import './JxManager.dart';
import './JWallet/JWalletBase.dart';
import './JWallet/BTC/JWalletBTC.dart';
import './JWallet/ETH/JWalletETH.dart';

enum CoinType { BTC, ETH}

class JWalletManager extends JxManager<JWalletBase>{

  String walletFactory(CoinType coin,KeyStoreType type){
    
    JInterfaceKeyStore keystore;
    if(type == KeyStoreType.Blade){
        keystore = new JKeyStoreBladeImpl();
    }else if(type == KeyStoreType.LocalDB){
        keystore = new JKeyStoreDBImpl();
    }
    JWalletBase wallet;
    switch (coin) {
      case CoinType.BTC:
        wallet = new JWalletBTC(keystore);
        break;
      case CoinType.ETH:
        wallet = new JWalletETH(keystore);
        break;
      default:
    }

    return addOne(wallet);  
  }
}