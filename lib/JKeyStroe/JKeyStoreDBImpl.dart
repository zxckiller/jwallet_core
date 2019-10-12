import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';

class JKeyStoreDBImpl implements JInterfaceKeyStore{
  KeyStoreType _type;
  String _mnmonic;
  String _password;

  //默认构造函数
  JKeyStoreDBImpl(String mnmonic,String password){
    _type = KeyStoreType.LocalDB;
  }

  //Json构造函数
  JKeyStoreDBImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["keyStore"]["kType"]],
  _mnmonic = json["mnmonic"],
  _password = json["password"];
  
  Map<String, dynamic> toJson() =>
  {
    'kType': _type.index,
    'mnmonic' : _mnmonic,
    'password' : _password,
  };
  
  Map<String, dynamic> toJsonKey() =>
  {
    'kType': _type.index,
  };


  KeyStoreType type(){return _type;}
  String connectDevice(){throw JUBR_IMPL_NOT_SUPPORT;}
  String openDB(){return "DB Store";}




}