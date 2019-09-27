import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';

class JKeyStoreBladeImpl implements JInterfaceKeyStore{
  KeyStoreType type(){return KeyStoreType.Blade;}
  String connectDevice(){return "Jubiter Blade";}
  String openDB(){throw JUBR_IMPL_NOT_SUPPORT;}
}