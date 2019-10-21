import 'package:tuple/tuple.dart';

import 'package:jwallet_core/Error.dart';
import '../JWalletBase.dart';
import './interface/JInterfaceETH.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

import 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

import 'package:jubiter_plugin/jubiter_plugin.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

import './Model/account_info.dart';
import './Model/e_r_c20_token_info.dart' as $erc20;

class JWalletETH extends JWalletBase with JInterfaceETH{
   static final CURVES curve = CURVES.secp256k1;
   static final String defaultPath = "m/44'/60'/0'";
   static final int chainID = 0;

   List<$erc20.Data> _addedERC20Tokens = new List<$erc20.Data>();
   final String accountInfoUrl = "/api/v2/queryAccountInfoByAddr";
   final String erc20Info = "/api/v2/queryTokensByNameOrAddr";

   String _address;

  JWalletETH(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    wType = WalletType.ETH;
    mainPath = defaultPath;
  }

   //Json构造函数
  JWalletETH.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
    //构造子类特有数据
      (json["addedERC20Tokens"] as List<dynamic>).forEach(
        (f) => _addedERC20Tokens.add($erc20.Data.fromJson(f))
      );
  }
  
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["addedERC20Tokens"] = _addedERC20Tokens;
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
            //_address = address.value;
            _address ="0xc874c758c0bf07f003cff4ddf1d964560138ba79";//for_test
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

  Future<ResultString> signTX(String password,TransactionETH txInfo) async{
    if(! await keyStore.verifyPin(password)) throw JUBR_WRONG_PASSWORD;
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

  //通用的获取AccountInfo的方法
  Future<AccountInfo> _getAccountInfo(String address,{String erc20address}) async{
    String url = endPoint + accountInfoUrl;
    Map<String,String> params = new Map<String,String>();
    params["address"] = _address;
    params["contractAddress"] = erc20address;
    var response = await httpPost(url,params);
    var accountInfo = AccountInfo.fromJson(response);
    return Future<AccountInfo>.value(accountInfo);
  }

  Future<String> getBalance({$erc20.Data erc20TokenInfo}) async{
    if(erc20TokenInfo != null){
      var accountInfo = await _getAccountInfo(_address,erc20address: erc20TokenInfo.tokenAddr);
      return Future<String>.value(accountInfo.data.balance);
    }else{
      var accountInfo = await _getAccountInfo(_address);
      return Future<String>.value(accountInfo.data.balance);
    }
  }

  Future<Tuple2<int,int>> getNonce() async{
    var accountInfo = await _getAccountInfo(_address);
    return Future<Tuple2<int,int>>.value(Tuple2<int,int>(int.parse(accountInfo.data.nonce),int.parse(accountInfo.data.localNonce)));
  }

  //使用关键字查询所有的ERC20代币
  Future<List<$erc20.Data>> getAllERC20Tokens(String keyword,int pageNumber ,int pageSize) async{
    String url = endPoint + erc20Info;
    Map<String,String> params = new Map<String,String>();
    params["tokenNameOrAddr"] = keyword;
    params["pageNum"] = pageNumber.toString();
    params["pageSize"] = pageSize.toString();
    var response = await httpPost(url,params);
    $erc20.ERC20TokenInfo tokenInfo = $erc20.ERC20TokenInfo.fromJson(response);
    return Future<List<$erc20.Data>>.value(tokenInfo.data);
  }
  //枚举此用户已添加的所有ERC20代币
  List<$erc20.Data> getAddedERC20Token(){
    return _addedERC20Tokens;
  }
  //添加ERC20代币
  void addERC20Token($erc20.Data token){
    //简单的查重，不清楚dart有没有重载运算符==，待优化
    _addedERC20Tokens.forEach((f){
      if(f.tokenAddr == token.tokenAddr) throw JUBR_ALREADY_EXITS;
    });
    _addedERC20Tokens.add(token);
    updateSelf();
  }
  //删除已添加的ERC20代币
  void delERC20Token($erc20.Data token){
    _addedERC20Tokens.remove(token);
    updateSelf();
  }

}