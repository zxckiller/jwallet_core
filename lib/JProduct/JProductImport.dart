import './JProductBase.dart';
import '../jwallet_core.dart';

class JProductImport extends JProductBase {
  JProductImport(String name) : super(name) {
    pType = ProductType.Import;
  }

  //Json构造函数
  JProductImport.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    //构造子类特有数据
  }

  @override
  Future<String> newWallet(String mainPath, String endPoint, WalletType wType) async {
    throw JUBR_IMPL_NOT_SUPPORT;
  }

  Future<String> newWalletFromMnemonic(String name, String mainPath, String endPoint,
      WalletType wType, String mnemonic, String passphrase, String password) async {
    String key = await getJWalletManager().newWalletFromParm(
        name, mainPath, endPoint, wType, KeyStoreType.LocalDB,
        mnemonic: mnemonic, passphase: passphrase, password: password);
    await addWallet(key);
    return Future<String>.value(key);
  }
}
