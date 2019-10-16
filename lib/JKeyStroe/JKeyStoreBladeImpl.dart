import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';

class JKeyStoreBladeImpl implements JInterfaceKeyStore{
  KeyStoreType _type;
  String _deviceSN;

  //默认构造函数
  JKeyStoreBladeImpl(String deviceSN){
      _type = KeyStoreType.Blade;
      _deviceSN = deviceSN;
  }

  //Json构造函数
  JKeyStoreBladeImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["kType"]],
  _deviceSN = json["deviceSN"];

  Map<String, dynamic> toJson() =>
  {
    'kType': _type.index,
    'deviceSN': _deviceSN
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'kType': _type.index,
  };

  updateSelf(){}

  //通用函数
  KeyStoreType type(){return _type;}
  Future<bool> init() async{return Future<bool>.value(true);}
  String getXprv(){throw JUBR_IMPL_NOT_SUPPORT;}
  Future<bool> verifyPin(String password){return Future<bool>.value(true);}
}