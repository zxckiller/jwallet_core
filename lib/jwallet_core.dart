library jwallet_core;
import 'package:get_it/get_it.dart';
import './JWalletManager.dart';
import './JProductManager.dart';


import './JProduct/JProductHD.dart';
import './JProduct/JProductBlade.dart';
import './JProduct/JProductImport.dart';

export './JWalletManager.dart';
export './JWallet/JWalletBase.dart';
export './JKeyStroe/interface/JInterfaceKeyStore.dart';
export './Error.dart';
export './JWallet/BTC/JWalletBTC.dart';
export './JWallet/ETH/JWalletETH.dart';
export './JProduct/JProductBlade.dart';
export './JProduct/JProductHD.dart';
export './JProduct/JProductImport.dart';

final getIt = GetIt.instance;

//init函数要读数据库，可能时间会长，应该是一个异步函数
void init() async{
  getIt.registerSingleton<JWalletManager>(JWalletManager());
  getIt.registerSingleton<JProductManager>(JProductManager());
}

//获取两个Manager，上层现阶段只用getJProductManager
JWalletManager getJWalletManager() => getIt<JWalletManager>();
JProductManager getJProductManager() => getIt<JProductManager>();


//方便上层直接获取Product的接口
Future<JProductHD> getJProductDefault() async{
  return getJProductManager().getProduct<JProductHD>(productDefault);
}

Future<JProductBlade> getJProductBlade() async{

  return getJProductManager().getProduct<JProductBlade>(productBlade);
}

Future<JProductImport> getJProductImport() async{
    return getJProductManager().getProduct<JProductImport>(productImport);
}

//一些上层需要直接使用的全局函数

