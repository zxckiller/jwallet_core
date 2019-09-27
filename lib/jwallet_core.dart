library jwallet_core;
import 'package:get_it/get_it.dart';
import './JWalletManager.dart';
import './JProductManager.dart';

import './JWallet/JWalletBase.dart';
import './JWallet/BTC/interface/JInterfaceBTC.dart';
import './JWallet/ETH/interface/JInterfaceETH.dart';

import './JProduct/JProductHD.dart';
import './JProduct/JProductBlade.dart';
import './JProduct/JProductImport.dart';

export './JWalletManager.dart';
export './JWallet/JWalletBase.dart';
export './JKeyStroe/interface/JInterfaceKeyStore.dart';

final getIt = GetIt.instance;
const productDefault = "prodctDefault";
const productBlade   = "productBlade";
const productImport  = "productImport";
//init函数要读数据库，可能时间会长，应该是一个异步函数
void init(){
  getIt.registerSingleton<JWalletManager>(JWalletManager());
  getIt.registerSingleton<JProductManager>(JProductManager());
  //初始化的需要创建三个默认的产品
  getJProductManager().insertOne(productDefault, new JProductHD());
  getJProductManager().insertOne(productBlade, new JProductBlade());
  getJProductManager().insertOne(productImport, new JProductImport());
}

//获取两个Manager
JWalletManager getJWalletManager() => getIt<JWalletManager>();
JProductManager getJProductManager() => getIt<JProductManager>();

//方便上层直接获取Wallet的接口
JWalletBase    getJWallet(String key)     => getJWalletManager().getOne(key);
JInterfaceBTC  getJWalletBTC(String key)  => getJWalletManager().getOne(key) as JInterfaceBTC;
JInterfaceETH  getJWalletETH(String key)  => getJWalletManager().getOne(key) as JInterfaceETH;

//方便上层直接获取Product的接口
JProductHD getJProductDefault()    => getJProductManager().getOne(productDefault) as JProductHD;
JProductBlade getJProductBlade()   => getJProductManager().getOne(productBlade) as JProductBlade;
JProductImport getJProductImport() => getJProductManager().getOne(productImport) as JProductImport;

