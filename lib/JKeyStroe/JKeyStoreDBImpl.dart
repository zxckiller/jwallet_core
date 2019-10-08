import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';

class JKeyStoreDBImpl implements JInterfaceKeyStore{
  KeyStoreType _type;

  //默认构造函数
  JKeyStoreDBImpl(){
    _type = KeyStoreType.LocalDB;
  }

  //Json构造函数
  JKeyStoreDBImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["type"]];
  
  Map<String, dynamic> toJson() =>
  {
    'type': _type.index,
  };

  KeyStoreType type(){return _type;}
  String connectDevice(){throw JUBR_IMPL_NOT_SUPPORT;}
  String openDB(){return "DB Store";}




}