import 'package:jwallet_core/Error.dart';

import '../JWalletBase.dart';
import './interface/JInterfaceETH.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

import 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbjson.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

import 'package:jubiter_plugin/jubiter_plugin.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class JWalletETH extends JWalletBase with JInterfaceETH{
   static final CURVES curve = CURVES.secp256k1;
   static final String defaultPath = "m/44'/60'/0'";
   static final int chainID = 0;

   String _address;

  JWalletETH(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    wType = WalletType.ETH;
    mainPath = defaultPath;
  }

   //Json构造函数
  JWalletETH.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
  }
  
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["eth"] = "1234";
    return json;
  }
  Future<bool> active({String deviceSN,int deviceID}) async{
    switch (keyStore.type()) {
      case KeyStoreType.Blade:
        return Future<bool>.value(true);
      case KeyStoreType.LocalDB:
      {
        String xprv = keyStore.getXprv();
        ContextCfgETH config = ContextCfgETH.create();
        config.chainID = chainID;
        config.mainPath = mainPath;
        ResultInt contextResult = await JuBiterEthereum.createContext_Software(config,xprv);
        if(contextResult.stateCode == JUBR_OK){
          contextID = contextResult.value;
          Bip32Path path = Bip32Path.create();
          path.change = false;
          path.addressIndex = $fixnum.Int64(0);
          ResultString address = await JuBiterEthereum.getAddress(contextID, path, false);
          if(address.stateCode == JUBR_OK){
            _address = address.value;
          }else return Future<bool>.value(false);
          return Future<bool>.value(true);
        }else{
          return Future<bool>.value(false);
        }
      }
      break;
      
      default:
        return Future<bool>.value(false);
    }
  }


  Future<String> getAddress() async{
    return Future<String>.value(_address);
  }

  Future<ResultString> signTX(TransactionETH txInfo) async{
    return await JuBiterEthereum.signTransaction(contextID, txInfo);
  }
  Future<ResultString> getMainHDNode(ENUM_PUB_FORMAT format)async{
    return await JuBiterEthereum.getMainHDNode(contextID, format);
  }

  Future<ResultString> getHDNode(ENUM_PUB_FORMAT format) async{
    Bip32Path path = Bip32Path.create();
    path.change = false;
    path.addressIndex = $fixnum.Int64(0);
    return await JuBiterEthereum.getHDNode(contextID, format, path);
  } 
}