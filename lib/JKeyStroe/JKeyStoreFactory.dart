import './interface/JInterfaceKeyStore.dart';
import './JKeyStoreBladeImpl.dart';
import './JKeyStoreDBImpl.dart';
import '../Error.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

class JKeyStoreFactory{
  static JInterfaceKeyStore fromType(KeyStoreType type,{String mnmonic,String passphase,String password,CURVES cruve,String uuid}){
    JInterfaceKeyStore keystore;
    switch (type) {
      case KeyStoreType.Blade:
        if(uuid == null) throw JUBR_ARGUMENTS_BAD;
        keystore = new JKeyStoreBladeImpl(uuid);
        break;
      case KeyStoreType.LocalDB:
        if(mnmonic == null || password == null) throw JUBR_ARGUMENTS_BAD;
        keystore = new JKeyStoreDBImpl(mnmonic,passphase,password,cruve);
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