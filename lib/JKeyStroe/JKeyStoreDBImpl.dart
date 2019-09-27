import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';

class JKeyStoreDBImpl implements JInterfaceKeyStore{
  KeyStoreType type(){return KeyStoreType.LocalDB;}
  String connectDevice(){throw JUBR_IMPL_NOT_SUPPORT;}
  String openDB(){return "DB Store";}
}