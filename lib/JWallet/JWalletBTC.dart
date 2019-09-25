import './JWalletBase.dart';
import './interface/JInterfaceBTC.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{
  JWalletBTC(){name = "BTC";}

  String getAddress(){return "392V6RoNm9Mu3TvQfuAb458iRTCMokht9U";}
}