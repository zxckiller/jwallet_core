import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';
import 'package:jubiter_plugin/jubiter_plugin.dart';

class JKeyStoreDBImpl implements JInterfaceKeyStore{
  KeyStoreType _type;
  String _mnemonic;
  String _password;
  String _passphase;
  String xprv;
  CURVES _curve;

  //默认构造函数
  JKeyStoreDBImpl(String mnemonic,String passphase,String password,CURVES curve){
    _type = KeyStoreType.LocalDB;
    _mnemonic = mnemonic;
    _passphase = passphase;
    _password = password;
    _curve = curve;
  }

  //Json构造函数
  JKeyStoreDBImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["kType"]],
  _mnemonic = json["mnemonic"],
  _password = json["password"],
  _passphase = json["passphase"],
  xprv = json["xprv"],
  _curve = CURVES.valueOf(json["curve"]);


  Map<String, dynamic> toJson() =>
  {
    'kType': _type.index,
    'mnemonic' : _mnemonic,
    'password' : _password,
    'passphase' : _passphase,
    'xprv' : xprv,
    "curve" : _curve.value
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'kType': _type.index,
  };
  Future<bool> updateSelf(){return Future<bool>.value(true);}


  KeyStoreType type(){return _type;}
  String getDeviceMAC(){throw JUBR_IMPL_NOT_SUPPORT;}


  Future<bool> init() async{
    var seed = await JuBiterWallet.generateSeed(_mnemonic, _passphase);
    if(seed.stateCode != JUBR_OK) throw seed.stateCode;
    var _xprv = await JuBiterWallet.seedToMasterPrivateKey(seed.value, _curve);
    if(_xprv.stateCode != JUBR_OK) throw _xprv.stateCode;
    xprv = _xprv.value;
    return Future<bool>.value(true);
  }

  String getXprv(){return xprv;}
  String getMnemonic(String password){
    if(password == _password)return _mnemonic;
    else throw JUBR_WRONG_PASSWORD;
  }

  //后期xprv应该是被pin加密起来的，验pin通过需要解密xprv
  Future<bool> verifyPin(int contextID,String password){
    return Future<bool>.value(password == _password);
  }

  Future<bool> modifyPin(int contextID, String oldPassword, String newPassword) {
    _password = newPassword;
    return Future<bool>.value(true);
  }

  static Future<ResultString> generateMnemonic(ENUM_MNEMONIC_STRENGTH strenth) async {
    ResultString mnemonicResult = await JuBiterWallet.generateMnemonic(strenth);
    return Future<ResultString>.value(mnemonicResult);
  }

  static Future<int> checkMnemonic(String mnemonic){
    return JuBiterWallet.checkMnemonic(mnemonic);
  }

}