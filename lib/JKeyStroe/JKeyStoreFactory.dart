import './interface/JInterfaceKeyStore.dart';
import './JKeyStoreBladeImpl.dart';
import './JKeyStoreDBImpl.dart';
import '../Error.dart';

class JKeyStoreFactory{
  static JInterfaceKeyStore fromType(KeyStoreType type,{String mnmonic,String password,String deviceSN}){
    JInterfaceKeyStore keystore;
    switch (type) {
      case KeyStoreType.Blade:
        if(deviceSN == null) throw JUBR_ARGUMENTS_BAD;
        keystore = new JKeyStoreBladeImpl(deviceSN);
        break;
      case KeyStoreType.LocalDB:
        if(mnmonic == null || password == null) throw JUBR_ARGUMENTS_BAD;
        keystore = new JKeyStoreDBImpl(mnmonic,password);
        break;
      default:
    }

    return keystore;
  }

  static JInterfaceKeyStore fromJson(Map<String, dynamic> json){
    JInterfaceKeyStore keystore;
    KeyStoreType type = KeyStoreType.values[json["keyStore"]["kType"]];
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