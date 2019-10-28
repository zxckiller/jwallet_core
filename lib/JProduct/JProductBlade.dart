import './JProductBase.dart';
import '../jwallet_core.dart';

class JProductBlade extends JProductBase{
  String _uuid;
  JProductBlade(String uuid,String name):super(name){
    pType = ProductType.JubiterBlade;
    _uuid = uuid;
  }


  //Json构造函数
  JProductBlade.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
    _uuid = json["uuid"];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["uuid"] = _uuid;
    return json;
  }

  @override
  Future<String> newWallet(String endPoint, WalletType wType) async{
    String key = await getJWalletManager().newWalletFromParm(endPoint, wType, KeyStoreType.Blade,uuid:_uuid);
    wallets.add(key);
    await updateSelf();
    return Future<String>.value(key);
  }
}