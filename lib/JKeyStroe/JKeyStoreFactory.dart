import './interface/JInterfaceKeyStore.dart';
import './JKeyStoreBladeImpl.dart';
import './JKeyStoreDBImpl.dart';
import '../Error.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

class JKeyStoreFactory{
  static JInterfaceKeyStore fromType(KeyStoreType type,{String mnemonic,String passphase,String password,CURVES cruve,String deviceMAC}){
    JInterfaceKeyStore keystore;
    switch (type) {
      case KeyStoreType.Blade:
        if(deviceMAC == null) throw JUBR_ARGUMENTS_BAD;
        keystore = new JKeyStoreBladeImpl(deviceMAC);
        break;
      case KeyStoreType.LocalDB:
        if(mnemonic == null || password == null) throw JUBR_ARGUMENTS_BAD;
        keystore = new JKeyStoreDBImpl(mnemonic,passphase,password,cruve);
        break;
      default:
    }

    return keystore;
  }

  static JInterfaceKeyStore fromJson(Map<String, dynamic> json){
    JInterfaceKeyStore keystore;
    KeyStoreType type = KeyStoreType.values[json["kType"]];
    switch (type) {
      case KeyStoreType.Blade:
        keystore = new JKeyStoreBladeImpl.fromJson(json);
        break;
      case KeyStoreType.LocalDB:
        keystore = new JKeyStoreDBImpl.fromJson(json);
        break;
      default:
    }
    return keystore;
  }
}