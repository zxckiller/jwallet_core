import './JProductBase.dart';
import '../jwallet_core.dart';

class JProductBlade extends JProductBase{
  String _deviceSN;
  JProductBlade(String deviceSN,String name):super(name){
    pType = ProductType.JubiterBlade;
    _deviceSN = deviceSN;
  }


  //Json构造函数
  JProductBlade.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
    _deviceSN = json["deviceSN"];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["deviceSN"] = _deviceSN;
    return json;
  }

  @override
  Future<String> newWallet(String endPoint, WalletType wType) async{
    String key = await getJWalletManager().newWalletFromParm(endPoint, wType, KeyStoreType.Blade,deviceSN:_deviceSN);
    wallets.add(key);
    return Future<String>.value(key);
  }
}