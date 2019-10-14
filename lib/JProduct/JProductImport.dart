import './JProductBase.dart';
import '../jwallet_core.dart';

class JProductImport extends JProductBase{
  JProductImport(String name):super(name){
    pType = ProductType.Import;
  }

  
  //Json构造函数
  JProductImport.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
  }

  @override
  Future<String> newWallet(String endPoint, WalletType wType) async{
    throw JUBR_IMPL_NOT_SUPPORT;
  }

  Future<String> newWalletFromMnmonic(String endPoint, WalletType wType, String mnmoinc, String password)async{
    String key = await getJWalletManager().newWalletFromParm(endPoint, wType, KeyStoreType.LocalDB,mnmonic:mnmoinc,password: password);
    wallets.add(key);
    updateSelf();
    return Future<String>.value(key);
  }


}