import '../JWalletBase.dart';
import './interface/JInterfaceBTC.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

import "package:jubiter_plugin/gen/Jub_Bitcoin.pb.dart";
import 'package:jubiter_plugin/jubiter_plugin.dart';
import 'package:jwallet_core/Error.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

import './Model/b_t_c_balance.dart' as $balanceInfo;

import '../../Utils/JUtils.dart';

class JWalletBTC extends JWalletBase with JInterfaceBTC{
  static CURVES curve = CURVES.SECP256K1;
  static String defaultPath = "m/44'/0'/0'";
  static final int decimal = 8;

  final String balanceUrl = "/api/queryBalanceByAccount";

  String _address = "";
  String _xpub = "";
  ENUM_TRAN_STYPE_BTC _transType = ENUM_TRAN_STYPE_BTC.P2PKH;

  JWalletBTC(String name,String mainPath,String endPoint,JInterfaceKeyStore keyStoreimpl):super(name,mainPath??defaultPath,endPoint,keyStoreimpl){
    wType = WalletType.BTC;
    version = "1.0";
  }

  //Json构造函数
  JWalletBTC.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
    _address = json["address"];
    _xpub = json["xpub"];
    _transType = ENUM_TRAN_STYPE_BTC.valueOf(json["transType"]);
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["address"] = _address;
    json["transType"] = _transType.value;
    json["xpub"] = _xpub;
    return json;
  }

  @override
  Future<bool> init({String deviceMAC, int deviceID,ENUM_TRAN_STYPE_BTC transType}) async {
    _transType = firstChange(_transType, transType);
    return super.init(deviceMAC: deviceMAC,deviceID: deviceID);
  }

  @override
  Future<bool> active({String deviceMAC,int deviceID}) async{
    
      switch (keyStore.type()) {
        case KeyStoreType.Blade:
          {
            if (deviceMAC == null || deviceID == null) return Future<bool>.value(false);
            if (deviceMAC != keyStore.getDeviceMAC()) return Future<bool>.value(false);
            ContextCfgBTC config = ContextCfgBTC.create();
            config.mainPath = mainPath;
            config.coinType = ENUM_COIN_TYPE_BTC.COINBTC;
            config.transType = _transType;//交易类型应该上层传参数过来，比如是不是隔离验证
            ResultInt contextResult = await JuBiterBitcoin.createContext(config, deviceID);
            if (contextResult.stateCode == JUBR_OK) {
              contextID = contextResult.value;
            } else {
              return Future<bool>.value(false);
            }
            break;
          }
        case KeyStoreType.LocalDB:
          {
            String xprv = await keyStore.getXprv();
            ContextCfgBTC config = ContextCfgBTC.create();
            config.mainPath = mainPath;
            config.coinType = ENUM_COIN_TYPE_BTC.COINBTC;
            config.transType = _transType;//交易类型应该上层传参数过来，比如是不是隔离验证
            ResultInt contextResult = await JuBiterBitcoin.createContext_Software(config, xprv);
            if (contextResult.stateCode == JUBR_OK) {
              contextID = contextResult.value;
            } else {
              return Future<bool>.value(false);
            }
          }
          break;
        default:
          return Future<bool>.value(false);
        }

    //取 Address
    String address = await _getAddressFromKeystore();
    _address = firstChange(_address, address);

    //取Xpub
    String xpub = await _getXpubFromKeystore();
    _xpub = firstChange(_xpub,xpub);

    return Future<bool>.value(true);
  }

  Future<String> _getXpubFromKeystore() async{
    ResultString xpub = await JuBiterBitcoin.getMainHDNode(contextID);
    if (xpub.stateCode == JUBR_OK) {
        return Future<String>.value(xpub.value);
    } else
        throw xpub.stateCode;
  }

  Future<String> _getAddressFromKeystore() async {
      Bip44Path path = Bip44Path.create();
      path.change = false;
      path.addressIndex = $fixnum.Int64(0);
      ResultString address = await JuBiterBitcoin.getAddress(contextID, path, false);
      if (address.stateCode == JUBR_OK) {
        return Future<String>.value(address.value);
      } else
        throw address.stateCode;
  }

  String getAddress(){return _address;}
  String getXpub(){return _xpub;}

  @override
  String getLocalBalance() {
    return balance;
  }

  @override
  Future<String> getCloudBalance() async {
    String url = endPoint + balanceUrl;
    Map<String, String> params = new Map<String, String>();
    params["account"] = _xpub;
    var response = await httpPost(url, params);
    var balanceInfo = $balanceInfo.BTCBalance.fromJson(response);
    balance = balanceInfo.data.toString();
    return Future<String>.value(balance);
  }
  

  @override
  Future<String> broadcastRaw(String raw, {String userId}) {
    // TODO: implement broadcastRaw
    return null;
  }
}