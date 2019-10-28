import '../JsonableObject.dart';
import '../jwallet_core.dart';
import '../JWallet/JWalletBase.dart';

enum ProductType {HD, JubiterBlade,Import}
abstract class JProductBase extends JsonableObject{
  String name;
  ProductType pType;
  List<String> wallets = new List<String>();

  JProductBase(String _name){
    name = _name;
  }

  //Json构造函数
  JProductBase.fromJson(Map<String, dynamic> _json):
    pType = ProductType.values[_json["pType"]],
    name = _json["name"]
    {
      (_json["wallets"] as List<dynamic>).forEach(
        (f) => wallets.add(f as String)
      );
    }
    

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'pType': pType.index,
    'wallets': wallets
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'name': name,
    'pType':pType.index
  };

  Future<bool> updateSelf() async{
    await getJProductManager().updateOne(name, this.toJson());
    return Future<bool>.value(true);
  }

  //Wallet操作函数
  Future<String> newWallet(String endPoint, WalletType wType);

  Future<T> getWallet<T>(String key){
    if (!wallets.contains(key)) throw JUBR_NO_ITEM;
    return getJWalletManager().getWallet<T>(key);
  }

  List<String> enumWallets(){return wallets;}

  Future<List<WalletType>> supportedWalletTypes() async{
    List<WalletType> list = [WalletType.BTC,WalletType.ETH];
    return Future<List<WalletType>>.value(list);
  }
}