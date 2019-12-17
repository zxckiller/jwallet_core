import './JProductBase.dart';
import '../jwallet_core.dart';
import '../JKeyStroe/JKeyStoreFactory.dart';
import '../JKeyStroe/JKeyStoreDBImpl.dart';

class JProductHD extends JProductBase{
  JKeyStoreDBImpl _keyStore;
  JProductHD(String mnemonic,String passphase,String password,String name):super(name){
    pType = ProductType.HD;
    _keyStore = new JKeyStoreDBImpl(mnemonic,passphase,password,CURVES.secp256k1);
  }

  //Json构造函数
  JProductHD.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
    _keyStore = JKeyStoreFactory.fromJson(json["keyStore"]);
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["keyStore"] = _keyStore.toJson();
    return json;
  }

  @override
  Future<String> newWallet(String mainPath,String endPoint, WalletType wType) async{
    String key = await getJWalletManager().newWalletFromKeyStore(name,mainPath,endPoint, wType, _keyStore);
    await addWallet(key);
    return Future<String>.value(key);
  }

  String getMnemonic(String password){return _keyStore.getMnemonic(password);}
}