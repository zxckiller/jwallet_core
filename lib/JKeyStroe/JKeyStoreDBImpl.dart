import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';
import 'package:jubiter_plugin/jubiter_plugin.dart';

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
  updateSelf(){}


  KeyStoreType type(){return _type;}
  String connectDevice(){throw JUBR_IMPL_NOT_SUPPORT;}
  String openDB(){return "DB Store";}  




  static Future<ResultString> generateMnemonic(ENUM_MNEMONIC_STRENGTH strenth) async{
    ResultString mnemonicResult = await JuBiterWallet.generateMnemonic(strenth);
    return Future<ResultString>.value(mnemonicResult);
  }

  static checkMnmonic(String mnemonic){
    return JuBiterWallet.checkMnemonic(mnemonic);
  }

}