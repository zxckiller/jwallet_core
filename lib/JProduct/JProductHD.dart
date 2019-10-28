import './JProductBase.dart';
import '../jwallet_core.dart';

class JProductHD extends JProductBase{
  String _mnmonic;
  String _password;
  String _passphase;
  JProductHD(String mnmonic,String passphase,String password,String name):super(name){
    pType = ProductType.HD;
    _mnmonic = mnmonic;
    _password = password;
    _passphase = passphase;
  }

  
  //Json构造函数
  JProductHD.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
    _mnmonic = json["mnmonic"];
    _password = json["password"];
    _passphase = json["passphase"];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["mnmonic"] = _mnmonic;
    json["password"] = _password;
    json["passphase"] = _passphase;
    return json;
  }

  @override
  Future<String> newWallet(String endPoint, WalletType wType) async{
    String key = await getJWalletManager().newWalletFromParm(endPoint, wType, KeyStoreType.LocalDB,mnmonic:_mnmonic,passphase:_passphase, password: _password);
    wallets.add(key);
    await updateSelf();
    return Future<String>.value(key);
  }
}