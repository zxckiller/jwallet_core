import './interface/JInterfaceKeyStore.dart';
import './JKeyStoreBladeImpl.dart';
import './JKeyStoreDBImpl.dart';

class JKeyStoreFactory{
  static JInterfaceKeyStore fromType(KeyStoreType type){
    JInterfaceKeyStore keystore;
    switch (type) {
      case KeyStoreType.Blade:
        keystore = new JKeyStoreBladeImpl();
        break;
      case KeyStoreType.LocalDB:
        keystore = new JKeyStoreDBImpl();
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