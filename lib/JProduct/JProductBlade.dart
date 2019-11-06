import './JProductBase.dart';
import '../jwallet_core.dart';

class JProductBlade extends JProductBase{
  String _deviceMAC;
  JProductBlade(String deviceMAC,String name):super(name){
    pType = ProductType.JubiterBlade;
    _deviceMAC = deviceMAC;
  }
  
  String get deviceMAC{
    return _deviceMAC;
  }

  //Json构造函数
  JProductBlade.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
    _deviceMAC = json["deviceMAC"];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["deviceMAC"] = _deviceMAC;
    return json;
  }

  @override
  Future<String> newWallet(String mainPath,String endPoint, WalletType wType) async{
    String key = await getJWalletManager().newWalletFromParm(name,mainPath,endPoint, wType, KeyStoreType.Blade,deviceMAC:_deviceMAC);
    await addWallet(key);
    return Future<String>.value(key);
  }
}