//所有钱包的基类实现
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';

abstract class JWalletBase{
  String name;
  JInterfaceKeyStore keyStore;
  JWalletBase(JInterfaceKeyStore keyStoreimpl){keyStore = keyStoreimpl;}
}