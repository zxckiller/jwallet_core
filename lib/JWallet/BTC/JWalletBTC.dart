import '../JWalletBase.dart';
import './interface/JInterfaceBTC.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{

  JWalletBTC(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl);
  String getAddress(){return "392V6RoNm9Mu3TvQfuAb458iRTCMokht9U";}

}