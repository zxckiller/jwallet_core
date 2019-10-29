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
import './Model/e_t_h_history.dart' as $history;
import './Model/miner_fee.dart' as $minerfee;

class JWalletETH extends JWalletBase with JInterfaceETH{
   static final CURVES curve = CURVES.secp256k1;
   static final String defaultPath = "m/44'/60'/0'";
   static final int chainID = 0;
   static final int decimal = 18;

   List<$erc20.Data> _addedERC20Tokens = new List<$erc20.Data>();
   List<$history.TxList> _txList = new List<$history.TxList>();
   final String accountInfoUrl = "/api/v2/queryAccountInfoByAddr";
   final String erc20Info = "/api/v2/queryTokensByNameOrAddr";
   final String historyUrl = "/api/v2/queryTransactionsByAddrs/breif";
   final String minerFeeUrl = "/api/getMinerFeeEstimations";

   String _address = "";

  JWalletETH(String endPoint,JInterfaceKeyStore keyStoreimpl):super(endPoint,keyStoreimpl){
    wType = WalletType.ETH;
    mainPath = defaultPath;
  }

   //Json构造函数
  JWalletETH.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
      _address = json["address"];
    //构造子类特有数据
      (json["addedERC20Tokens"] as List<dynamic>).forEach(
        (f) => _addedERC20Tokens.add($erc20.Data.fromJson(f))
      );

      (json["txList"] as List<dynamic>).forEach(
        (f) => _txList.add($history.TxList.fromJson(f))
      );
  }
  
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["addedERC20Tokens"] = _addedERC20Tokens;
    json["txList"] = _txList;
    json["address"] = _address;
    return json;
  }
  
  String getMainPath(){
    return mainPath;
  }

  @override
  Future<bool> init({String mainPath, String uuid,int deviceID}) async{
    await super.init();
    if(mainPath != null) this.mainPath = mainPath;
    //去取地址
    bool rv = await active(uuid:uuid,deviceID:deviceID);
    //把取到的地址，存起来
    if(rv) await updateSelf();
    return Future<bool>.value(rv);
  }

  Future<String> wei2ETH(String wei,int decimal){
    return  BigDecimal.bigNumberDivide(wei,decimal);
  }

  Future<String> eth2Wei(String eth,int decimal){
    return BigDecimal.bigNumberMultiply(eth, decimal);
  }

  Future<bool> active({String uuid,int deviceID}) async{
    switch (keyStore.type()) {
      
      case KeyStoreType.Blade:
      {
        if(uuid == null || deviceID == null) return Future<bool>.value(false);
        if(uuid != keyStore.getUUID()) return Future<bool>.value(false);
        ContextCfgETH config = ContextCfgETH.create();
        config.chainID = chainID;
        config.mainPath = mainPath;
        ResultInt contextResult = await JuBiterEthereum.createContext(config,deviceID);
        if(contextResult.stateCode == JUBR_OK){
          contextID = contextResult.value;
        }else{
          return Future<bool>.value(false);
        }
      }
      break;
      case KeyStoreType.LocalDB:
      {
        String xprv = keyStore.getXprv();
        ContextCfgETH config = ContextCfgETH.create();
        config.chainID = chainID;
        config.mainPath = mainPath;
        ResultInt contextResult = await JuBiterEthereum.createContext_Software(config,xprv);
        if(contextResult.stateCode == JUBR_OK){
          contextID = contextResult.value;
        }else{
          return Future<bool>.value(false);
        }
      }
      break;
      
      default:
        return Future<bool>.value(false);
    }

    String address = await _getAddressFromKeystore();
    if(_address == ""){ //第一次创建
      _address = address;
    }else{
      if(_address != address)//DB里面有了address，不知道出了什么错误（可能硬件重新初始化了，uuid没变，但是address变了），本次读出来与保存的不同
        throw JUBR_ERROR;
    }
    return Future<bool>.value(true);
  }

  Future<String> _getAddressFromKeystore()async{
    Bip32Path path = Bip32Path.create();
    path.change = false;
    path.addressIndex = $fixnum.Int64(0);
    ResultString address = await JuBiterEthereum.getAddress(contextID, path, false);
    if(address.stateCode == JUBR_OK){
      _address = address.value;
      //_address ="0xc874c758c0bf07f003cff4ddf1d964560138ba79";//for_test
      return Future<String>.value(_address);
    }else throw address.stateCode;
  }

  Future<String> getAddress() async{
    return Future<String>.value(_address);
  }

  //底层的ETHBuildERC20Abi接口需要修改，增加外部设置token数据的功能
  Future<ResultString> buildERC20Abi($erc20.Data info,String address, String amountInWei) async {
    return JuBiterPlugin.ETHBuildERC20Abi(contextID, address, amountInWei);
  }

  Future<ResultString> signTX(String password,TransactionETH txInfo) async{
    if(! await keyStore.verifyPin(contextID,password)) throw JUBR_WRONG_PASSWORD;
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
  void addERC20Token($erc20.Data token) async{
    //简单的查重，可以改成重载==，待优化
    _addedERC20Tokens.forEach((f){
      if(f.tokenAddr == token.tokenAddr) throw JUBR_ALREADY_EXITS;
    });
    _addedERC20Tokens.add(token);
    await updateSelf();
  }
  //删除已添加的ERC20代币
  void delERC20Token($erc20.Data token)async{
    _addedERC20Tokens.remove(token);
    await updateSelf();
  }

  //查询本地交易历史，暂时只支持ETH，回头统一改

  List<$history.TxList> getLocalHistory(){
    return _txList;
  }

  //查询网络交易历史
  Future<List<$history.TxList>> getCloudHistory(int pageSize,{$erc20.Data tokenInfo,$history.TxList lastTX}) async{
    String url = endPoint + historyUrl;
    Map<String,String> params = new Map<String,String>();
    params["address"] = _address;
    params["pageSize"] = pageSize.toString();
    //不知道有什么优雅的写法没，双问号？
    if(tokenInfo != null){
      params["contractAddress"] = tokenInfo.tokenAddr;
    }
    if(lastTX != null){
      params["blockIndex"] = lastTX.blkIndex.toString();
      params["txIndex"] = lastTX.txIndex.toString();
    }

    var response = await httpPost(url,params);
    $history.ETHHistory history = $history.ETHHistory.fromJson(response);
    List<$history.TxList> allHistory = new List<$history.TxList>();
    //如果是第一次查，把mempool也加上
    if(lastTX == null) allHistory += history.data.mempoolTxs.txList;

    allHistory += history.data.blockTxs.txList;
    //如果是ETH第一次查，存起来
    if(tokenInfo ==null && lastTX == null){
      _txList = allHistory;
      await updateSelf();
    }
    return Future<List<$history.TxList>>.value(allHistory);
  }

  Future<$minerfee.Data> getMinerFee() async{
    String url = endPoint + minerFeeUrl;
    Map<String,String> params = new Map<String,String>();
    var response = await httpPost(url,params);
    $minerfee.MinerFee  fee = $minerfee.MinerFee.fromJson(response);
    return Future<$minerfee.Data>.value(fee.data);
  }
}