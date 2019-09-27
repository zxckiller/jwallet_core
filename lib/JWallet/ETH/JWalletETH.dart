import '../JWalletBase.dart';
import './interface/JInterfaceETH.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletETH extends JWalletBase with JInterfaceETH{

  JWalletETH(JInterfaceKeyStore keyStoreimpl,WalletType type):super(keyStoreimpl,type);
  String getAddress(){return "0x4087A8Dbd2A8376b57Eecdfc4F3E92339e8E9aE0";}
}