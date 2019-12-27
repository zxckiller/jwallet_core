import 'package:flutter/foundation.dart';
import 'package:jwallet_core/JWallet/ETH/JWalletERC20.dart';
import 'package:jwallet_core/JWallet/ETH/Model/account_info.dart' as accountInfoData;
import 'package:tuple/tuple.dart';
import 'dart:convert';

import '../../jwallet_core.dart';
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

class JWalletETH extends JWalletBase with JInterfaceETH {
  static final CURVES curve = CURVES.secp256k1;
  static final String defaultPath = "m/44'/60'/0'";
  static final int chainID = 0;
  static final int decimal = 18;

  List<$history.TxList> _txList = new List<$history.TxList>();
  final String accountInfoUrl = "/api/v2/queryAccountInfoByAddr";
  final String batchAccountInfoUrl = "/api/v2/queryAccountInfoByAddrs";
  final String erc20InfoUrl = "/api/v2/queryTokensByNameOrAddr";
  final String historyUrl = "/api/v2/queryTransactionsByAddrs/breif";
  final String minerFeeUrl = "/api/getMinerFeeEstimations";

  String _address = "";

  JWalletETH(String name, String mainPath, String endPoint, JInterfaceKeyStore keyStoreimpl)
      : super(name, mainPath ?? defaultPath, endPoint, keyStoreimpl) {
    wType = WalletType.ETH;
  }

