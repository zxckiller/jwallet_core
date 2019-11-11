import 'package:tuple/tuple.dart';

import 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';

import '../JWalletERC20.dart';


import '../Model/e_r_c20_token_info.dart' as $erc20;
import '../Model/e_t_h_history.dart' as $history;
import '../Model/account_info.dart';
import '../Model/miner_fee.dart' as $minerfee;
//所有ETH钱包都需要实现此接口
abstract class JInterfaceETH {
  //获取地址
  String getAddress();
  //获取主公钥
  Future<ResultString> getMainHDNode(ENUM_PUB_FORMAT format);
  //获取某个Path的公钥
  Future<ResultString> getHDNode(ENUM_PUB_FORMAT format);
  //获取钱包余额
  Future<String> getBalance();
  //获取Nonce与localNonce
  Future<Tuple2<int,int>> getNonce();
  //获取AccountInfo
  Future<AccountInfo> getAccountInfo();
  //获取本地缓存的交易历史
  List<$history.TxList> getLocalHistory();
  //获取网络上的交易历史
  Future<List<$history.TxList>> getCloudHistory(int pageSize,{$history.TxList lastTX});
  //获取交易手续费
  Future<$minerfee.Data> getMinerFee();
  //构建交易
  Future<TransactionETH> buildTx(String to,String valueInWei,String gasPriceInWei,String input);
  //签名交易
  Future<ResultString> signTX(String password,TransactionETH tx);


  //获取ERC20代币信息
  Future<List<$erc20.Data>> getAllERC20Tokens(String keyword,int pageNumber ,int pageSize);
  //添加一个ERC20代币
  Future<bool> addERC20Token($erc20.Data token);
  //获取所有已添加的ERC20代币
  List<String> enumAddedERC20Tokens();
  //删除已添加的ERC20代币
  Future<bool> removeERC20Token(String wallet);
  //获取一个ERC20 wallet
  Future<JWalletERC20> getErc20TokenWallet(String wallet);
}