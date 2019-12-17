library jwallet_core;
import 'package:get_it/get_it.dart';
import 'package:jwallet_core/JKeyStroe/JKeyStoreBladeImpl.dart';
import 'package:jwallet_core/JKeyStroe/JKeyStoreDBImpl.dart';
import './JWalletManager.dart';
import './JProductManager.dart';


import './JProduct/JProductHD.dart';
import './JProduct/JProductBlade.dart';
import './JProduct/JProductImport.dart';

import 'package:jubiter_plugin/gen/jubiterblue.pbserver.dart';
import 'package:jubiter_plugin/jubiter_plugin.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

export './JWalletManager.dart';
export './JWallet/JWalletBase.dart';
export './JKeyStroe/interface/JInterfaceKeyStore.dart';
export './Error.dart';
export './JWallet/BTC/JWalletBTC.dart';
export './JProduct/JProductBlade.dart';
export './JProduct/JProductHD.dart';
export './JProduct/JProductImport.dart';
export './JProduct/JProductBase.dart';


export './JWallet/ETH/JWalletETH.dart';
export './JWallet/ETH/Model/e_r_c20_token_info.dart';

export 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
export 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
export 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

export 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
export 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
export 'package:jubiter_plugin/gen/Jub_Ethereum.pbjson.dart';
export 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

export 'package:jubiter_plugin/gen/jubiterblue.pb.dart';
export 'package:jubiter_plugin/gen/jubiterblue.pbserver.dart';
export 'package:jubiter_plugin/gen/jubiterblue.pbenum.dart';

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

Future<ResultString> generateMnemonic(ENUM_MNEMONIC_STRENGTH strenth) async{
  return JKeyStoreDBImpl.generateMnemonic(strenth);
}

Future<int>  checkMnemonic(String mnemonic) async{
  return JKeyStoreDBImpl.checkMnemonic(mnemonic);
}

Future<int> initDevice() async{
  return JKeyStoreBladeImpl.initDevice();
}

Stream<ScanResult> startScan(Duration timeout) async*{
  yield* JKeyStoreBladeImpl.startScan(timeout);
}

Future<int> stopScan() async {
  return JKeyStoreBladeImpl.stopScan();
}

Future<int> connect(
  BluetoothDevice device,
  Duration timeout,
  void onConnectStateChange(DeviceStateResponse state),
  void onError(Object error)) async {
  return JKeyStoreBladeImpl.connect(device, timeout, onConnectStateChange, onError);
}

Future<int> cancelConnect(String macAddress) async {
  return JKeyStoreBladeImpl.cancelConnect(macAddress);
}

Future<int> disconnectDevice(int deviceID) async {
  return JKeyStoreBladeImpl.disconnectDevice(deviceID);
}

Future<bool> isConnected(int deviceID) async {
  return JKeyStoreBladeImpl.isConnected(deviceID);
}

Future<DeviceInfo> getDeviceInfo(int deviceID) async {
  return JKeyStoreBladeImpl.getDeviceInfo(deviceID);
}

