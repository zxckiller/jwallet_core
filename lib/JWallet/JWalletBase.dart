//所有钱包的基类实现
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';
enum WalletType { Hardware, Software}
abstract class JWalletBase{
  String name;
  WalletType type;
  JInterfaceKeyStore keyStore;
  JWalletBase(JInterfaceKeyStore keyStoreimpl,WalletType type){keyStore = keyStoreimpl;}
}