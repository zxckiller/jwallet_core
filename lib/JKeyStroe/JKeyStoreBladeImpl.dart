import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';

class JKeyStoreBladeImpl implements JInterfaceKeyStore{
  KeyStoreType _type;

  //默认构造函数
  JKeyStoreBladeImpl(){
      _type = KeyStoreType.Blade;
  }

  //Json构造函数
  JKeyStoreBladeImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["type"]];

  Map<String, dynamic> toJson() =>
  {
    'type': _type.index,
  };


  //通用函数
  KeyStoreType type(){return _type;}
  String connectDevice(){return "Jubiter Blade";}
  String openDB(){throw JUBR_IMPL_NOT_SUPPORT;}


}