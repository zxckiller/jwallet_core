//所有钱包的基类实现
import '../JKeyStroe/interface/JInterfaceKeyStore.dart';

abstract class JWalletBase{
  String name;
  String _endPoint;
  JInterfaceKeyStore keyStore;
  JWalletBase(String endPoint,JInterfaceKeyStore keyStoreimpl){
    _endPoint = endPoint;
    keyStore = keyStoreimpl;
    }


  
}