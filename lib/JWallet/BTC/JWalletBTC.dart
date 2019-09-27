import '../JWalletBase.dart';
import './interface/JInterfaceBTC.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{

  JWalletBTC(JInterfaceKeyStore keyStoreimpl):super(keyStoreimpl){}
  String getAddress(){return "392V6RoNm9Mu3TvQfuAb458iRTCMokht9U";}

}