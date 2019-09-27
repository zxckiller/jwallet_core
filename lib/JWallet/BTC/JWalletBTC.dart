import '../JWalletBase.dart';
import './interface/JInterfaceBTC.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{

  JWalletBTC(JInterfaceKeyStore keyStoreimpl,WalletType type):super(keyStoreimpl,type){}
  String getAddress(){return "392V6RoNm9Mu3TvQfuAb458iRTCMokht9U";}

}