  //Json构造函数
  JWalletETH.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    _address = json["address"];
    balance = json["balance"];
    //构造子类特有数据
    (json["txList"] as List<dynamic>).forEach((f) => _txList.add($history.TxList.fromJson(f)));
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["txList"] = _txList;
    json["address"] = _address;
    return json;
  }

  @override
  Future<bool> init({String deviceMAC, int deviceID}) async {
    await super.init();
    //去取地址
    bool rv = await active(deviceMAC: deviceMAC, deviceID: deviceID);
    //把取到的地址，存起来
    if (rv) await updateSelf();
    return Future<bool>.value(rv);
  }

  @override
  Future<bool> active({String deviceMAC, int deviceID}) async {
    switch (keyStore.type()) {
      case KeyStoreType.Blade:
        {
          if (deviceMAC == null || deviceID == null) return Future<bool>.value(false);
          if (deviceMAC != keyStore.getDeviceMAC()) return Future<bool>.value(false);
          ContextCfgETH config = ContextCfgETH.create();
          config.chainID = chainID;
          config.mainPath = mainPath;
          ResultInt contextResult = await JuBiterEthereum.createContext(config, deviceID);
          if (contextResult.stateCode == JUBR_OK) {
            contextID = contextResult.value;
          } else {
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
          ResultInt contextResult = await JuBiterEthereum.createContext_Software(config, xprv);
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

    String address = await _getAddressFromKeystore();
    if (_address == "") {
      //第一次创建
      _address = address;
    } else {
      if (_address !=
          address) //DB里面有了address，不知道出了什么错误（可能硬件重新初始化了，deviceMAC没变，但是address变了），本次读出来与保存的不同
        throw JUBR_ERROR;
    }
    return Future<bool>.value(true);
  }

  Future<String> _getAddressFromKeystore() async {
    Bip32Path path = Bip32Path.create();
    path.change = false;
    path.addressIndex = $fixnum.Int64(0);
    ResultString address = await JuBiterEthereum.getAddress(contextID, path, false);
    if (address.stateCode == JUBR_OK) {
      //_address ="0xc874c758c0bf07f003cff4ddf1d964560138ba79";//for_test
      return Future<String>.value(address.value);
    } else
      throw address.stateCode;
  }

  @override
  String getAddress() {
    return _address;
  }

  @protected
  set address(String address) {
    _address = address;
  }

  //通用的获取AccountInfo的方法
  @protected
  Future<AccountInfo> getAccountInfoGeneric(String address, {String erc20address}) async {
    String url = endPoint + accountInfoUrl;
    Map<String, String> params = new Map<String, String>();
    params["address"] = _address;
    params["contractAddress"] = erc20address;
    var response = await httpPost(url, params);
    var accountInfo = AccountInfo.fromJson(response);
    return Future<AccountInfo>.value(accountInfo);
  }

  // 批量获取账户信息
  @protected
  Future<AccountInfo> getBatchAccountInfoGeneric(String address,
      {List<String> erc20AddressList}) async {
    String url = endPoint + batchAccountInfoUrl;
    Map<String, String> params = new Map<String, String>();
    params["address"] = _address;

    String contractAddress = '';
    erc20AddressList.forEach((element) {
      contractAddress += ('\"$element\",');
    });
    // 去除尾部逗号
    contractAddress = (contractAddress.substring(0, contractAddress.length - 1));
    contractAddress = '[$contractAddress]';

    params["contractAddrs"] = contractAddress;
    var response = await httpPost(url, params);
    print('[core] response: $response');
    var accountInfo = AccountInfo.fromJson(response);
    return Future<AccountInfo>.value(accountInfo);
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    return getAccountInfoGeneric(_address);
  }

  @override
  Future<String> getCloudBalance() async {
    var accountInfo = await getAccountInfoGeneric(_address);
    balance = accountInfo.data.balance;
    return Future<String>.value(balance);
  }

  /// 批量获取币种信息
  Future<accountInfoData.Data> getBatchBalance() async {
    List<String> coinList = enumWallets();
    List<String> contractList = [];
    coinList.forEach((element) {
      Map<String, dynamic> map = json.decode(element);
      contractList.add(map['erc20Info']['token_addr']);
    });
    var acountInfo = await getBatchAccountInfoGeneric(_address, erc20AddressList: contractList);
    return Future<accountInfoData.Data>.value(acountInfo.data);
  }

  @override
  String getLocalBalance() {
    return balance;
  }

  @override
  Future<Tuple2<int, int>> getNonce() async {
    var accountInfo = await getAccountInfoGeneric(_address);
    return Future<Tuple2<int, int>>.value(Tuple2<int, int>(
        int.parse(accountInfo.data.nonce), int.parse(accountInfo.data.localNonce)));
  }

  @override
  Future<ResultString> getMainHDNode(ENUM_PUB_FORMAT format) async {
    return await JuBiterEthereum.getMainHDNode(contextID, format);
  }

  @override
  Future<ResultString> getHDNode(ENUM_PUB_FORMAT format) async {
    Bip32Path path = Bip32Path.create();
    path.change = false;
    path.addressIndex = $fixnum.Int64(0);
    return await JuBiterEthereum.getHDNode(contextID, format, path);
  }

  //使用关键字查询所有的ERC20代币
  @override
  Future<List<$erc20.Data>> getAllERC20Tokens(String keyword, int pageNumber, int pageSize) async {
    String url = endPoint + erc20InfoUrl;
    Map<String, String> params = new Map<String, String>();
    params["tokenNameOrAddr"] = keyword;
    params["pageNum"] = pageNumber.toString();
    params["pageSize"] = pageSize.toString();
    var response = await httpPost(url, params);
    $erc20.ERC20TokenInfo tokenInfo = $erc20.ERC20TokenInfo.fromJson(response);
    return Future<List<$erc20.Data>>.value(tokenInfo.data);
  }

  //添加ERC20代币
  @override
  Future<String> addERC20Token($erc20.Data token) async {
    //简单的查重
    List<String> addeds = enumAddedERC20Tokens();
    addeds.forEach((added) {
      var _json = json.decode(added);
      if (_json["erc20Info"]["token_addr"] == token.tokenAddr) throw JUBR_ALREADY_EXITS;
    });
    JWalletERC20 erc20Wallet = new JWalletERC20(this, token);
    //在walletManager中添加钱包
    String walletName = await getJWalletManager().addWallet(erc20Wallet);
    //映射这个wallet
    bool success = await addWallet(walletName);
    if (!success) throw JUBR_HOST_MEMORY;
    return Future<String>.value(walletName);
  }

  //枚举此用户已添加的所有ERC20代币
  @override
  List<String> enumAddedERC20Tokens() {
    return enumWallets();
  }

  //删除已添加的ERC20代币
  @override
  Future<bool> removeERC20Token(String wallet) async {
    return removeWallet(wallet);
  }

  //获取一个ERC20代币的wallet
  @override
  Future<JWalletERC20> getErc20TokenWallet(String wallet) async {
    return getWallet<JWalletERC20>(wallet);
  }

  //通用查询网络交易历史
  @protected
  Future<List<$history.TxList>> getCloudHistoryGeneric(int pageSize,
      {$erc20.Data tokenInfo, $history.TxList lastTX}) async {
    String url = endPoint + historyUrl;
    Map<String, String> params = new Map<String, String>();
    params["address"] = _address;
    params["pageSize"] = pageSize.toString();
    //不知道有什么优雅的写法没，双问号？
    if (tokenInfo != null) {
      params["contractAddress"] = tokenInfo.tokenAddr;
    }
    if (lastTX != null) {
      params["blockIndex"] = lastTX.blkIndex.toString();
      params["txIndex"] = lastTX.txIndex.toString();
    }

    var response = await httpPost(url, params);
    $history.ETHHistory history = $history.ETHHistory.fromJson(response);
    List<$history.TxList> allHistory = new List<$history.TxList>();
    //如果是第一次查，把mempool也加上
    if (lastTX == null) allHistory += history.data.mempoolTxs.txList;

    allHistory += history.data.blockTxs.txList;
    //如果是ETH第一次查，存起来
    if (tokenInfo == null && lastTX == null) {
      _txList = allHistory;
      await updateSelf();
    }
    return Future<List<$history.TxList>>.value(allHistory);
  }

  @override
  List<$history.TxList> getLocalHistory() {
    return _txList;
  }

  @override
  Future<List<$history.TxList>> getCloudHistory(int pageSize, {$history.TxList lastTX}) async {
    return getCloudHistoryGeneric(pageSize, lastTX: lastTX);
  }

  @override
  Future<$minerfee.Data> getMinerFee() async {
    String url = endPoint + minerFeeUrl;
    Map<String, String> params = new Map<String, String>();
    var response = await httpPost(url, params);
    $minerfee.MinerFee fee = $minerfee.MinerFee.fromJson(response);
    return Future<$minerfee.Data>.value(fee.data);
  }

  @override
  Future<TransactionETH> buildTx(
      String to, String valueInWei, String gasPriceInWei, String input) async {
    Bip32Path bip32path = Bip32Path.create();
    bip32path.change = false;
    bip32path.addressIndex = $fixnum.Int64(0);
    TransactionETH txInfo = TransactionETH.create();
    txInfo.path = bip32path;
    txInfo.nonce = (await getNonce()).item1;
    txInfo.gasLimit = 27800;
    txInfo.gasPriceInWei = gasPriceInWei;
    txInfo.to = to;
    txInfo.valueInWei = valueInWei;
    txInfo.input = input ?? "";
    return Future<TransactionETH>.value(txInfo);
  }

  @override
  Future<ResultString> signTX(String password, TransactionETH tx) async {
    if (!await keyStore.verifyPin(contextID, password)) throw JUBR_WRONG_PASSWORD;
    return await JuBiterEthereum.signTransaction(contextID, tx);
  }

  Future<String> wei2ETH(String wei, int decimal) {
    return BigDecimal.bigNumberDivide(wei, decimal);
  }

  Future<String> eth2Wei(String eth, int decimal) {
    return BigDecimal.bigNumberMultiply(eth, decimal);
  }
}
